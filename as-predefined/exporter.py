from sys import argv
import json
from pathlib import Path
import argparse


# Used to replace operator* with proper AS' operator declarations
# Not sure why Strata uses operator* when the proper syntax is opAssign, opIndex, opAdd, etc
OPERATOR_REPLACE = {
    "operator~": "opCom",
            
    # Postfixed unary operators
    "operator++": "opPostInc",     
    "operator--": "opPostDec",
            
    # Comparison Operators
    "operator==": "opEquals",
    "operator!=": "opEquals",
    "operator<": "opCmp",
    "operator<=": "opCmp",
    "operator>": "opCmp",
    "operator>=": "opCmp",
            
    # Assignment operators
    "operator=": "opAssign",
    "operator+=": "opAddAssign",
    "operator-=": "opSubAssign",
    "operator*=": "opMulAssign",
    "operator/=": "opDivAssign",
    "operator%=": "opModAssign",
    "operator**=": "opPowAssign",
    "operator&=": "opAndAssign",
    "operator|=": "opOrAssign",
    "operator^=": "opXorAssign",
    "operator<<=": "opShlAssign",
    "operator>>=": "opShrAssign",
    "operator>>>=": "opUShrAssign",
    "operator@=": "opHndlAssign",

    # Binary operators
    "operator+": "opAdd",
    "operator-": "opSub",
    "operator*": "opMul",
    "operator/": "opDiv",
    "operator%": "opMod",
    "operator**": "opPow",
    "operator&": "opAnd",
    "operator|": "opOr",
    "operator^": "opXor",
    "operator<<": "opShl",
    "operator>>": "opShr",
    "operator>>>": "opUShr",

    # Index operator
    "operator[]": "opIndex",
}

class Decl_Enum:
    def __init__(self, decl: dict):
        self.namespace = decl["namespace"]
        self.namespace = self.namespace if self.namespace else "__global__" # Ensure not None


        self.name = decl["name"]
        self.values: dict[str] = decl["value"]

        self.id = self.namespace if not self.namespace == "__global__" else ""
        self.id += self.name

        try:
            self.documentation = decl["documentation"] # Future support for enum docs
        except:
            self.documentation = ""


    def serialize(self): # Serializes as string, ignores namespace

        # //Documentation
        # enum name {
        # ...

        r = "//" + self.documentation + "\n" if self.documentation else ""
        r += "enum " + self.name + " {\n"

        for key, value in self.values.items():
            #   ...
            #   //Documentation
            #   Name = value,
            #   ...

            try: # Future support for documentation about enum's values
                r += "    //" + value["documentation"] + "\n" if value["documentation"] else ""
                r += "  " + key + " = " + stringify(value["value"]) + ",\n"
            except (KeyError, TypeError):
                r += "    " + key + " = " + stringify(value) + ",\n"

        r = r[:-2] # Remove two last chars ( ",\n" )
        r += "\n}"
        return r



class Decl_Function:
    def __init__(self, decl: dict):
        try: # This class also represents methods which don't have a namespace
            self.namespace = decl["namespace"]
        except KeyError:
            self.namespace = "__global__" # Treating it as __global__ will make the script skip the namespace entirely

        self.namespace = self.namespace if self.namespace else "__global__" # Ensure not None

        self.name = decl["name"]
        self.documentation = decl["documentation"]

        declaration: str = decl["declaration"]

        temp = declaration.split(" ")
        for temp_ in temp:
            if "(" in temp_: # We hit the function name, I assume that the function doesn't have a space between the name and the parenthesis
                break 
        
        return_val_id = declaration.index(temp_) - 1 # Find function name and go back one
        self.return_val = declaration[:return_val_id]

        # In case we have a parenthesis inside a parenthesis like in array.sort
        func_body_end = declaration[::-1].index(")") # Go backwards when finding
        func_body_end = len(declaration) - func_body_end - 1
        func_body = declaration[return_val_id + 1:func_body_end]

        p_index = func_body.index("(")
        self.func_name = func_body[:p_index]

        if self.namespace != "__global__" and "::" in self.func_name:
            self.func_name = self.func_name[len(self.namespace) + 2:]

        self.args = func_body[p_index + 1:]

        try:
            self.decorators = declaration[func_body_end + 2:]
        except IndexError:
            self.decorators = ""

    def serialize(self):
        r = "//" + self.documentation + "\n" if self.documentation else ""
        r += self.return_val + " "

        if self.func_name in OPERATOR_REPLACE.keys():
            r += OPERATOR_REPLACE[self.func_name]
        else:
            r += self.func_name

        r += "(" + self.args + ")"
        
        if self.decorators:
            r += " " + self.decorators
        
        r += ";"

        return r


class Decl_Class:
    def __init__(self, decl: dict):
        self.namespace = decl["namespace"]
        self.namespace = self.namespace if self.namespace else "__global__" # Ensure not None
        self.name = decl["name"]
        self.methods = []
        try:
            self.documentation = decl["documentation"]
        except KeyError:
            self.documentation = ""


        if "method" in decl.keys(): # Some classes don't have methods
            for method in decl["method"]:
                self.methods.append(Decl_Function(method)) # We can treat methods as functions, syntax exporting is the same

        self.is_template = "template_parameter" in decl.keys()
        if self.is_template:
            self.templates = []
            for template in decl["template_parameter"]:
                self.templates.append((template["type"], template["name"]))

        self.requires_class = "base_type" in decl.keys()
        if self.requires_class:
            self.requires = (decl["base_type"]["namespace"] if decl["base_type"]["namespace"] else "__global__"), decl["base_type"]["name"]

    def serialize(self):
        r = "// " + self.documentation + "\n" if self.documentation else ""
        r += "class " + self.name

        if self.is_template:
            r += "<"
            for template in self.templates:
                r += template[1] + ", "
            
            r = r[:-2] # Remove last ", "
            r += "> "
        else:
            r += " "


        if self.requires_class:
            if self.namespace == self.requires[0]: # Namespaces match, we are in a namespace block 
                r += ": " + self.requires[1] + " {\n"
            else:
                r += ": " + self.requires[0] + "::" + self.requires[1] + " {\n"

        else:
            r += "{\n"
        

        for method in self.methods:
            r += "    " + method.serialize() + "\n"

        r += "}\n"
        
        return r



def stringify(s) -> str:
    """Custom ways to convert a type to string"""
    match s:
        case str():
            return s
        
        case bool():
            return "true" if s else "false" # Python has uppercase True or False
        
        case int():
            return str(s)
        
        case _:
            return str(s)


def main():

    parser = argparse.ArgumentParser(
        prog="as.predefined exporter for Strata Source",
        description="Builds the as.predefined file for usage with the sashi0034/AngelScript Language Server extension for vscode"
    )

    parser.add_argument(
        "-o", "--output",
        action="store",
        dest="output_file",
        help="Location of the output file."
    )

    parser.add_argument(
        "inputfile",
        help="Path to the input json file that contains the api reference."
    )

    argresult = parser.parse_args(argv[1:])


    fpath = Path(argresult.inputfile)
    outpath = Path(argresult.output_file) if argresult.output_file else fpath.with_name("as.predefined")


    if not fpath.is_file():
        raise RuntimeError("No valid file api reference file specified!")
    
    file = None

    with open(fpath, "r") as file_opened:
        file = json.loads(file_opened.read())


    # BEGIN PARSING

    NAMESPACES = ["__global__"] + file["namespace"] # special identifier for the global namespace

    PER_NAMESPACE_DECL = {}

    for namespace in NAMESPACES:
        PER_NAMESPACE_DECL[namespace] = {
            "enum": [],
            "function": [],
            "type": []
        }


    ALL_DEFINED = []

    ENUMS = file["enum"]

    for enum in ENUMS:
        enum = Decl_Enum(enum)
        ALL_DEFINED.append(enum)
        PER_NAMESPACE_DECL[enum.namespace]["enum"].append(enum)

    FUNCTIONS = file["function"]

    for function in FUNCTIONS:
        function = Decl_Function(function)
        ALL_DEFINED.append(enum)
        PER_NAMESPACE_DECL[function.namespace]["function"].append(function)

    TYPES = file["type"]

    for type_ in TYPES:
        type_ = Decl_Class(type_)
        ALL_DEFINED.append(enum)
        PER_NAMESPACE_DECL[type_.namespace]["type"].append(type_)


    # Now, we have everything in order, we export __global__ first
    EXPORTED_TYPES = []
    with open(outpath, "w") as outfile:
        outfile.write(export_namespace(PER_NAMESPACE_DECL["__global__"], None, EXPORTED_TYPES))
        outfile.write("\n")

        for namespace_ in PER_NAMESPACE_DECL.keys():
            namespace = str(namespace_)
            
            if namespace == "__global__":
                continue
                
            outfile.write(export_namespace(PER_NAMESPACE_DECL[namespace_], namespace, EXPORTED_TYPES))
            outfile.write("\n")

        # Now we handle types that depend on one another
        for _ in range(len(TYPES) + 1): # The worst case scenario we have a long chain of types that depend on one another
            outfile.write(export_namespace(PER_NAMESPACE_DECL[namespace_], namespace, EXPORTED_TYPES, True))
            outfile.write("\n")
            if len(EXPORTED_TYPES) == len(TYPES):
                break # We exported everything
            # If we don't manage to export them in this loop, it means that we're missing declarations
        
        outfile.write("\n")




def export_namespace(namespace, namespace_name, exported_types, only_types = False):
    """Exports the given namespace, updates the exported_types list."""
    r = "namespace " + namespace_name + " {\n" if  namespace_name else "" # If None, we are in global namespace
    
    tab = "    " if namespace_name else ""

    # Order is: enums, types, functions
    if not only_types:
        for enum in namespace["enum"]:
            for line in enum.serialize().splitlines():
                r += tab + line + "\n"

            r += "\n"

    type_: Decl_Class
    a = r
    for type_ in namespace["type"]: # We export everything we can, leaving other stuff for now

        if type_.requires_class: # type_.requires may be undefined
            if type_.requires[1] in exported_types:
                for line in type_.serialize().splitlines():
                    r += tab + line + "\n"

                exported_types.append(type_.name)

        else:
            for line in type_.serialize().splitlines():
                r += tab + line + "\n"
            
            exported_types.append(type_.name)

        r += "\n"
    if r == a and only_types: # If we didn't add anything don't export anything, no need for `namespace x{} \n namespace x{} \n ...`
        return ""

    if not only_types:
        for function in namespace["function"]:
            for line in function.serialize().splitlines():
                r += tab + line + "\n"

            r += "\n"

    r = r[:-1] if namespace_name else r
    r += "}" if namespace_name else ""

    return r


main()
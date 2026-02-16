// --------------------------------
// Purpose: Provide an additional functions for char/string manipulation.
// --------------------------------

uint64 min(uint64 a, uint64 b) { //TODO: move into math
    return a < b ? a : b;
}

typedef uint8 char;

namespace char {
    // Convert char (uint8) to char string (string of length one).
    string StrCharFromInt(const char c) {
        string a = "0";
        a[0] = c;
        return a;
    }

    // Convert char to int.
    char IntFromChar(const string c) {
        return c[0];
    }
}

namespace str {

    int64 __unqstrnum = 0;
    /* Get a unique string, guaranteed to be different from every other string returned by this function.
        Returns a string in format: "UNQ_i" where i is the nth unique string.
    */
    string GetUnique() {
        __unqstrnum += 1;
        return "UNQ_" + __unqstrnum;
    }

    /* Reads first int from the string, returns int in base 10, but can read in a different base.
    Parameters: const string&in s - input string to read from
                const uint base = 10 - base to read in
    Throws an error when no integer was found.
    */ 
    int64 readInt(const string&in s, const uint base = 10) {
        string _;
        return str::readInt(s, _, base);
    }
    
    /* Reads first int from the string, returns int in base 10, but can read in a different base.
    Parameters: const string&in s - input string to read from
                string&out s_out - output substring with everything removed until (including) the number
                const uint base = 10 - base to read in
    Throws an error when no integer was found.
    */
    int64 readInt(const string&in s, string&out s_out, const uint base = 10) {
        // Valid numbers:
        const char base_start = 48; //Char 0
        const char max_char = 57; // Ends at char 9 - 58
        const char ext_base_start = 65; // Char A
        const char ext_max_char = 90; //Char Z

        const uint8 shift = ext_base_start - max_char - 1;
        // Useful for shifting the value, so that A will correspond to char 58 and we gain linearity again

        if (base < 2 || base > ext_max_char - ext_base_start + base - 11) { // Here we are running out of characters to denote numbers
            throw("Invalid base!");
            return 0;
        }

        char base_end = 0;

        if (base <= 10) { // We aren't using extended base
            base_end = base_start + base - 1; // Max 57
        } else {
            base_end = ext_base_start + base - 11; // Max 90
        }

        int64 result = 0;
        uint i = 0;
        bool locked = false;

        for (; i < s.length(); i++) {
            char t = s[i];
            
            if (t < base_start || t > base_end || // Doesn't belong to <48, 57> u <65, 90>
                (t > max_char && t < ext_base_start)
            ) {
                if (locked) {
                    break;
                } else {
                    continue;
                }
            }

            locked = true;
            result *= base;

            if (t >= base_start && t <= max_char) { // If we belong to 0-9
                result += t - base_start;
            } else { // If we are using A-Z
                result += t - shift - base_start;
            }
        }

        if (!locked) {
            throw("Did not find any integer to read!");
        }

        s_out = s.substr(i);
        return result;
    }

    // Translates keys to appropriate bool values
    const dictionary BOOL_TRANSLATE = {
        {"True", true},
        {"False", false},
        {"true", true},
        {"false", false},
        {"1", true},
        {"0", false},
        {"yes", true},
        {"no", false}
    };

    // Read boolean from string. Check BOOL_TRANSLATE for reference what gets treated as a valid boolean in a string.
    // Throws an exception if no boolean was found to read.
    bool readBool(const string&in s) {
        string _;
        return readBool(s, _);
    }

    // Read boolean from string. Check BOOL_TRANSLATE for reference what gets treated as a valid boolean in a string.
    // Second string is an output that contains a substring with everything up until (including) the read boolean removed.
    // Throws an exception if no boolean was found to read.
    bool readBool(const string&in s, string&out s_out) {
        
        string substr_ = "";
        uint i = 0;

        array<string>@ keys = BOOL_TRANSLATE.getKeys();
        uint max_key_len = 0;
        for(uint i_ = 0; i_ < keys.length(); i_++) {
            uint keylen = keys.length();
            if (keylen > max_key_len) {
                max_key_len = keylen;
            }
        }

        for(; i < s.length(); i++) { // We need to do a swipe with varying length 
            for(uint j = 0; j < min(i, max_key_len); j++) { // Fortunately we know we don't have to check any keywords longer than the max key length
                string subs = s.substr(j, i + 1);
                if(BOOL_TRANSLATE.exists(subs)) {
                    s_out = s.substr(i + 1);
                    return bool(BOOL_TRANSLATE[subs]);
                }
            }
        }

        throw("No boolean found to read!");
        return false;

    }
}
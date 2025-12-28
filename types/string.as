// --------------------------------
// Purpose: Provide an extended string/char class with more functionality.
// --------------------------------


namespace PCS {

    class char {
        private uint8 ch = 0;

        char() {
            this.ch = 0;
        }

        char(uint8 inp) {
            this.ch = inp;
        }

        char(const ::string&in str) {
            if (str.length() > 2) {
                throw("Cannot initalize char from a string that has more than one character!");
            }

            this.ch = str[0];
        }

        char& opAssign(const ::string&in str) {
            if (str.length() > 2) {
                throw("Cannot initalize char from a string that has more than one character!");
            }

            this.ch = str[0];

            return this;
        }

        char& opAssign(uint8 inp) {
            this.ch = inp;

            return this;
        }

        const uint8 toInt() {
            return this.ch;
        }

        char& opAssign(char@ chr) {
            this.ch = chr.toInt();

            return this;
        }

    }

    #ifdef unfinished
    class string {

        private ::string i_str = ""; 

        // Operators
        string &opAssign(const ::string&in str) { // Assign a string
            this.i_str = str;
            return this;
        }

        string& opAssign(int64 num) { // Assign a number converted to string
            this.i_str = num;
        }

        string& opAssign(uint64 num) {
            this.i_str = num;
        }

        string& opAssign(double num) {
            this.i_str = num;
        }

        string& opAssign(float num) {
            this.i_str = num;
        }

        string& opAssign(char&in chr) {
            this.i_str = "0";
            this.i_str[0] = chr.toInt();
        }

        // End assignment operators




        int scan() {
            Msg("My string is: " + this.i_str);
            return 0;
        }

    }

    #endif
}
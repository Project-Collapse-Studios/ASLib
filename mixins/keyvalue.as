// --------------------------------
// Purpose: Provide a keyvalue reader/writer mixin class
// --------------------------------

mixin class Keyvalues : CBaseEntity {
    // Convenience class for easy keyvalue reading/writing.

    protected int MAX_KV_LENGTH = 512;
    
    string GetStrKeyvalue(const string key, const string _default = "") {
        
        // Generic reader
        string out_ = "";
        bool st = false;
        st = this.GetKeyValue(key, out_, MAX_KV_LENGTH);
        if (!st) {
            return _default;
        }
        // end

        return out_;
    }

    #ifdef unfinished
    int64 GetIntKeyvalue(const string key, const int _default = -1) {
        
        // Generic reader
        string out_ = "";
        bool st = false;
        st = this.GetKeyValue(key, out_, MAX_KV_LENGTH);
        if (!st) {
            return _default;
        }
        // end

        int result = _default;

        uint scanned = scan(out_, result);

    }

    #endif

}
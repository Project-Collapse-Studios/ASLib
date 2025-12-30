// --------------------------------
// Purpose: Provide a logger implementation for easier development.
// --------------------------------


class Logger {

    protected string name;
    protected int required_developer_level;

    // Create a logger with a given name, will print out messages as [scriptsys][name]: Message
    // required_developer_level = 0, Message will only print out when the developer convar is greator or equal to this value.
    Logger(string name, int required_developer_level = 0) {
        this.name = name;
    }

    // Internal method for retrieving developer level
    private int GetDeveloperLevel() {
        return 0;
    }

    // Print an info message to the console
    // string message - the message to print
    // string end - string that gets appended to the end of the message
    // int required_developer_level - This message will only print out when the developer convar is greator or equal to this value.
    // Additionally, any negative value will make it use the global required level passed in the constructor.
    void Info(string message, string end = "\n", int required_developer_level = -1) {
        int dv_lvl = this.GetDeveloperLevel();
        if (
            (required_developer_level > 0 && dv_lvl >= required_developer_level)
            || (required_developer_level < 0 && dv_lvl >= this.required_developer_level)
        ) {
            Msg(message + end);
        }

    }

    // Print an warning message to the console
    // string message - the message to print
    // string end - string that gets appended to the end of the message
    // int required_developer_level - This message will only print out when the developer convar is set to this value.
    // Additionally, any negative value will make it use the global required level passed in the constructor.
    void Warn(string message, string end = "\n", int required_developer_level = -1) {
        int dv_lvl = this.GetDeveloperLevel();
        if (
            (required_developer_level > 0 && dv_lvl >= required_developer_level)
            || (required_developer_level < 0 && dv_lvl >= this.required_developer_level)
        ) {
            Warning(message + end);
        }
    }

}
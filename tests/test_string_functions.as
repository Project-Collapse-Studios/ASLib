// --------------------------------
// Purpose: Test the char type.
// --------------------------------

#include "../misc/string.as"
#include "../misc/logger.as"

[ServerCommand("as_test_string_functions", "")]
void string_functions(CommandArgs@ args) {
    Logger logger("test_pcs_char");

    logger.Info("Char A, a " + char::IntFromChar("0") + ", " + char::IntFromChar("A"));
    logger.Info("" + 
        char::StrCharFromInt(57)
        //+ char::StrCharFromInt(59)
        //+ char::StrCharFromInt(60)  
        //+ char::StrCharFromInt(61)
    );

    logger.Info("Converting string '235' to int base 10: " + str::readInt("235"));
    string remains;
    logger.Info("Converting string '10AP1' to int base 16 (expecting 266): " + str::readInt("10AP1", remains, 16) + " remains: " + remains);

    logger.Info("Testing reading boolean from string 'false': " + str::readBool("false"));
    logger.Info("Testing reading boolean from string 'abcFalseabc': " + str::readBool("abcFalseabc", remains) + " remains: " + remains);
    logger.Info("Testing reading boolean from string 'abcTrueFalse': " + str::readBool("abcTrueFalse", remains) + " remains:" + remains);
}
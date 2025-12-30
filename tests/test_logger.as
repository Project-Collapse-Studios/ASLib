// --------------------------------
// Purpose: Test the logger in misc/logger.as
// --------------------------------


#include "../misc/logger.as"

[ServerCommand("as_logger_test", "")]
void main(const CommandArgs@ args) {
    Logger logger("Testlogger");

    logger.Info("This is a test message");
    logger.Warn("This is a test warning!");
}
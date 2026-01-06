// --------------------------------
// Purpose: Test the logger in misc/logger.as
// --------------------------------


#include "../misc/logger.as"

[ServerCommand("as_logger_test", "")]
void main(const CommandArgs@ args) {
    Logger logger("Testlogger");

    logger.Info("This is a test message");
    logger.Warn("This is a test warning!");

    logger.Info("This is a test message that will only print at developer 1!", 1);
    logger.Warn("This is a warning message that will only print at developer 1!", 1);

    logger.Info("This is a test message that will only print at developer 2!", 2);
    logger.Warn("This is a warning message that will only print at developer 2!", 2);

    Logger logger2("TestLogger2", 2);

    logger2.Info("This logger will only log on developer 2!");
}
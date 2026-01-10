/**
* @brief   Testing the assert function implementation.
* @details There is no proper assert function for AngelScript, so this is a small implementation that will throw then there is a error.
* @authors Orsell
*
* @license Distributed under the MIT license - Copyright (c) 2026 Project Collapse Studios
*/

#include "../misc/logger.as"
#include "../misc/assert.as"

[ServerCommand("as_test_assert", "Testing assert function functionality.")]
void TestAssertions(const CommandArgs@ args)
{
    Logger log("AssertTest_Logger");;

    log.Info("----------------------------------------");
    log.Info("Testing assert function functionality!");
    log.Info("\n");

    log.Info("// ---------- TEST 1: Testing Ideal Functionality");

    // Test ideal functionality (should pass).
    try
    {
        assert(true, "TEST 1-1: Pass test failed!");
        assert(1 + 1 == 2, "TEST 1-2: Pass test failed!");
        assert(10 > 3, "TEST 1-3: Pass test failed!");
        log.Info("[PASS] Ideal functionality test.");
    }
    catch
    {
        log.Warn("[FAIL] Ideal functionality threw unexpectedly: " + getExceptionInfo());
    }

    log.Info("\n");
    log.Info("// ---------- TEST 2: Testing Harder Logic Functionality");
    // Throw in something harder to work with, complex expressions and logic chains.
    try
    {
        int a = 5;
        int b = 10;
        bool complexCheck = (a * 2 == b) && (b / a == 2) && !(a > b);

        assert(complexCheck);

        array<int> values = { 1, 2, 3, 4, 5 };
        assert(values.length() == 5, "TEST 2-1: Pass test failed!");
        assert(values[2] == 3, "TEST 2-2: Pass test failed!");

        log.Info("[PASS] Complex logic test.");
    }
    catch
    {
        log.Warn("[FAIL] Complex logic test failed: " + getExceptionInfo());
    }

    log.Info("\n");
    log.Info("// ---------- TEST 3: Testing For Error Cases");
    // Test error cases (should fail).
    try
    {
        assert(false, "TEST 3-1: Error test pass!");
        log.Warn("[FAIL] Error case did NOT throw as expected!");
    }
    catch
    {
        log.Info("[PASS] Error case threw correctly: " + getExceptionInfo());
    }

    try
    {
        int x = 3;
        assert(x > 100, "TEST 3-2: Error test pass!"); // intentional failure
        log.Warn("[FAIL] Invalid comparison did NOT throw!");
    }
    catch
    {
        log.Info("[PASS] Invalid comparison threw correctly: " + getExceptionInfo());
    }

    log.Info("\n");
    log.Info("// ---------- TEST 4: Testing Stress Test Functionality");
    // Stress test, repeated calls, mixture of pass/fail.
    int failureCount = 0;
    int iterations = 10000;

    for (int i = 0; i < iterations; i++)
    {
        try
        {
            assert(i >= 0, "TEST 4-1: Pass test failed!"); // always true
            assert((i % 2 == 0) || (i % 2 == 1)); // always true
        }
        catch
        {
            failureCount++;
        }
    }

    // Intentional stress failures
    for (int i = 0; i < 100; i++)
    {
        try
        {
            assert(i < 0); // always false
        }
        catch
        {
            failureCount++;
        }
    }

    log.Info("Stress test iterations: " + iterations);
    log.Info("Stress test caught failures: (" + failureCount + "/100)");
    log.Info("If caught failures is greater or less than 100, then test failed!");

    log.Info("\n");
    log.Info("Assert function functionality testing completed!");
    log.Info("----------------------------------------\n");
}
/* Based on the example code supplieud with CUnit. */

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include <CUnit/Basic.h>


static int suite_success_init(void)
{
    return 0;
}


static int suite_success_clean(void)
{
    return 0;
}


static void testSuccess1(void)
{
    CU_ASSERT(1);
}


static void testSuccess2(void)
{
    CU_ASSERT(2);
}


static void testSuccess3(void)
{
    CU_ASSERT(3);
}


void add_tests(void)
{
    assert(NULL != CU_get_registry());
    assert(!CU_is_test_running());

    CU_pSuite pSuite;

    pSuite = CU_add_suite("suite_success_both", suite_success_init, suite_success_clean);
    CU_add_test(pSuite, "testSuccess1", testSuccess1);
    CU_add_test(pSuite, "testSuccess2", testSuccess2);
    CU_add_test(pSuite, "testSuccess3", testSuccess3);
}


int main(int argc, char* argv[])
{
    CU_BasicRunMode mode = CU_BRM_VERBOSE;
    CU_ErrorAction error_action = CUEA_IGNORE;

    setvbuf(stdout, NULL, _IONBF, 0);

    if (CU_initialize_registry()) {
        fprintf(stderr, "\nInitialization of Test Registry failed.");
	exit(EXIT_FAILURE);
    }
    
    add_tests();
    CU_basic_set_mode(mode);
    CU_set_error_action(error_action);
    CU_basic_run_tests();
    CU_cleanup_registry();

    return EXIT_SUCCESS;
}


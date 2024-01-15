cmake_minimum_required(VERSION 3.28)

project(tests VERSION 0.1.0)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
include(GoogleTest)
include(CTest)
include(LlvmSanitizers)

enable_testing() # Must be in main file

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
find_package(GTest CONFIG REQUIRED)


# # For Windows: Prevent overriding the parent project's compiler/linker settings
# set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

mark_as_advanced(
    BUILD_GMOCK BUILD_GTEST BUILD_SHARED_LIBS
    gmock_build_tests gtest_build_samples gtest_build_tests
    gtest_disable_pthreads gtest_force_shared_crt gtest_hide_internal_symbols
)

set_target_properties(GTest::gtest PROPERTIES FOLDER extern)
set_target_properties(GTest::gtest_main PROPERTIES FOLDER extern)
set_target_properties(GTest::gmock PROPERTIES FOLDER extern)
set_target_properties(GTest::gmock_main PROPERTIES FOLDER extern)

macro(package_add_test_with_libraries TESTNAME FILES LIBRARIES TEST_WORKING_DIRECTORY)
    add_executable(${TESTNAME} ${FILES})
    target_link_libraries(${TESTNAME} PRIVATE GTest::gtest GTest::gtest_main GTest::gmock GTest::gmock_main ${LIBRARIES})
    gtest_discover_tests(${TESTNAME}
        WORKING_DIRECTORY ${TEST_WORKING_DIRECTORY}
        PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${TEST_WORKING_DIRECTORY}"
    )
    set_target_properties(${TESTNAME} PROPERTIES FOLDER tests)
endmacro()

package_add_test_with_libraries(MainTest main_test.cpp core "${PROJECT_DIR}")

add_sanitizer("address")
add_sanitizer("leak")
add_sanitizer("undefined")
# add_sanitizer("thread")
cmake_minimum_required(VERSION 3.28)

project(bechmarks VERSION 0.1.0)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

find_package(benchmark CONFIG REQUIRED)

macro(package_add_bench_with_libraries TESTNAME FILES LIBRARIES TEST_WORKING_DIRECTORY)
    add_executable(${TESTNAME} ${FILES})
    target_link_libraries(${TESTNAME} PRIVATE benchmark::benchmark benchmark::benchmark_main ${LIBRARIES})
    set_target_properties(${TESTNAME} PROPERTIES FOLDER benchmarks)
endmacro()

package_add_bench_with_libraries(MainBench bench_main.cpp core "${PROJECT_DIR}")

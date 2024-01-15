cmake_minimum_required(VERSION 3.28.0)

project(fury VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_SCAN_FOR_MODULES ON)
set(SANITIZER_NAME "address")

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
  endif()

  if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_C_COMPILER_ID STREQUAL
                                               "Clang")
    message(NOTICE "Using Clang compiler")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -gdwarf-3 -fno-omit-frame-pointer")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -gdwarf-3 -fno-omit-frame-pointer")
    set(CMAKE_EXE_LINKER_FLAGS
        "${CMAKE_EXE_LINKER_FLAGS} -g -O0 -gdwarf-3 -fno-omit-frame-pointer")
  endif()

endif()

add_executable(app)
file(GLOB CPP_SRC "src/*.cpp")
target_sources(app PRIVATE ${CPP_SRC})

file(GLOB MODULES_SRC "src/*.ixx" "src/*.cxx")
list(LENGTH MODULES_SRC MODULES_LEN)
if(MODULES_LEN GREATER 0)
  add_library(core)
  target_sources(core PUBLIC FILE_SET CXX_MODULES FILES ${MODULES_SRC})
  target_link_libraries(app PRIVATE core)
endif()

if(MINGW)
  target_link_libraries(app PUBLIC ws2_32)
endif()
if(MSVC)
  target_compile_definitions(app PUBLIC -D_WIN32_WINNT=0x0601)
endif()

include(CheckIPOSupported)
check_ipo_supported(RESULT result)
if(result)
  set_target_properties(app PROPERTIES INTERPROCEDURAL_OPTIMIZATION TRUE)
else()
  message(NOTICE "LTO is not supported")
endif()

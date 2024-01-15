include(CheckCXXCompilerFlag)
macro(add_sanitizer flag)
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang"
     OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU"
     OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
    message("Looking for -fsanitize=${flag}")
    set(CMAKE_REQUIRED_FLAGS "-Werror -fsanitize=${flag}")
    check_cxx_compiler_flag(-fsanitize=${flag} HAVE_FLAG_SANITIZER)
    if(HAVE_FLAG_SANITIZER)
      message("Adding -fsanitize=${flag}")
      set(CMAKE_CXX_FLAGS
          "${CMAKE_CXX_FLAGS} -fsanitize=${flag} -fno-omit-frame-pointer")
      set(DCMAKE_C_FLAGS
          "${DCMAKE_C_FLAGS} -fsanitize=${flag} -fno-omit-frame-pointer")
      set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fsanitize=${flag}")
      set(DCMAKE_MODULE_LINKER_FLAGS
          "${DCMAKE_MODULE_LINKER_FLAGS} -fsanitize=${flag}")
    else()
      message("-fsanitize=${flag} unavailable")
    endif()
  endif()
endmacro()

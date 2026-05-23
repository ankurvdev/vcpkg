
if(NOT DEFINED ENV{EMSCRIPTEN_ROOT})
   find_path(EMSCRIPTEN_ROOT "emcc")
else()
   set(EMSCRIPTEN_ROOT "$ENV{EMSCRIPTEN_ROOT}")
endif()

if(NOT EMSCRIPTEN_ROOT)
   if(NOT DEFINED ENV{EMSDK})
      message(FATAL_ERROR "The emcc compiler not found in PATH")
   endif()
   set(EMSCRIPTEN_ROOT "$ENV{EMSDK}/upstream/emscripten")
endif()

if(NOT EXISTS "${EMSCRIPTEN_ROOT}/cmake/Modules/Platform/Emscripten.cmake")
   message(FATAL_ERROR "Emscripten.cmake toolchain file not found")
endif()

# https://emscripten.org/docs/porting/pthreads.html
# It is not possible to build one binary that would be able to leverage multithreading when available
# and fall back to single threaded when not. The best you can do is two separate builds, one with and
# one without threads, and pick between them at runtime.
# Use pthread enabled binaries by default
# The following Toolchain file appends -pthread to CMAKE_C_FLAGS and CMAKE_CXX_FLAGS after including 
# regular the toolchain ${EMSCRIPTEN_ROOT}/cmake/Modules/Platform/Emscripten.cmake

set(CMAKE_C_FLAGS "-pthread") #  -sEXPORTED_FUNCTIONS=_main,_malloc")
set(CMAKE_CXX_FLAGS "-pthread")#  -sEXPORTED_FUNCTIONS=_main,_malloc")

include("${EMSCRIPTEN_ROOT}/cmake/Modules/Platform/Emscripten.cmake")

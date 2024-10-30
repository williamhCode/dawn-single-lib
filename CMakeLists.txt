cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "Minimum OS X deployment version")

project(
  BuildDawn
  VERSION 0.1.0
  LANGUAGES CXX
)

include(FetchContent)

FetchContent_Declare(
  dawn
  #GIT_REPOSITORY https://dawn.googlesource.com/dawn
  #GIT_TAG        chromium/6800
  #GIT_SHALLOW ON

  DOWNLOAD_COMMAND
    cd ${PROJECT_SOURCE_DIR}/dawn-src &&
		git init &&
		git fetch --depth=1 https://dawn.googlesource.com/dawn chromium/6800 &&
		git reset --hard FETCH_HEAD

  SOURCE_DIR ${PROJECT_SOURCE_DIR}/dawn-src
)

set(DAWN_FETCH_DEPENDENCIES ON)
set(DAWN_ENABLE_INSTALL ON)

set(DAWN_ENABLE_VULKAN ${USE_VULKAN})
set(TINT_BUILD_SPV_READER OFF)

set(DAWN_BUILD_SAMPLES OFF)
set(TINT_BUILD_TESTS OFF)

set(TINT_BUILD_CMD_TOOLS ON)

FetchContent_MakeAvailable(dawn)

add_custom_target(dawn DEPENDS dawn::webgpu_dawn)

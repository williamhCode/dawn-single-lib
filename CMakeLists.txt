cmake_minimum_required(VERSION 3.0.0...3.24 FATAL_ERROR)
project(DawnSingleLib
  DESCRIPTION "Builds Dawn as a single static lib"
  VERSION 0.0.1
)

message(STATUS "Using Dawn backend for WebGPU")

# Collect all currently added targets in all subdirectories
#
# Parameters:
# - _result the list containing all found targets
# - _dir root directory to start looking from
function(get_all_targets _result _dir)
    get_property(_subdirs DIRECTORY "${_dir}" PROPERTY SUBDIRECTORIES)
    foreach(_subdir IN LISTS _subdirs)
        get_all_targets(${_result} "${_subdir}")
    endforeach()

    get_directory_property(_sub_targets DIRECTORY "${_dir}" BUILDSYSTEM_TARGETS)
    set(${_result} ${${_result}} ${_sub_targets} PARENT_SCOPE)
endfunction()


# set(DAWN_FETCH_DIR "${PROJECT_SOURCE_DIR}/fetch-content")
include(cmake/FetchDawn.cmake)

get_all_targets(AllDawnTargets ${dawn_SOURCE_DIR})
set(valid_types "STATIC_LIBRARY;MODULE_LIBRARY;SHARED_LIBRARY;OBJECT_LIBRARY;EXECUTABLE")
set(dawn_objects)
foreach(target IN LISTS AllDawnTargets)
  if (TARGET ${target})
    get_target_property(target_type ${target} TYPE)
    if (${target_type} IN_LIST valid_types)
      # message(STATUS "Adding target ${target} with ${target_type} to dawn_objects")
      message(STATUS "${target} : ${target_type}")
      list(APPEND dawn_objects $<TARGET_OBJECTS:${target}>)
    else()
      # message(STATUS "Skipping target ${target} with ${target_type}")
      message(STATUS "${target} ! ${target_type}")
    endif()
  endif()
endforeach()

# print all dawn objects
add_library(dawn STATIC ${dawn_objects})

target_link_libraries(dawn PRIVATE
  # -L/opt/homebrew/opt/llvm/lib/c++
  # "-framework Cocoa"
  # "-framework IOKit"
  # "-framework IOSurface"
  # "-framework QuartzCore"
  # "-framework Metal"
)

# set install prefix
# set(CMAKE_INSTALL_PREFIX "/usr/local")

install(TARGETS dawn
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

install(
  DIRECTORY "${DAWN_FETCH_DIR}/dawn-src/src"
  DESTINATION include/dawn-src/src
  # FILES_MATCHING PATTERN "*.h"
)

install(
  DIRECTORY "${DAWN_FETCH_DIR}/dawn-src/include"
  DESTINATION include/dawn-src/include
  # FILES_MATCHING PATTERN "*.h"
)

install(
  DIRECTORY "${dawn_BINARY_DIR}/gen/include"
  DESTINATION include/dawn-build/gen/include
  # FILES_MATCHING PATTERN "*.h"
)

# Install the pkg-config file
configure_file(dawn.pc.in dawn.pc @ONLY)
install(FILES "${CMAKE_BINARY_DIR}/dawn.pc"
  DESTINATION lib/pkgconfig
)

# install(FILES "${CMAKE_BINARY_DIR}/compile_commands.json"
#   DESTINATION share/dawn
# )


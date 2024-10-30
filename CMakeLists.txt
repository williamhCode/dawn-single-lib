cmake_minimum_required(VERSION 3.0.0...3.24 FATAL_ERROR)

set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "Minimum OS X deployment version")

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

install(TARGETS dawn
  EXPORT dawnTargets
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

install(
  DIRECTORY "${dawn_SOURCE_DIR}/src"
  DESTINATION include/dawn-src
)

install(
  DIRECTORY "${dawn_SOURCE_DIR}/include"
  DESTINATION include/dawn-src
)

install(
  DIRECTORY "${dawn_BINARY_DIR}/gen/include"
  DESTINATION include/dawn-build/gen
)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/dawnConfigVersion.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion
)

configure_file(dawnConfig.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/dawnConfig.cmake" @ONLY
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/dawnConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/dawnConfigVersion.cmake"
  DESTINATION lib/cmake/dawn
)

install(EXPORT dawnTargets
  FILE dawnTargets.cmake
  DESTINATION lib/cmake/dawn
)

# Install the pkg-config file
# configure_file(dawn.pc.in dawn.pc @ONLY)
# install(FILES "${CMAKE_BINARY_DIR}/dawn.pc"
#   DESTINATION lib/pkgconfig
# )

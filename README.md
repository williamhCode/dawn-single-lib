# Dawn Single Lib
Builds dawn as a single libdawn.a, with find_package support.  
Tested on mac m1.

## Building and Installing
Edit Makefile to your needs
```
make build-setup
make build
make install
```

## Use in CMake Project
```Cmake
# Use Releases
FetchContent_Declare(
  dawn
  URL https://github.com/williamhCode/dawn-single-lib/releases/...
)
FetchContent_MakeAvailable(dawn)
find_package(dawn CONFIG REQUIRED PATHS ${dawn_SOURCE_DIR})

# If installed on system:
find_package(dawn CONFIG REQUIRED)

...
target_link_libraries(target_name PRIVATE
  ${dawn_LIBRARIES}
)

target_include_directories(target_name PRIVATE
  ${dawn_INCLUDE_DIRS}
)
```

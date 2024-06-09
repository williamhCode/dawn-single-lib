# Dawn Single Lib
Builds dawn as a single libdawn.a, with pkg-config support.\
Testing on mac m1 as of now.

## Building and Installing
Edit Makefile to your needs
```
make build-setup
make build
make install
```

## Use in CMake Project
```Cmake
find_package(PkgConfig)
pkg_check_modules(Dawn REQUIRED IMPORTED_TARGET dawn)
...
target_link_libraries(your_exec PRIVATE
  PkgConfig::Dawn

  # OS independent libs might need to be linked
  # example for macOS
  "-framework Cocoa"
  "-framework IOKit"
  "-framework IOSurface"
  "-framework QuartzCore"
  "-framework Metal"
)

```

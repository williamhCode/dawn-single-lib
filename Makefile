.PHONY: build

# TYPE = release
TYPE = debug

build:
	cmake --build build/$(TYPE) --target dawn

build-setup:
	cmake . -B build/debug \
		-DCMAKE_BUILD_TYPE=Debug \
		-GNinja \
		-DCMAKE_C_COMPILER=clang \
		-DCMAKE_CXX_COMPILER=clang++ \
		-DCMAKE_COLOR_DIAGNOSTICS=ON
	cmake . -B build/release \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-GNinja \
		-DCMAKE_C_COMPILER=clang \
		-DCMAKE_CXX_COMPILER=clang++ \
		-DCMAKE_COLOR_DIAGNOSTICS=ON

install:
	cmake --install build/$(TYPE) --prefix $(prefix)

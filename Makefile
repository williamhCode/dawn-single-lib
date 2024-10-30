.PHONY: build

build:
	cmake --build build --target dawn

build-setup:
	cmake . -B build \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-GNinja \
		-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
		-DCMAKE_C_COMPILER_LAUNCHER=ccache \
		-DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
		-DCMAKE_COLOR_DIAGNOSTICS=ON

clean:
	cmake --build build --target clean

install:
	cmake --install build

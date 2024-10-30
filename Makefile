build:
	cmake --build out/Debug --target dawn
	cmake --build out/Release --target dawn

build-setup:
	cmake . -B out/Debug \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-GNinja \
		-DDAWN_ALWAYS_ASSERT=ON \
		-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
		-DCMAKE_COLOR_DIAGNOSTICS=ON

	cmake . -B out/Release \
		-DCMAKE_BUILD_TYPE=Release \
		-GNinja \
		-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
		-DCMAKE_COLOR_DIAGNOSTICS=ON

install:
	cmake --install out/Debug --prefix install/Debug
	cmake --install out/Release --prefix install/Release

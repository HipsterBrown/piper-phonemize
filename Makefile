.PHONY: clean

all:
	cmake -Bbuild -DCMAKE_INSTALL_PREFIX=install
	cmake --build build --config Release
	@if [ "$(OS)" != "Windows_NT" ]; then \
        cd build && ctest --config Release --rerun-failed --output-on-failure; \
    fi
	cmake --install build

clean:
	rm -rf build install

build_python: all
	pip install -q build delocate
	CPPFLAGS="-I${PWD}/install/include/piper-phonemize -I${PWD}/install/include -L${PWD}/install/lib" python -m build -w

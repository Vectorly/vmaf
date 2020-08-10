all:
	cd third_party/libsvm && make lib

	meson setup libvmaf/build libvmaf --buildtype release && \
	cd libvmaf && ninja -vC build && cd .. \
	cd python && python3 setup.py build_ext --build-lib .

clean:
	cd third_party/libsvm && make clean && cd -
	rm -rf libvmaf/build

install:
	meson setup libvmaf/build libvmaf --buildtype release && \
	ninja -vC libvmaf/build install

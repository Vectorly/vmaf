FROM ubuntu:18.04

# setup timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# get and install building tools
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
        build-essential \
        git \
        ninja-build \
        doxygen \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        python3-tk \
        && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists


# install python requirements
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir meson

# setup environment
ENV PATH=/vmaf:/vmaf/libvmaf/build/tools:$PATH

# retrieve source code
COPY . /vmaf

# make vmaf
RUN cd /vmaf && make clean && cd third_party/libsvm && make lib && cd /vmaf/libvmaf && CFLAGS=-msse meson build --buildtype release && (ninja -vC build || ninja -vC build)

# install python tools
RUN pip3 install cython numpy scipy && pip3 install -e /vmaf/python

RUN cd /vmaf/python && python3 test/asset_test.py AssetTest.test_bitrate

WORKDIR /vmaf/

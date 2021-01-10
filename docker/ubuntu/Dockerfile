FROM ubuntu as builder
LABEL stage=builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --fix-missing \
    build-essential \ 
    cmake \
    git \
    libboost-all-dev \
    libcgal-dev \
    libmagick++-6-headers \ 
    libmagick++-6.q16-dev \
    npm \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home

RUN git clone --recurse-submodules https://github.com/google/snappy.git && \
    git clone https://github.com/mmccoo/minecraft_mmccoo.git && \
    git clone https://github.com/Mojang/leveldb-mcpe.git

RUN wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.14.3/CGAL-4.14.3.tar.xz && \
    tar -xf CGAL-4.14.3.tar.xz

RUN mkdir snappy/build && \
    mkdir snappy/install && \
    mkdir -p /var/www

WORKDIR /home/snappy/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=`realpath ../install` && \
    make && \
    make install

WORKDIR /home/leveldb-mcpe
RUN git apply ../minecraft_mmccoo/snappy_compressor.cc.patch && \
    git apply ../minecraft_mmccoo/table_test.cc.patch && \
     make

WORKDIR /home/CGAL-4.14.3
RUN cmake . && make && make install

WORKDIR /home/minecraft_mmccoo
# Update Makefile to reference ImageMagick-6.9.10 instead of ImageMagick-6.9.7
COPY Makefile.patch .
RUN git apply Makefile.patch && make

WORKDIR /home/minecraft_mmccoo/web_stuff
RUN npm install
RUN npm run build 
RUN cp -r dist/* /var/www

WORKDIR /var/www

# --------------------------------------------------------------------------------------------------------------
# Start of multi-build example section
# 
# The below creates a smaller docker image based on BusyBox, which includes: 
# 
#    > basic_test binary
#    > basic_test ldd dependencies
#    > web_stuff/dist/* folder
#
# This section (rows 56-77) can be remove if you want the larger image with source files and other binaries
# --------------------------------------------------------------------------------------------------------------
WORKDIR /home/minecraft_mmccoo

COPY docker/ubuntu/copy_basic_test_and_its_dependencies.sh .
RUN chmod 0755 copy_basic_test_and_its_dependencies.sh
RUN ./copy_basic_test_and_its_dependencies.sh

FROM busybox
COPY --from=builder /home/mmccoo-deps .
COPY --from=builder /home/minecraft_mmccoo/web_stuff/dist /var/www

WORKDIR /var/www

# ---------------------------------------------------------------------------
# End of multi-build example section
# ---------------------------------------------------------------------------
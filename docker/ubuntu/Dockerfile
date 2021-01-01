FROM ubuntu

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --fix-missing \
    build-essential \ 
    cmake \
    libboost-all-dev \
    libcgal-dev \
    npm \
    git \
    libmagick++-6-headers libmagick++-6.q16-dev \
    wget

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
COPY Makefile.patch .
RUN git apply Makefile.patch && make

WORKDIR /home/minecraft_mmccoo/web_stuff
RUN npm install
RUN npm run build 
RUN cp -r dist/* /var/www

WORKDIR /var/www

FROM ubuntu

RUN apt-get update && \
    apt-get install -y --fix-missing \
    build-essential 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata

RUN apt-get install -y --fix-missing cmake
RUN apt-get install -y --fix-missing libboost-all-dev 
RUN apt-get install -y --fix-missing libcgal-dev 
RUN apt-get install -y --fix-missing npm 
RUN apt-get install -y --fix-missing git 

WORKDIR /home

RUN git clone --recurse-submodules https://github.com/google/snappy.git
RUN git clone https://github.com/mmccoo/minecraft_mmccoo.git
RUN git clone https://github.com/Mojang/leveldb-mcpe.git

RUN mkdir snappy/build
RUN mkdir snappy/install
WORKDIR /home/snappy/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=`realpath ../install`
RUN make
RUN make install

WORKDIR /home/leveldb-mcpe
RUN git apply ../minecraft_mmccoo/snappy_compressor.cc.patch
RUN git apply ../minecraft_mmccoo/table_test.cc.patch
RUN make

RUN apt-get install -y --fix-missing libmagick++-6-headers libmagick++-6.q16-dev
RUN apt-get install -y --fix-missing wget

# Below installs CGAL 4.13. TODO - check if we can instead install 5.0 via libcgal* installation above
WORKDIR /home
RUN wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.14.3/CGAL-4.14.3.tar.xz
RUN tar -xf CGAL-4.14.3.tar.xz
WORKDIR /home/CGAL-4.14.3
RUN cmake . && make && make install

WORKDIR /home/minecraft_mmccoo
COPY Makefile.patch .
RUN git apply Makefile.patch
RUN make

WORKDIR /home/minecraft_mmccoo/web_stuff
RUN npm install
RUN npm run build

RUN mkdir -p /var/www
RUN cp -r dist/* /var/www

WORKDIR /var/www

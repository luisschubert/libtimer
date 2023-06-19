# Start from a base Ubuntu image
FROM ubuntu:20.04

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Update package list and install dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  libboost-all-dev \
  wget 

COPY . /usr/src/app/libtimer

# install date 
RUN wget https://github.com/HowardHinnant/date/archive/refs/tags/v3.0.1.tar.gz && \
    tar -xf v3.0.1.tar.gz && \
    cd date-3.0.1 && \
    mkdir build && cd build && \
    cmake .. -DBUILD_TZ_LIB=ON -DHAS_REMOTE_API=0 -DUSE_AUTOLOAD=0 -DUSE_SYSTEM_TZ_DB=ON && \
    make && make install

WORKDIR /usr/src/app/libtimer

RUN mkdir build
WORKDIR /usr/src/app/libtimer/build
RUN cmake ..
RUN make install

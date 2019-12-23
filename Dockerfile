FROM gcc:9.2

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils \
	&& apt-get -y install libgmp-dev libmpfr-dev libmpc-dev texinfo libc6-dev-i386
RUN apt-get update && apt-get install -y dos2unix

COPY ./build_m68K.sh /build_m68K.sh
COPY ./cleanup_build.sh /cleanup_build.sh

WORKDIR /

# Clean up APT when done.
RUN dos2unix build_m68K.sh \
	&& dos2unix cleanup_build.sh \
	&& apt-get --purge remove -y dos2unix \
	&& apt-get clean  \
	&& rm -rf /var/lib/apt/lists/*

RUN bash ./build_m68K.sh && bash ./cleanup_build.sh

# CMD bash
# ENV DEBIAN_FRONTEND noninteractive
# https://willi.am/blog/2016/08/11/docker-for-windows-dealing-with-windows-line-endings/

COPY ./entry-point.sh .

# ENV DEBIAN_FRONTEND teletype
ENV CC=/home/x-tools/m68k-elf/bin/m68k-elf-gcc
ENV CXX=/home/x-tools/m68k-elf/bin/m68k-elf-g++

#ENTRYPOINT ["/bin/bash", "/entry-point.sh"]
#ENTRYPOINT ["/bin/bash" ]



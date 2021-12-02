FROM gcc:11.2

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils \
	&& apt-get -y install libgmp-dev libmpfr-dev libmpc-dev texinfo libc6-dev-i386
RUN apt-get update && apt-get install -y dos2unix

COPY ./build_xtools.sh /build_xtools.sh
COPY ./build_cross.sh /build_cross.sh
COPY ./cleanup_build.sh /cleanup_build.sh

WORKDIR /

# Clean up APT when done.
RUN dos2unix build_xtools.sh \
	&& dos2unix build_cross.sh \
	&& dos2unix cleanup_build.sh \
	&& apt-get --purge remove -y dos2unix \
	&& apt-get clean  \
	&& rm -rf /var/lib/apt/lists/*

RUN bash ./build_xtools.sh && bash ./cleanup_build.sh

# CMD bash
# ENV DEBIAN_FRONTEND noninteractive
# https://willi.am/blog/2016/08/11/docker-for-windows-dealing-with-windows-line-endings/

COPY ./entry-point.sh .

# ENV DEBIAN_FRONTEND teletype
ENV CC=/home/x-tools/m68k-elf/bin/m68k-elf-gcc
ENV CXX=/home/x-tools/m68k-elf/bin/m68k-elf-g++
ENV PATH=/home/x-tools/m68k-elf/bin/:$PATH

#ENTRYPOINT ["/bin/bash", "/entry-point.sh"]
#ENTRYPOINT ["/bin/bash" ]



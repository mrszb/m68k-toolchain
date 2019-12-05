FROM gcc:8.2
RUN apt-get update \
	&& apt-get -y install libgmp-dev libmpfr-dev libmpc-dev texinfo libc6-dev-i386
RUN apt-get update && apt-get install -y dos2unix

COPY ./build_m68K.sh /build_m68K.sh

WORKDIR /

RUN dos2unix build_m68K.sh && apt-get --purge remove -y dos2unix && rm -rf /var/lib/apt/lists/*
RUN ls /
RUN cat ./build_m68K.sh
RUN chmod a+x build_m68K.sh
RUN bash ./build_m68K.sh
# CMD bash
# ENV DEBIAN_FRONTEND noninteractive
# https://willi.am/blog/2016/08/11/docker-for-windows-dealing-with-windows-line-endings/


# COPY ./entry-point.sh /entry-point.sh
COPY ./entry-point.sh .
ENTRYPOINT ["/bin/bash", "/entry-point.sh"]

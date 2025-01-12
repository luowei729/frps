FROM alpine:3.8
LABEL maintainer="Stille <stille@ioiox.com>"

ENV VERSION 0.61.1
ENV TZ=Asia/Shanghai
WORKDIR /

RUN apk add --no-cache tzdata \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

RUN if [ "$(uname -m)" = "x86_64" ]; then export PLATFORM=amd64 ; \
	elif [ "$(uname -m)" = "aarch64" ]; then export PLATFORM=arm64 ; \
	elif [ "$(uname -m)" = "armv7" ]; then export PLATFORM=arm ; \
	elif [ "$(uname -m)" = "armv7l" ]; then export PLATFORM=arm ; \
	elif [ "$(uname -m)" = "armhf" ]; then export PLATFORM=arm ; fi \
	&& wget --no-check-certificate https://github.com/luowei729/frp/archive/refs/tags/v1.0.0.tar.gz \
	&& tar xzf v1.0.0.tar.gz \
	&& cd frp-1.0.0 \
	&& mkdir /frp \
	&& mv frps frps.toml /frp \
	&& cd .. \
	&& rm -rf *.tar.gz  v1.0.0

VOLUME /frp

CMD /frp/frps -c /frp/frps.toml

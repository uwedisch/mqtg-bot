FROM golang:1.21.3 as builder
WORKDIR /build
COPY . .
RUN CGO_ENABLED=1 GOOS=linux go build -mod vendor -a -installsuffix cgo -o bot main.go

FROM alpine:latest
RUN apk update && apk --no-cache add ca-certificates libc6-compat

# Source: https://github.com/anapsix/docker-alpine-java
ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.30-r0
RUN set -ex && \
    apk --update add libstdc++ curl ca-certificates && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
        do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

WORKDIR /root
COPY --from=builder /build/bot .
CMD ["./bot"]

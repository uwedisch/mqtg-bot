FROM golang:1.21.3 as builder
WORKDIR /build
COPY . .
RUN CGO_ENABLED=1 GOOS=linux go build -mod vendor -a -installsuffix cgo -o bot main.go

FROM ubuntu:22.04
WORKDIR /root
COPY --from=builder /build/bot .
CMD ["./bot"]

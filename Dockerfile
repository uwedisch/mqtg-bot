FROM golang:1.21.3 as builder
WORKDIR /build
COPY . .
RUN CGO_ENABLED=1 GOOS=linux go build -mod vendor -a -installsuffix cgo -o bot main.go

FROM ubuntu:latest
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /root
COPY --from=builder /build/bot .
CMD ["./bot"]

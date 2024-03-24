FROM golang:1.21.3 as builder
WORKDIR /build
COPY . .
RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev
RUN CGO_ENABLED=1 GOOS=linux go build -mod vendor -a -installsuffix cgo -o bot main.go

FROM alpine:latest
RUN apk update && apk --no-cache add ca-certificates
WORKDIR /root
COPY --from=builder /build/bot .
CMD ["./bot"]

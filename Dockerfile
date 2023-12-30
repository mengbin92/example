FROM golang:1.21.5-alpine AS builder
LABEL maintainer="mengbin1992@outlook.com"

ENV GOPROXY="https://goproxy.cn,direct"
ENV CGO_ENABLED=0

WORKDIR /app

COPY . ./

RUN go build -ldflags "-s -w" -o example

# build watcher
RUN cd /app/cmd && go build -ldflags "-s -w" -o watcher

FROM alpine:3.19
LABEL maintainer="mengbin1992@outlook.com"

WORKDIR /app

COPY --from=builder /app/example /app
COPY --from=builder /app/cmd/watcher /app
COPY conf /app/conf

CMD ["/app/watcher"]
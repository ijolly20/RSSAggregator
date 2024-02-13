# syntax=docker/dockerfile:1
# An RSS Aggregator written in Go packaged into a container image

FROM golang:1.21.6 AS builder

# Set destination for COPY
WORKDIR /app

# Download Go modules
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . ./

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /RSSAggregator  

# Runner
FROM alpine:latest
RUN apk add --no-cache ca-certificates && update-ca-certificates
COPY --from=builder /RSSAggregator .
COPY .env .
EXPOSE 8080 8080

ENTRYPOINT [ "/RSSAggregator" ]
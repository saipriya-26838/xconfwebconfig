#cassandra db issue fix
# Use an official Go runtime as a parent image
FROM golang:1.18-alpine as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the Go Modules manifests
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if go.mod and go.sum are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN go build -o xconfwebconfig .

# Start a new stage from scratch
FROM alpine:latest

# Set the Current Working Directory inside the container
WORKDIR /app

# Install necessary tools for Cassandra communication (e.g., curl, netcat, or any required library for Cassandra)
RUN apk add --no-cache curl netcat-openbsd

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/xconfwebconfig .

# Copy the configuration file into the container
COPY config/sample_xconfwebconfig.conf /app/xconfwebconfig.conf

# Expose port 9001 to the outside world
EXPOSE 9001

# Run the binary with the configuration file
CMD ["./xconfwebconfig", "-f", "/app/xconfwebconfig.conf"]

#-----------------v4----------------------------
# Use an official Go runtime as a parent image
FROM golang:1.18-alpine as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the Go Modules manifests
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if go.mod and go.sum are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN go build -o xconfwebconfig .

# Start a new stage from scratch
FROM alpine:latest

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/xconfwebconfig .

# Copy the configuration file into the container
COPY config/sample_xconfwebconfig.conf /app/xconfwebconfig.conf

# Expose port 9001 to the outside world
EXPOSE 9001

# Run the binary with the configuration file
CMD ["./xconfwebconfig", "-f", "/app/xconfwebconfig.conf"]

#=======================v1=======================
## Use an official Go runtime as a parent image
#FROM golang:1.18-alpine as builder
#
## Set the Current Working Directory inside the container
#WORKDIR /app
#
## Copy the Go Modules manifests
#COPY go.mod go.sum ./
#
## Download all dependencies. Dependencies will be cached if the go.mod and go.sum are not changed
#RUN go mod download
#
## Copy the source code into the container
#COPY . .
#
## Build the Go app
#RUN go build -o xconfwebconfig .
#
## Start a new stage from scratch
#FROM alpine:latest
#
## Set the Current Working Directory inside the container
#WORKDIR /root/
#
## Copy the Pre-built binary file from the previous stage
#COPY --from=builder /app/xconfwebconfig .
#
## Expose port 8080 to the outside world
#EXPOSE 9001
#
## Run the binary
#CMD ["./xconfwebconfig"]

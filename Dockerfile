# Use an official Go runtime as a parent image
FROM golang:1.18-alpine as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the Go Modules manifests
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum are not changed
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go app
RUN go build -o xconfwebconfig .

# Start a new stage from scratch
FROM alpine:latest

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/xconfwebconfig .

# Expose port 8080 to the outside world
EXPOSE 9001

# Run the binary
CMD ["./xconfwebconfig"]

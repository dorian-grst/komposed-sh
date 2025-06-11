# Build the manager binary
FROM golang:1.22 AS builder
ARG TARGETOS
ARG TARGETARCH

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

# Copy the go source
COPY cmd/main.go cmd/main.go
COPY api/ api/
COPY internal/controller/ internal/controller/

# Build
# the GOARCH has not a default value to allow the binary be built according to the host where the command
# was called. For example, if we call make docker-build in a local env which has the Apple Silicon M1 SO
# the docker BUILDPLATFORM arg will be linux/arm64 when for Apple x86 it will be linux/amd64. Therefore,
# by leaving it empty we can ensure that the container and binary shipped on it will have the same platform.
RUN CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH} go build -a -o manager cmd/main.go

# Download kompose and kubectl binaries
FROM alpine:latest AS tools-downloader
ARG TARGETARCH
RUN apk add --no-cache curl
# Determine architecture for both tools
RUN case ${TARGETARCH} in \
    "amd64") TOOL_ARCH="amd64" ;; \
    "arm64") TOOL_ARCH="arm64" ;; \
    *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    # Download kompose
    curl -L https://github.com/kubernetes/kompose/releases/download/v1.34.0/kompose-linux-${TOOL_ARCH} -o /kompose && \
    chmod +x /kompose && \
    # Download kubectl
    curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${TOOL_ARCH}/kubectl" -o /kubectl && \
    chmod +x /kubectl

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/manager .
COPY --from=tools-downloader /kompose /usr/local/bin/kompose
COPY --from=tools-downloader /kubectl /usr/local/bin/kubectl
USER 65532:65532

ENTRYPOINT ["/manager"]

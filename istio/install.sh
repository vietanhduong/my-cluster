#!/bin/bash
set -eo pipefail

# Download istio, default version is 1.9.7 
ISTIO_VERSION=${ISTIO_VERSION:-1.9.7}

# Prepare before download
[[ -d "istio-$ISTIO_VERSION" ]] && mv "istio-$ISTIO_VERSION" "old-istio-$ISTIO_VERSION"

if ! curl -sSfL https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh - &> /dev/null; then 
  echo "Download istio with version $ISTIO_VERSION failed!" >&2
  exit 1
fi

# # Copy chart
# mv "istio-$ISTIO_VERSION"/manifests/charts .charts

# # Remove junk
# rm -rf "istio-$ISTIO_VERSION"

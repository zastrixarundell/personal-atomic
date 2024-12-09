FROM quay.io/fedora/fedora-kinoite

ARG LATEST_KERNEL="false"

ENV LATEST_KERNEL=$LATEST_KERNEL

RUN echo "Using latest kernel? ${LATEST_KERNEL}"

COPY system_files/desktop/shared /

COPY build.sh /tmp/build.sh

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit

FROM quay.io/fedora/fedora-kinoite

ARG UNSTABLE_COMPONENTS="false"

ENV UNSTABLE_COMPONENTS=$UNSTABLE_COMPONENTS

COPY system_files/desktop/shared /

COPY cosign.pub /etc/pki/containers/zastrix.pub

COPY build.sh /tmp/build.sh

COPY packages.d /tmp/packages.d/

COPY build.d /tmp/build.d

ARG RELEASE_VERSION

COPY --from=ghcr.io/ublue-os/akmods:main-${RELEASE_VERSION} /rpms/ /tmp/rpms

RUN mkdir -p /var/lib/alternatives

RUN /tmp/build.sh && ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit

FROM quay.io/fedora/fedora AS blur

RUN sudo dnf in update -y

RUN sudo dnf -y install git cmake extra-cmake-modules \
            gcc-g++ kf6-kwindowsystem-devel \
            plasma-workspace-devel libplasma-devel \
            qt6-qtbase-private-devel qt6-qtbase-devel \
            cmake kwin-devel extra-cmake-modules kwin-devel \
            kf6-knotifications-devel kf6-kio-devel \
            kf6-kcrash-devel kf6-ki18n-devel kf6-kguiaddons-devel \
            libepoxy-devel kf6-kglobalaccel-devel kf6-kcmutils-devel \
            kf6-kconfigwidgets-devel kf6-kdeclarative-devel \
            kdecoration-devel kf6-kglobalaccel kf6-kdeclarative \
            libplasma kf6-kio qt6-qtbase kf6-kguiaddons \
            kf6-ki18n wayland-devel libdrm-devel rpmbuild

RUN mkdir -p /root

COPY build.d/kwin-effects-forceblur.sh /tmp/build-blur.sh

RUN /tmp/build-blur.sh

FROM quay.io/fedora/fedora-kinoite

ARG UNSTABLE_COMPONENTS="false"
ARG LAPTOP="false"

ENV UNSTABLE_COMPONENTS=$UNSTABLE_COMPONENTS
ENV LAPTOP=$LAPTOP

COPY system_files/desktop/shared /

COPY cosign.pub /etc/pki/containers/zastrix.pub

COPY build.sh /tmp/build.sh

COPY packages.d /tmp/packages.d/

COPY build.d /tmp/build.d

COPY --from=blur /root/kwin-effects-forceblur/build/kwin-better-blur.rpm /tmp/kwin-better-blur.rpm

ARG RELEASE_VERSION

COPY --from=ghcr.io/ublue-os/akmods:main-${RELEASE_VERSION} /rpms/ /tmp/rpms

RUN mkdir -p /var/lib/alternatives

RUN /tmp/build.sh && ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit

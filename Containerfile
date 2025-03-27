FROM quay.io/fedora/fedora-bootc:latest
COPY etc /etc/
COPY usr /usr/
RUN --mount=type=bind,src=/build,dst=/build_scripts \
    --mount=type=bind,src=/system_files,dst=/system_files \
    sh /build_scripts/build.sh

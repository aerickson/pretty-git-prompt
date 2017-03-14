FROM fedora:25

LABEL maintainer="Tomas Tomecek <tomas@tomecek.net>"

RUN dnf install -y curl tar gcc openssl-devel cmake make file libcurl-devel

# mostly copied from https://github.com/Scorpil/docker-rust/blob/master/nightly/Dockerfile

# beta, nightly, 1.15.1
ARG RUST_CHANNEL=nightly
ARG WITH_TEST="yes"
ENV RUST_ARCHIVE=rust-$RUST_CHANNEL-x86_64-unknown-linux-gnu.tar.gz
ENV RUST_DOWNLOAD_URL=https://static.rust-lang.org/dist/$RUST_ARCHIVE

RUN mkdir /rust && cd /rust && \
    curl -fsOSL $RUST_DOWNLOAD_URL && \
    curl -s $RUST_DOWNLOAD_URL.sha256 | sha256sum -c - && \
    tar -C /rust -xzf $RUST_ARCHIVE --strip-components=1 && \
    ./install.sh && \
    rm -rf /rust

RUN if [ $WITH_TEST == "yes" ] ; then \
    cargo install clippy && \
    dnf install -y git python3-pytest ; \
    fi

# TODO: run as unprivileged user
CMD ["/bin/bash"]
WORKDIR /app

COPY . /app
FROM ubuntu:bionic

ARG DROPBOX_GID=500
ARG DROPBOX_UID=500
ARG DROPBOX_BIN_DIR=/dropbox_bin

ENV DEBIAN_FRONTEND noninteractive
ENV DROPBOX_VERSION 66.4.84
ENV ARCH            86_64

# Install prereqs
RUN apt-get -q update               && \
    apt-get -y install libglib2.0-0    \
                       supervisor      \
                       wget         && \
    rm -rf /var/lib/apt/lists/*

# Create dropbox group and user, nologin, no real home directory. We store the executable in the container at
# /dropbox_bin. When we run dropbox we will trick it into thinking that its home directory is the bind mount for the
# host (/dropbox).
RUN groupadd -g 500 dropbox && \
    useradd -M -s /sbin/nologin -u $DROPBOX_UID -g $DROPBOX_GID dropbox && \
    mkdir $DROPBOX_BIN_DIR && chown dropbox:dropbox $DROPBOX_BIN_DIR

# download and install dropbox (headless)
# more details about this installation at:
# - https://www.dropbox.com/install?os=lnx
USER dropbox
RUN wget -O /tmp/dropbox.tgz            \
         -q https://clientupdates.dropboxstatic.com/dbx-releng/client/dropbox-lnx.x${ARCH}-${DROPBOX_VERSION}.tar.gz  && \
    tar -zxf /tmp/dropbox.tgz -C $DROPBOX_BIN_DIR && \
    rm -f /tmp/dropbox.tgz

# download the Dropbox python management script
RUN wget -O $DROPBOX_BIN_DIR/dropbox.py \
         -q http://www.dropbox.com/download?dl=packages/dropbox.py

# Configure supervisord
USER root
COPY assets/supervisord.conf /etc/supervisor/supervisord.conf
ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]

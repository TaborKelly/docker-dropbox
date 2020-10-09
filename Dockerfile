FROM ubuntu:bionic

ARG DROPBOX_GID=500
ARG DROPBOX_UID=500
ARG DROPBOX_HOME_DIR=/home/dropbox

ENV DEBIAN_FRONTEND noninteractive

# Install prereqs
RUN apt-get -q update               && \
    apt-get -y install cron            \
                       libxdamage1     \
                       libxext6        \
                       libglapi-mesa   \
                       libglib2.0-0    \
                       libxcb-dri2-0   \
                       libxcb-dri3-0   \
                       libxcb-glx0     \
                       libxcb-present0 \
                       libxcb-sync1    \
                       libxfixes3      \
                       libxshmfence1   \
                       libxxf86vm1     \
                       supervisor      \
                       wget         && \
    rm -rf /var/lib/apt/lists/*

# Create dropbox group and user, nologin, but a real home directory.
RUN groupadd -g 500 dropbox && \
    useradd --base-dir /home --create-home -s /sbin/nologin -u $DROPBOX_UID -g $DROPBOX_GID dropbox

# download and install dropbox (headless)
# more details about this installation at:
# - https://www.dropbox.com/install?os=lnx
USER dropbox
RUN wget -O /tmp/dropbox.tgz            \
         -q https://www.dropbox.com/download?plat=lnx.x86_64 && \
    tar -zxf /tmp/dropbox.tgz -C $DROPBOX_HOME_DIR && \
    rm -f /tmp/dropbox.tgz

# download the Dropbox python management script
RUN wget -O $DROPBOX_HOME_DIR/dropbox.py \
         -q http://www.dropbox.com/download?dl=packages/dropbox.py

# Configure cron
USER root
COPY assets/dropbox-cron /etc/cron.d

# Configure supervisord
COPY assets/supervisord.conf /etc/supervisor/supervisord.conf
ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]

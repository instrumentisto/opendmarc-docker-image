# AUTOMATICALLY GENERATED
# DO NOT EDIT THIS FILE DIRECTLY, USE /Dockerfile.tmpl.php

# https://hub.docker.com/_/debian
FROM debian:bookworm-slim

ARG s6_overlay_ver=3.2.0.2


# Build and install OpenDMARC
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends --no-install-suggests \
            inetutils-syslogd \
            ca-certificates \
 && update-ca-certificates \
    \
 # Install OpenDMARC dependencies
 && apt-get install -y --no-install-recommends --no-install-suggests \
            libmilter1.0.1 libspf2-2 \
            msmtp-mta \
    \
 # Install tools for building
 && toolDeps=" \
        autoconf automake curl gcc g++ libc-dev libtool make \
    " \
 && apt-get install -y --no-install-recommends --no-install-suggests \
            $toolDeps \
    \
 # Install OpenDMARC build dependencies
 && buildDeps=" \
        libmilter-dev libspf2-dev \
    " \
 && apt-get install -y --no-install-recommends --no-install-suggests \
            $buildDeps \
    \
 # Download and prepare OpenDMARC sources
 && curl -fL -o /tmp/opendmarc.tar.gz \
         https://github.com/trusteddomainproject/OpenDMARC/archive/refs/tags/rel-opendmarc-1-4-2.tar.gz \
 && tar -xzf /tmp/opendmarc.tar.gz -C /tmp/ \
 && cd /tmp/OpenDMARC-* \
    \
 # Build OpenDMARC from sources
 && autoreconf -ivf \
 && ./configure \
        --prefix=/usr \
        --sysconfdir=/etc/opendmarc \
        --with-spf \
        --with-spf2-lib=/usr/lib \
        --with-spf2-include=/usr/include/spf2 \
        # No documentation included to keep image size smaller
        --docdir=/tmp/opendmarc/doc \
        --infodir=/tmp/opendmarc/info \
        --mandir=/tmp/opendmarc/man \
 && make \
    \
 # Create OpenDMARC user and group
 && addgroup --system --gid 91 opendmarc \
 && adduser --system --uid 90 --disabled-password --shell /sbin/nologin \
            --no-create-home --home /run/opendmarc \
            --ingroup opendmarc --gecos opendmarc \
            opendmarc \
 && adduser opendmarc mail \
    \
 # Install OpenDMARC
 && make install \
 # Prepare run directory
 && install -d -o opendmarc -g opendmarc /run/opendmarc/ \
 # Preserve licenses
 && install -d /usr/share/licenses/opendmarc/ \
 && mv /tmp/opendmarc/doc/LICENSE* \
       /usr/share/licenses/opendmarc/ \
 # Prepare configuration directories
 && install -d /etc/opendmarc/conf.d/ \
    \
 # Cleanup unnecessary stuff
 && apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
            $toolDeps $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
           /etc/*/inetutils-syslogd \
           /tmp/*


# Install s6-overlay
RUN apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
            curl xz-utils \
 && curl -fL -o /tmp/s6-overlay-noarch.tar.xz \
         https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_ver}/s6-overlay-noarch.tar.xz \
 && curl -fL -o /tmp/s6-overlay-bin.tar.xz \
         https://github.com/just-containers/s6-overlay/releases/download/v${s6_overlay_ver}/s6-overlay-x86_64.tar.xz \
 && tar -xf /tmp/s6-overlay-noarch.tar.xz -C / \
 && tar -xf /tmp/s6-overlay-bin.tar.xz -C / \
    \
 # Cleanup unnecessary stuff
 && apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
            curl xz-utils \
 && rm -rf /var/lib/apt/lists/* \
           /tmp/*

ENV S6_KEEP_ENV=1 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=5000


COPY rootfs /

RUN chmod +x /etc/s6-overlay/s6-rc.d/*/run \
             /etc/s6-overlay/s6-rc.d/*/*.sh


EXPOSE 8893

ENTRYPOINT ["/init"]

CMD ["opendmarc", "-f"]

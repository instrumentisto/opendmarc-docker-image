OpenDMARC Docker image
======================

[![Release](https://img.shields.io/github/v/release/instrumentisto/opendmarc-docker-image "Release")](https://github.com/instrumentisto/opendmarc-docker-image/releases)
[![CI](https://github.com/instrumentisto/opendmarc-docker-image/actions/workflows/ci.yml/badge.svg?branch=main "CI")](https://github.com/instrumentisto/opendmarc-docker-image/actions?query=workflow%3ACI+branch%3Amain)
[![Docker Hub](https://img.shields.io/docker/pulls/instrumentisto/opendmarc?label=Docker%20Hub%20pulls "Docker Hub pulls")](https://hub.docker.com/r/instrumentisto/opendmarc)
[![Uses](https://img.shields.io/badge/uses-s6--overlay-blue.svg "Uses s6-overlay")](https://github.com/just-containers/s6-overlay)

[Docker Hub](https://hub.docker.com/r/instrumentisto/opendmarc)
| [GitHub Container Registry](https://github.com/orgs/instrumentisto/packages/container/package/opendmarc)
| [Quay.io](https://quay.io/repository/instrumentisto/opendmarc)

[Changelog](https://github.com/instrumentisto/opendmarc-docker-image/blob/main/CHANGELOG.md)




## Supported tags and respective `Dockerfile` links

- [`1.4.2-r50`, `1.4.2`, `1.4`, `1`, `latest`][101]
- [`1.4.2-r50-alpine`, `1.4.2-alpine`, `1.4-alpine`, `1-alpine`, `alpine`][102]




## What is OpenDMARC?

OpenDMARC is a free open source software implementation of the [DMARC (Domain-based Message Authentication, Reporting and Conformance)][11] specification.

The OpenDMARC Docker image provides a milter-based filter application that can plug in to any milter-aware MTA to provide that service to sufficiently recent sendmail MTAs and other MTAs that support the milter protocol.

OpenDMARC is a unit of [The Trusted Domain Project][16].

> [www.trusteddomain.org/opendmarc](http://www.trusteddomain.org/opendmarc)




## How to use this image

To run OpenDMARC milter application just start the container: 
```bash
docker run -d -p 8893:8893 instrumentisto/opendmarc
```


### Configuration

To configure OpenDMARC you may use one of the following ways (but __not both at the same time__):

1.  __Drop-in files__.  
    Put your configuration files (must end with `.conf`) into `/etc/opendmarc/conf.d/` directory. These files will be applied to default OpenDMARC configuration when container starts.
    
    ```bash
    docker run -d -p 8893:8893 \
               -v /my/custom.conf:/etc/opendmarc/conf.d/10-custom.conf:ro \
           instrumentisto/opendmarc
    ```
    
    This way is convenient if you need only few changes to default configuration, or you want to keep different parts of configuration in different files.

2.  Specify __whole configuration__.  
    Put your configuration file `opendmarc.conf` into `/etc/opendmarc/` directory, so fully replace the default configuration file provided by image.
    
    ```bash
    docker run -d -p 8893:8893 \
               -v /my/custom.conf:/etc/opendmarc/opendmarc.conf:ro \
           instrumentisto/opendmarc
    ```
    
    This way is convenient when it's easier to specify the whole configuration at once, rather than reconfigure default options.

#### Default configuration

To see default OpenDMARC configuration of this Docker image just run:
```bash
docker run --rm instrumentisto/opendmarc cat /etc/opendmarc/opendmarc.conf
```

#### Sending reports

This image comes with [`msmtp` MTA][30] preinstalled, which can be used to send reports when requested via the [`ruf` tag inside a DMARC record][32].

For this to happen, in `opendmarc.conf` set `FailureReports true` and `FailureReportsSentBy` to your (probably `noreply`) sender address. Then, put an `/etc/msmtprc` configuration file that looks like this:
```
defaults
logfile -

account default
host <SMTP host>
port <SMTP port>
from <sender address>
```

Apart from substituting your MTA hostname/port and your sender address (again), consider adding TLS and authentication if you're touching untrusted network. See the [`msmtp` man page][31] for details.

Make sure to avoid mail loops, which can happen if processing a report mails violates its own [DMARC][11] rules, causing more reports.




## Important tips

As far as OpenDMARC writes its logs only to `syslog`, the `syslogd` process runs inside container as second side-process and is supervised with [`s6` supervisor][20] provided by [`s6-overlay` project][21].


### Logs

The `syslogd` process of this image is configured to write everything to `/dev/stdout`.

To change this behaviour just mount your own `/etc/syslog.conf` file with desired log rules.


### s6-overlay

This image contains [`s6-overlay`][21] inside. So you may use all the [features it provides][22] if you need to.




## Image tags


### `<X>`

Latest tag of the latest major `X` OpenDMARC version.


### `<X.Y>`

Latest tag of the latest minor `X.Y` OpenDMARC version.


### `<X.Y.Z>`

Latest tag of the concrete `X.Y.Z` OpenDMARC version.


### `<X.Y.Z>-r<N>`

Concrete `N` image revision tag of the concrete `X.Y.Z` OpenDMARC version.

Once built, it's never updated.


### `alpine`

This image is based on the popular [Alpine Linux project][1], available in [the alpine official image][2]. [Alpine Linux][1] is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This variant is highly recommended when final image size being as small as possible is desired. The main caveat to note is that it does use [musl libc][4] instead of [glibc and friends][5], so certain software might run into issues depending on the depth of their libc requirements. However, most software doesn't have an issue with this, so this variant is usually a very safe choice. See [this Hacker News comment thread][6] for more discussion of the issues that might arise and some pro/con comparisons of using [Alpine][1]-based images.




## License

OpenDMARC is licensed under [BSD license][92].

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

The [sources][90] for producing `instrumentisto/opendmarc` Docker images are licensed under [Blue Oak Model License 1.0.0][91].




## Issues

We can't notice comments in the [DockerHub] (or other container registries) so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us through a [GitHub issue][3].




[DockerHub]: https://hub.docker.com

[1]: http://alpinelinux.org
[2]: https://hub.docker.com/_/alpine
[3]: https://github.com/instrumentisto/opendmarc-docker-image/issues
[4]: http://www.musl-libc.org
[5]: http://www.etalabs.net/compare_libcs.html
[6]: https://news.ycombinator.com/item?id=10782897
[11]: https://dmarc.org
[16]: http://www.trusteddomain.org
[20]: http://skarnet.org/software/s6/overview.html
[21]: https://github.com/just-containers/s6-overlay
[22]: https://github.com/just-containers/s6-overlay#usage
[30]: https://marlam.de/msmtp
[31]: https://marlam.de/msmtp/msmtp.html
[32]: https://dmarc.org/overview#odd_row
[90]: https://github.com/instrumentisto/opendmarc-docker-image
[91]: https://github.com/instrumentisto/opendmarc-docker-image/blob/main/LICENSE.md
[92]: https://sourceforge.net/p/opendmarc/code/ci/master/tree/LICENSE
[101]: https://github.com/instrumentisto/opendmarc-docker-image/blob/main/debian/Dockerfile
[102]: https://github.com/instrumentisto/opendmarc-docker-image/blob/main/alpine/Dockerfile

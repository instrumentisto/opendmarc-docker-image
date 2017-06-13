#!/bin/sh

set -e


# Applying OpenDMARC drop-in .conf files.
for file in /etc/opendmarc/conf.d/*.conf; do
  [ -f "$file" ] || continue
  printf "\n\n#\n# %s\n#\n" "$file" >> /etc/opendmarc/opendmarc.conf
  cat "$file" >> /etc/opendmarc/opendmarc.conf
done

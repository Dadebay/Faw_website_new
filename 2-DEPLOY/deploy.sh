#!/usr/bin/env bash
# FAW Trucks Turkmenistan — deploy a static release to Ubuntu 24.04 (Hostinger KVM 1).
# Run on the VPS as root (or with sudo) AFTER uploading to /tmp either:
#   the site folder  /tmp/faw/   (index.html, img/, fonts/)   or   /tmp/faw-site.zip
#   plus             /tmp/faw.conf  /tmp/deploy.sh
# Safe to re-run for updates: each run creates a new release and switches a symlink.
set -euo pipefail

ZIP=/tmp/faw-site.zip
CONF=/tmp/faw.conf
RELEASES=/var/www/faw-releases
WEBROOT=/var/www/faw                  # symlink -> current release
RELEASE="$RELEASES/$(date +%Y%m%d-%H%M%S)"

SRC_DIR=/tmp/faw
[ -f "$SRC_DIR/index.html" ] || [ -f "$ZIP" ] || { echo "Missing site: upload /tmp/faw/ or $ZIP"; exit 1; }
[ -f "$CONF" ] || { echo "Missing $CONF"; exit 1; }

echo "== 1/6 packages (nginx, unzip, ufw only)"
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx unzip ufw

echo "== 2/6 firewall: SSH first, then HTTP"
ufw allow OpenSSH
ufw allow 'Nginx HTTP'
ufw --force enable
ufw status verbose

echo "== 3/6 release files -> $RELEASE"
mkdir -p "$RELEASES"
if [ -f "$SRC_DIR/index.html" ]; then
  cp -r "$SRC_DIR" "$RELEASE"
else
  TMPDIR=$(mktemp -d)
  unzip -q "$ZIP" -d "$TMPDIR"
  [ -f "$TMPDIR/faw/index.html" ] || { echo "Zip must contain faw/index.html"; exit 1; }
  cp -r "$TMPDIR/faw" "$RELEASE"
  rm -rf "$TMPDIR"
fi
echo "files in release: $(find "$RELEASE" -type f | wc -l)"
chown -R www-data:www-data "$RELEASE"
find "$RELEASE" -type d -exec chmod 755 {} +
find "$RELEASE" -type f -exec chmod 644 {} +
ln -sfn "$RELEASE" "$WEBROOT"

echo "== 4/6 nginx site"
install -m 644 "$CONF" /etc/nginx/sites-available/faw
ln -sfn /etc/nginx/sites-available/faw /etc/nginx/sites-enabled/faw
# The stock 'default' site also claims default_server on :80, so its LINK must be removed.
# Only the symlink in sites-enabled is removed; /etc/nginx/sites-available/default stays untouched.
if [ -L /etc/nginx/sites-enabled/default ]; then
  unlink /etc/nginx/sites-enabled/default
fi
nginx -t

echo "== 5/6 start + enable on boot"
systemctl enable nginx
systemctl reload nginx || systemctl restart nginx

echo "== 6/6 local check"
curl -s -o /dev/null -w "index.html: HTTP %{http_code}, %{size_download} bytes\n" http://127.0.0.1/
curl -s -o /dev/null -w "logo.png:   HTTP %{http_code}\n" http://127.0.0.1/img/logo.png
curl -s -o /dev/null -w "font:       HTTP %{http_code}\n" http://127.0.0.1/fonts/oswald-latin-700-normal.woff2
echo "Releases kept in $RELEASES (rollback: ln -sfn $RELEASES/<old> $WEBROOT && systemctl reload nginx)"
echo "Done. Open http://<VPS_IPv4>/ from a Turkmenistan connection WITHOUT VPN."

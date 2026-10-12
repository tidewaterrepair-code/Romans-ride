#!/usr/bin/env bash
# Installs the Roman's Ride tracking server (Traccar behind Caddy for HTTPS) on Ubuntu or Debian.
# Usage: curl -fsSL https://raw.githubusercontent.com/tidewaterrepair-code/Romans-ride/main/server/install.sh | sudo bash
# Optional: RIDE_HOST=track.example.com to use your own domain instead of a free sslip.io name.
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "Please run with sudo."; exit 1; }
command -v apt-get >/dev/null || { echo "This installer expects Ubuntu or Debian."; exit 1; }

DIR=/opt/romans-ride
REPO=https://github.com/tidewaterrepair-code/Romans-ride.git

echo "==> Installing git and curl"
apt-get update -qq
apt-get install -y -qq git curl ca-certificates >/dev/null

if ! command -v docker >/dev/null; then
  echo "==> Installing Docker"
  curl -fsSL https://get.docker.com | sh
fi

IP=$(curl -fsS4 https://api.ipify.org || curl -fsS4 https://ifconfig.me)
RIDE_HOST="${RIDE_HOST:-${IP//./-}.sslip.io}"

echo "==> Fetching the Romans-ride files"
mkdir -p "$DIR"
cd "$DIR"
if [ -d repo/.git ]; then
  git -C repo pull --ff-only -q
else
  git clone -q --depth 1 "$REPO" repo
fi
cp repo/server/docker-compose.yml docker-compose.yml
echo "RIDE_HOST=$RIDE_HOST" > .env

if command -v ufw >/dev/null && ufw status | grep -q "Status: active"; then
  echo "==> Opening ports 80, 443 and 5055 in the firewall"
  ufw allow 80/tcp >/dev/null; ufw allow 443/tcp >/dev/null; ufw allow 5055/tcp >/dev/null
fi

echo "==> Starting the server"
docker compose pull -q
docker compose up -d

cat <<MSG

Done. It can take a minute for the HTTPS certificate to be issued.

  Tracking dashboard:        https://$RIDE_HOST
  Ride map on this server:   https://$RIDE_HOST/map/
  Server URL for the phone:  https://$RIDE_HOST:5055

Next: open the dashboard, register your account right away (the first account becomes the admin),
then turn off Registration under Settings > Server so nobody else can sign up.

To update later, run this installer again.
MSG

# Roman's Ride Map

An interactive map for group ebike rides around Chic's Beach, Virginia Beach.

Open it on a phone: https://tidewaterrepair-code.github.io/Romans-ride/

## What it does now

- Shows the street map with the riding zone outlined.
- **Edit zone**: drag the corners, drag a `+` to add a corner, or start over and tap a new outline.
- **Add spot**: mark danger spots, meet-up points and notes.
- **Draw route**: draw shortcuts and escape routes.
- **Show my location**: shows where you are and whether you're inside the riding zone.

Map edits are saved in the browser on the phone that made them. Use **Layers → Copy map data** and **Load map data** to move them to another phone.

## Tracking server

Live tracking runs on [Traccar](https://www.traccar.org), self-hosted on a VPS behind Caddy for HTTPS.
On a fresh Ubuntu or Debian VPS:

```
curl -fsSL https://raw.githubusercontent.com/tidewaterrepair-code/Romans-ride/main/server/install.sh | sudo bash
```

It prints three addresses: the tracking dashboard, the ride map served from the same server, and the server URL to enter in the Traccar Client app on each rider's phone. Files are in [`server/`](server/).

## Coming next

1. Show live riders on the ride map, and sync the riding zone to the server.
2. Alerts: leaving the zone, idle too long, possible crash, low battery.
3. Adding other riders and their parents.

Map data © OpenStreetMap contributors.

## Publishing

The site is served by GitHub Pages from the `gh-pages` branch. After changing `main`, publish with `git push origin main:gh-pages`.

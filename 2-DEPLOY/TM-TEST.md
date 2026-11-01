# Turkmenistan connectivity test — FAW Trucks site

Run every test with **VPN / V2Ray / proxy switched OFF**. Write down the network, time and result.

| # | Test | How | Pass when |
|---|------|-----|-----------|
| 0 | Smoke test (before deploying the site) | Open `http://VPS_IP/` right after nginx is installed | The "Welcome to nginx" page opens |
| 1 | Home internet (Türkmentelekom) | Browser: `http://VPS_IP/` | Page opens fully in under ~10 s |
| 2 | Mobile LTE (TMCELL) | Phone, Wi-Fi off: `http://VPS_IP/` | Page opens; slider and model photos appear |
| 3 | Second mobile/office network (if available) | Same as 2 | Same as 2 |
| 4 | Raw HTTP check (Windows) | `curl -o NUL -s -w "%{http_code} %{time_total}s\n" http://VPS_IP/` | `200` and a time |
| 5 | Route | `tracert VPS_IP` | Reaches the VPS (note where it stops if not) |
| 6 | No external requests | Browser DevTools → Network → reload | Every request goes to `VPS_IP` only (site uses no Google, CDN or external API) |
| 7 | Images and fonts | Scroll the whole page, open 2–3 model pages | All photos load; Turkmen letters (ý ň ş ž ä ö ü) display in the site font |
| 8 | Phone links | On a phone tap a number and "Bahasyny soramak" form | Dialer / SMS opens |
| 9 | Repeat | Run 1 and 2 again next morning before the presentation | Still passes (blocks in TM change without notice) |

After a domain is connected:

| # | Test | How | Pass when |
|---|------|-----|-----------|
| 10 | DNS | `nslookup DOMAIN` (ISP DNS, no custom DNS) | Returns `VPS_IP` |
| 11 | HTTP by domain | `http://DOMAIN/` | Page opens |
| 12 | HTTPS by domain | `https://DOMAIN/` | Opens with a valid lock icon, no warnings |
| 13 | HTTPS on mobile | Phone LTE: `https://DOMAIN/` | Opens |

**If test 0 or 1 fails:** the Hostinger IP is not reachable from Turkmenistan. Do not continue on this VPS for the presentation. The same files and nginx config work unchanged on a Türkmentelekom VDS/server inside the country.

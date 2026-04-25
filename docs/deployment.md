# Deployment (Kamal 2)

This template ships with [Kamal 2](https://kamal-deploy.org) infra for deploying a containerized app to a single VPS (Hetzner, DigitalOcean, EC2, etc.) with built-in TLS via `kamal-proxy`.

## What's included

| File | Purpose |
|------|---------|
| `Dockerfile` | Builds your app image (placeholder — fill in your stack) |
| `.dockerignore` | Keeps build context small and avoids leaking secrets |
| `config/deploy.yml` | Kamal config: servers, registry, proxy/TLS, env |
| `.kamal/secrets` | Re-exports named secrets from shell env for Kamal's resolver |
| `Makefile` | Wraps common kamal commands and loads `.env` |

## Prerequisites

1. **Install Kamal locally**: `gem install kamal` (Ruby 3.x). See [kamal-deploy.org/docs/installation](https://kamal-deploy.org/docs/installation/).
2. **Server**: a fresh Linux VPS with public IP, root SSH access, and your SSH key authorized.
3. **DNS**: an **A record** (IPv4) for your domain pointing at the server. See the IPv6 caveat below.
4. **Registry**: an account on Docker Hub, ghcr.io, or any container registry, with push access for your image.
5. **Docker** on your local machine (for building images). Apple Silicon users will rely on `builder.arch: amd64` cross-compilation.

## First-time setup

1. **Fill in TODOs** in `config/deploy.yml`:
   - `service:` name
   - `image:` registry path
   - `proxy.app_port:` your container's listening port
   - `env.clear:` non-secret env vars
   - `env.secret:` names of secrets your app needs

2. **Write the Dockerfile** for your stack. The placeholder runs `sleep infinity` — replace it.

3. **Create `.env`** at the project root (already gitignored):

   ```bash
   # Server / domain
   DEPLOY_HOST=203.0.113.10
   DOMAIN=example.com
   IMAGE=username/my-app

   # Registry credentials
   KAMAL_REGISTRY_USERNAME=username
   KAMAL_REGISTRY_PASSWORD=dckr_pat_...

   # App secrets (must match names in config/deploy.yml `env.secret:`)
   # DATABASE_URL=postgres://...
   # SESSION_SECRET=...
   ```

4. **Add the matching entries** to `.kamal/secrets` so Kamal's resolver finds them.

5. **First deploy**:

   ```bash
   make setup
   ```

   This installs Docker on the server, logs into the registry, builds the image, pushes it, boots `kamal-proxy`, starts your container, and provisions a Let's Encrypt cert for `DOMAIN`.

## Updates

```bash
make deploy       # build, push, restart
make redeploy     # restart current image (no rebuild)
make rollback     # roll back to previous image
make logs         # tail logs
make console      # shell in the running container
```

## TLS and the IPv6 gotcha

`kamal-proxy` issues TLS certs via Let's Encrypt's **HTTP-01 challenge**. The challenge server hits `http://DOMAIN/.well-known/acme-challenge/...` over **whichever address DNS resolves first**.

If your domain has both `A` (IPv4) and `AAAA` (IPv6) records, Let's Encrypt may try IPv6 first. If port 80 isn't reachable on IPv6 (firewall, no AAAA on the server, dual-stack misconfig), issuance fails — even though the IPv4 path works fine.

**Fixes, in order of preference:**

1. **Use only an A record.** Drop the AAAA record until issuance succeeds. Add it back later if you need IPv6.
2. **Open port 80 on IPv6** on the server and confirm `nginx`/`kamal-proxy` binds to `[::]:80`. Most VPS providers default to v4-only firewall rules.
3. **Switch to a custom nginx + certbot accessory stack** — bypasses kamal-proxy entirely. See [calendar-syncer](https://github.com/natyharary/calendar-syncer) for a worked reference (`config/deploy.yml`, `config/nginx/`, `config/certbot/`, `.kamal/hooks/docker-setup`).

The third option is heavier but gives you full control over nginx (rate limiting, custom headers, redirects, multi-domain). Pick it when kamal-proxy isn't enough; otherwise stay on the default.

## Healthcheck

`config/deploy.yml` sets `proxy.healthcheck.path: /up`. Your app must respond `200` at that path or kamal-proxy will refuse to route traffic to a new container. Either implement `/up` or change the path.

## Common issues

- **`HETZNER_IP not set` or similar**: `.env` not loaded. Check the file exists and `make env` shows your vars.
- **Registry push denied**: `docker login` from the same shell, or check `KAMAL_REGISTRY_PASSWORD` is a valid token (not your account password for Docker Hub).
- **Cert never issues**: see IPv6 section above. Also verify port 80 is open in the firewall and DNS has propagated (`dig +short DOMAIN`).
- **Container restarts in a loop**: `make logs` to see why. Often a missing env var or wrong `app_port`.
- **Apple Silicon build is slow**: it's cross-compiling to amd64. Configure a remote builder declaratively in `config/deploy.yml`:
  ```yaml
  builder:
    remote: ssh://root@BUILDER_IP
    arch: amd64
  ```
  Kamal then runs `docker buildx` on the remote host (native amd64) instead of emulating locally.

## Reference

- [Kamal 2 docs](https://kamal-deploy.org/docs/)
- [kamal-proxy](https://github.com/basecamp/kamal-proxy) — the built-in reverse proxy
- [calendar-syncer](https://github.com/natyharary/calendar-syncer) — full custom nginx+certbot example

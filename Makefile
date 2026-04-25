.PHONY: help setup deploy redeploy rollback logs console ps config

# Load .env if present so kamal sees DEPLOY_HOST, DOMAIN, registry creds, etc.
# Create one at project root (gitignored) — see docs/deployment.md.
-include .env
export

help:
	@echo "Kamal deployment targets:"
	@echo ""
	@echo "  setup       first-time server setup (installs Docker, deploys app)"
	@echo "  deploy      build, push, and deploy current code"
	@echo "  redeploy    redeploy current image without rebuilding"
	@echo "  rollback    roll back to previous image"
	@echo "  logs        tail app logs (Ctrl+C to stop)"
	@echo "  console     open shell in running container"
	@echo "  ps          list containers on the server"
	@echo "  config      print combined Kamal config (resolved env + secrets)"
	@echo ""
	@echo "Required env vars (in .env): DEPLOY_HOST, DOMAIN, IMAGE,"
	@echo "  KAMAL_REGISTRY_USERNAME, KAMAL_REGISTRY_PASSWORD, plus app secrets."

setup:
	kamal setup

deploy:
	kamal deploy

redeploy:
	kamal redeploy

rollback:
	kamal rollback

logs:
	kamal app logs -f

console:
	kamal app exec -i --reuse "sh"

ps:
	kamal app details

config:
	kamal config

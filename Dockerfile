# syntax=docker/dockerfile:1.7
#
# Generic Dockerfile placeholder. Replace with your stack.
# Examples below — uncomment/adapt one or write your own.
#
# Kamal builds this image and pushes it to the registry configured in
# config/deploy.yml. Image must run a long-lived foreground process and
# expose the port set in `kamal-proxy.app_port` (default 80).

# --- Node example ---------------------------------------------------------
# FROM node:20-alpine AS builder
# WORKDIR /app
# COPY package.json package-lock.json ./
# RUN npm ci
# COPY . .
# RUN npm run build
#
# FROM node:20-alpine AS runtime
# WORKDIR /app
# ENV NODE_ENV=production
# COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/dist ./dist
# EXPOSE 3000
# CMD ["node", "dist/index.js"]

# --- Python example -------------------------------------------------------
# FROM python:3.12-slim
# WORKDIR /app
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
# COPY . .
# EXPOSE 8000
# CMD ["python", "-m", "myapp"]

# --- Go example -----------------------------------------------------------
# FROM golang:1.22-alpine AS builder
# WORKDIR /src
# COPY go.mod go.sum ./
# RUN go mod download
# COPY . .
# RUN CGO_ENABLED=0 go build -o /app ./cmd/server
#
# FROM alpine:3.20
# COPY --from=builder /app /app
# EXPOSE 8080
# CMD ["/app"]

# TODO: replace with your real Dockerfile
FROM alpine:3.20
CMD ["sh", "-c", "echo 'Replace Dockerfile with your stack — see comments at top.' && sleep infinity"]

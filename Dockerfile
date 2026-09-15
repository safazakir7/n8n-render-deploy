# n8n image for Render.com free tier — ffmpeg + Devanagari fonts baked in,
# listens on Render's injected $PORT.
FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache ffmpeg font-noto font-noto-devanagari
USER node

ENV N8N_PROTOCOL=https
ENV N8N_SECURE_COOKIE=false

# Render sets $PORT at runtime; n8n needs N8N_PORT to match it.
CMD ["/bin/sh", "-c", "export N8N_PORT=${PORT:-5678} && n8n start"]

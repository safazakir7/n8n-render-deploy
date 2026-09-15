# n8n's official image has no package manager (hardened base) — so we fetch
# a static ffmpeg binary and Devanagari/Latin fonts directly instead of
# apk/apt-get, and drop them straight into the image.
FROM n8nio/n8n:latest

USER root

ADD https://github.com/BtbN/FFmpeg-Builds/releases/latest/download/ffmpeg-master-latest-linux64-gpl.tar.xz /tmp/ffmpeg.tar.xz
RUN mkdir -p /tmp/ffmpeg-extract && \
    tar -xf /tmp/ffmpeg.tar.xz -C /tmp/ffmpeg-extract --strip-components=1 && \
    cp /tmp/ffmpeg-extract/bin/ffmpeg /usr/local/bin/ffmpeg && \
    cp /tmp/ffmpeg-extract/bin/ffprobe /usr/local/bin/ffprobe && \
    chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe && \
    rm -rf /tmp/ffmpeg.tar.xz /tmp/ffmpeg-extract

RUN mkdir -p /usr/share/fonts/truetype/noto
ADD https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSansDevanagari/hinted/ttf/NotoSansDevanagari-Regular.ttf /usr/share/fonts/truetype/noto/NotoSansDevanagari-Regular.ttf
ADD https://raw.githubusercontent.com/notofonts/notofonts.github.io/main/fonts/NotoSans/hinted/ttf/NotoSans-Regular.ttf /usr/share/fonts/truetype/noto/NotoSans-Regular.ttf

USER node

ENV N8N_PROTOCOL=https
ENV N8N_SECURE_COOKIE=false

# No custom CMD/ENTRYPOINT override — use the base image's own entrypoint,
# which knows how to start n8n correctly on this hardened base.
# Port is fixed via PORT + N8N_PORT env vars set on the Render service itself.

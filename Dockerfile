# n8n's official image has no package manager (hardened base) — so we fetch
# a static ffmpeg binary and a Devanagari font file directly instead of
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

# Render sets $PORT at runtime; n8n needs N8N_PORT to match it.
CMD ["/bin/sh", "-c", "export N8N_PORT=${PORT:-5678} && n8n start"]

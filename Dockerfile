# itzg/minecraft-server を Pterodactyl/Wings で動かすための薄いラッパー
# 使い方: docker build --build-arg TAG=java21 -t ghcr.io/YOUR_NAME/itzg-ptero:java21 .
ARG TAG=latest
FROM itzg/minecraft-server:${TAG}

USER root

# itzg のスクリプトは /data 固定のため、Pterodactyl の /home/container に書き換える（未検証・要確認）
RUN set -eux; \
    test -d /image; \
    grep -rlI '/data' /image | xargs -r perl -pi -e 's#(?<![\w./:-])/data(?![\w-])#/home/container#g'; \
    mkdir -p /home/container; \
    chmod 777 /home/container

ENV HOME=/home/container
WORKDIR /home/container

COPY pterodactyl-entrypoint.sh ./pterodactyl-entrypoint.sh
RUN chmod +x ./pterodactyl-entrypoint.sh

ENTRYPOINT ["/home/container/pterodactyl-entrypoint.sh"]

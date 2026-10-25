#!/bin/bash
# Pterodactyl は egg の全変数を（空でも）環境変数として渡す。
# itzg では「空文字」は「プロパティをクリア」を意味するため、空の変数は unset して既定動作に任せる。
# 意図的に空文字を設定したい場合は値に __EMPTY__ を指定する。
cd /home/container || exit 1

for name in $(compgen -e); do
  case "$name" in HOME|PATH|PWD|HOSTNAME|TERM|USER|SHLVL|_) continue ;; esac
  val="${!name}"
  if [ -z "$val" ]; then
    unset "$name"
  elif [ "$val" = "__EMPTY__" ]; then
    export "$name="
  fi
done

# MEMORY 未指定なら Panel のメモリ制限(MB)の 85% を採用
if [ -z "${MEMORY:-}" ] && [ -z "${MAX_MEMORY:-}" ] && [ "${SERVER_MEMORY:-0}" -gt 0 ] 2>/dev/null; then
  export MEMORY="$((SERVER_MEMORY * 85 / 100))M"
fi

exec /image/scripts/start "$@"

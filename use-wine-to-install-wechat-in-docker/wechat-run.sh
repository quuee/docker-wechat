#!/bin/bash

docker start wine-wechat && \
docker exec wine-wechat bash -c 'wine /root/.wine/drive_c/Program\ Files/Tencent/WeChat/WeChat.exe'
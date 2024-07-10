FROM node:14.16.1-alpine AS build

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache ca-certificates python3 py3-pip
RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Chongqing /etc/localtime \
    && echo "Asia/Chongqing" > /etc/timezone
RUN apk add --no-cache make g++



RUN npm config set registry  https://registry.npmmirror.com
# 设置目录
RUN mkdir -p /app/data /app/server /app/client/dist  /app/docker

# copy docker  file
WORKDIR /app/docker
ADD docker /app/docker

## 前端页
WORKDIR /app/client/dist
ADD client/dist /app/client/dist

# 增加server
WORKDIR /app/server
ADD server /app/server
RUN npm install
EXPOSE 8081/tcp

ENTRYPOINT ["/app/docker/docker-entrypoint.sh"]

FROM ubuntu:latest
LABEL authors="Lenovo"

ENTRYPOINT ["top", "-b"]
# 构建阶段：基于Node.js编译Angular应用
FROM node:10-alpine as node
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY ./ /app/
ARG TARGET=ng-deploy
RUN npm run ${TARGET}

# 生产阶段：基于Nginx部署编译后的应用
FROM nginx:1.13
COPY --from=node /app/dist/ /usr/share/nginx/html
COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

#! /bin/bash  
IMAGE="swagger-api-image"
NAME="swagger-api"
# 删除原容器&镜像
docker rm -f $NAME || echo
docker rmi -f $IMAGE || echo
# 构建镜像
docker build -t $IMAGE .
# 运行容器
docker run -d --restart always -p 8080:8080 -e API_URLS="[{url: 'demo_api_1.json', name : '接口一'}, {url: 'demo_api_2.json', name : '接口二'}]" --name $NAME $IMAGE
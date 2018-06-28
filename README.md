> "swagger接口服务是我本机，如果我下班关机回家，对方如何进行联调？"

如果你有类似的疑问，这个项目可以帮助你。

## 背景

出于稳定性考虑，在提测前不允许发布到测试环境，开发阶段如何保障swagger接口的稳定性？

## 方案

```plantuml

actor java_producer_coder
actor java_consumer_coder
actor js_consumer_coder

cloud {
    control nginx
    node "swagger-ui" AS swagger #green
    node "swagger-json" AS json
}

java_consumer_coder --> swagger
js_consumer_coder --> swagger
swagger -right-> nginx
nginx -down-> json
java_producer_coder -up-> json: push 接口json文件

```

![s0](http://image.crick.wang/s0.png)

1. 搭建swagger-ui服务
2. 接口owner将swagger json文件上传至静态目录发布。swagger-ui内部包含nginx服务。

在安装了docker的机器，通过`run.sh`可以执行镜像build及容器运行。

## 实现

### docker搭建swagger-ui服务

**Dockerfile**

```
from swaggerapi/swagger-ui

ENV API_URL=http://localhost:8080/demo_api_1.json

#ENV API_URLS="[{url: 'http://localhost:8080/demo_api_1.json', name : '接口一'}, {url: 'http://localhost:8080/demo_api_2.json', name : '接口二'}]"

COPY ./api/*.json /usr/share/nginx/html/
```

### 发布接口
**static**目录下是接口json文件
通过 http://localhost:8080/v2/api-docs 获取json文件，命名后push到git项目**api**目录下

### 访问swagger
浏览器访问swagger-ui服务，并在窗口输入json文件访问路径 https://localhost:8080/demo_api_2.json ，然后就可以看到swagger接口定义。

![s1](http://image.crick.wang/s1.jpg)

## 缺陷

1. 不能根据代码动态更新，需要owner手动push接口json文件。
2. 需要手动输入json访问url。
3. 无法执行try it out

关于**缺陷2**可以考虑使用`API_URLS`环境变量实现，但是设置后，不能自定义输入jsonUrl

```
from swaggerapi/swagger-ui

ENV API_URLS="[{url: 'http://localhost:8080/demo_api_1.json', name : '接口一'}, {url: 'http://localhost:8080/demo_api_2.json', name : '接口二'}]"

COPY ./api/*.json /usr/share/nginx/html/
```

效果图如下
![s2](http://image.crick.wang/s2.png)


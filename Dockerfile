from swaggerapi/swagger-ui

ENV API_URL=http://localhost:8080/demo_api_1.json

#ENV API_URLS="[{url: 'http://localhost:8080/demo_api_1.json', name : '接口一'}, {url: 'http://localhost:8080/demo_api_2.json', name : '接口二'}]"

COPY ./api/*.json /usr/share/nginx/html/
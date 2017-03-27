echo 'console.log("Hello World v1");' > index.js
docker build -t app:v0.0.1 .
docker run app:v0.0.1

docker build -t app:v0.0.2 .
docker run app:v0.0.2

echo 'console.log("Hello World v3");' > index.js
docker build -t app:v0.0.3 .
docker run app:v0.0.3

echo 'console.log("Hello World v4");' > index.js
echo 'console.log("Hello Service");' > service.js
docker build -t app:v0.0.4 .
docker run app:v0.0.4 node /code/service.js

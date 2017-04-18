Build the image

```bash
echo 'console.log("Hello World v1");' > index.js
docker build -t app:v0.0.1 .
docker run app:v0.0.1
```

Build without changing index.js but with diferent tag name

```bash
docker build -t app:v0.0.2 .
docker run app:v0.0.2
```

Build again but this time changing index.js
```bash
echo 'console.log("Hello World v3");' > index.js
docker build -t app:v0.0.3 .
docker run app:v0.0.3
```

Build a new one but run a difference command

```bash
echo 'console.log("Hello World v4");' > index.js
echo 'console.log("Hello Service");' > service.js
docker build -t app:v0.0.4 .
docker run app:v0.0.4 node /code/service.js
```

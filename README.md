# Docker

It contains fake implmentations for

1. [docker-compose](#compose)
2. Bla bla bla



Dockerfile

```Dockerfile
FROM node:alpine
RUN mkdir -p /code
WORKDIR /code
ADD . .
CMD ["node", "index.js"]
```

Create the file index.js

```bash
$ echo 'console.log("Hello World v1")' > index.js
```

Build the image with name "app" and tag "v1"

```bash
$ docker build -t app:v1 .

Sending build context to Docker daemon 72.19 kB
Step 1/5 : FROM node:alpine
alpine: Pulling from library/node
709515475419: Pull complete
278538de9ce7: Pull complete
732a325308f5: Pull complete
Digest: sha256:aa698f64736e0a8ae1c4d8ffaf62fc82fc81a2140d3f1c8d1457f9e491b1b444
Status: Downloaded newer image for node:alpine
 ---> 7fce0a61c1d6
Step 2/5 : RUN mkdir -p /code
 ---> Running in 7202aba827b0
 ---> 8bf482825b9f
Removing intermediate container 7202aba827b0
Step 3/5 : WORKDIR /code
 ---> c7519937adf2
Removing intermediate container 28be35124410
Step 4/5 : ADD . .
 ---> 436f7aabe89c
Removing intermediate container 61ce51a85aa3
Step 5/5 : CMD node index.js
 ---> Running in 5841019420ae
 ---> dad357377fb1
Removing intermediate container 5841019420ae
Successfully built dad357377fb1
```

Here we can list all the images including the recently created

```bash
$ docker images

REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
app                 v1                  dad357377fb1        About a minute ago   59 MB
node                alpine              7fce0a61c1d6        3 days ago           59 MB
```

Run the image


```bash
$ docker run app:v1

Hello World v1
```


Modify index.js

```bash
$ echo 'console.log("Hello World v2")' > index.js
```

Build the image with tag "v2". As we can see docker uses a cache for every command in the Dockerfile except the 4 command the ADD because index.js was changed.

```bash
$ docker build -t app:v2 .

Sending build context to Docker daemon 72.19 kB
Step 1/5 : FROM node:alpine
 ---> 7fce0a61c1d6
Step 2/5 : RUN mkdir -p /code
 ---> Using cache
 ---> 8bf482825b9f
Step 3/5 : WORKDIR /code
 ---> Using cache
 ---> c7519937adf2
Step 4/5 : ADD . .
 ---> 3ae6ce5c8810
Removing intermediate container 313f37ac5a7d
Step 5/5 : CMD node index.js
 ---> Running in ecd688005ff9
 ---> ed75a74886a2
Removing intermediate container ecd688005ff9
Successfully built ed75a74886a2
```

Run the v2 image

```bash
$ docker run app:v2

Hello World v2
```

We can see the 2 images

```bash
$ docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
app                 v2                  ed75a74886a2        7 minutes ago       59 MB
app                 v1                  dad357377fb1        24 minutes ago      59 MB
node                alpine              7fce0a61c1d6        3 days ago          59 MB
```

Each Docker image references a list of read-only layers that represent filesystem differences. Layers are stacked on top of each other to form a base for a container’s root filesystem.

With the command history we can describe all the layers of an image.


```bash
$ docker history app:v1

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
dad357377fb1        36 minutes ago      /bin/sh -c #(nop)  CMD ["node" "index.js"]      0 B
436f7aabe89c        36 minutes ago      /bin/sh -c #(nop) ADD dir:a706a135bebb1301...   21.2 kB
c7519937adf2        36 minutes ago      /bin/sh -c #(nop) WORKDIR /code                 0 B
8bf482825b9f        36 minutes ago      /bin/sh -c mkdir -p /code                       0 B
7fce0a61c1d6        3 days ago          /bin/sh -c #(nop)  CMD ["node"]                 0 B
<missing>           3 days ago          /bin/sh -c apk add --no-cache --virtual .b...   3.71 MB
<missing>           3 days ago          /bin/sh -c #(nop)  ENV YARN_VERSION=0.23.2      0 B
<missing>           11 days ago         /bin/sh -c addgroup -g 1000 node     && ad...   50.5 MB
<missing>           11 days ago         /bin/sh -c #(nop)  ENV NODE_VERSION=7.9.0       0 B
<missing>           7 weeks ago         /bin/sh -c #(nop)  ENV NPM_CONFIG_LOGLEVEL...   0 B
<missing>           7 weeks ago         /bin/sh -c #(nop) ADD file:3df55c321c1c8d7...   4.81 MB
```

```bash
$ docker history app:v2

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
ed75a74886a2        20 minutes ago      /bin/sh -c #(nop)  CMD ["node" "index.js"]      0 B
3ae6ce5c8810        20 minutes ago      /bin/sh -c #(nop) ADD dir:4c7d1f1438ce1c97...   21.2 kB
c7519937adf2        38 minutes ago      /bin/sh -c #(nop) WORKDIR /code                 0 B
8bf482825b9f        38 minutes ago      /bin/sh -c mkdir -p /code                       0 B
7fce0a61c1d6        3 days ago          /bin/sh -c #(nop)  CMD ["node"]                 0 B
<missing>           3 days ago          /bin/sh -c apk add --no-cache --virtual .b...   3.71 MB
<missing>           3 days ago          /bin/sh -c #(nop)  ENV YARN_VERSION=0.23.2      0 B
<missing>           11 days ago         /bin/sh -c addgroup -g 1000 node     && ad...   50.5 MB
<missing>           11 days ago         /bin/sh -c #(nop)  ENV NODE_VERSION=7.9.0       0 B
<missing>           7 weeks ago         /bin/sh -c #(nop)  ENV NPM_CONFIG_LOGLEVEL...   0 B
<missing>           7 weeks ago         /bin/sh -c #(nop) ADD file:3df55c321c1c8d7...   4.81 MB
```

We can see that only the last 2 layers aren't shared between app:v1 and app:v2. The command ADD is not shared because the file index.js changed and all the subsequent commands couldn't be shared as well.

Every other line represent a layer in other images. In this case we have 3 images: app:v1 => node:alpine => alpine:3.4.

app:v2

```bash
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
ed75a74886a2        20 minutes ago      /bin/sh -c #(nop)  CMD ["node" "index.js"]      0 B
3ae6ce5c8810        20 minutes ago      /bin/sh -c #(nop) ADD dir:4c7d1f1438ce1c97...   21.2 kB
c7519937adf2        38 minutes ago      /bin/sh -c #(nop) WORKDIR /code                 0 B
8bf482825b9f        38 minutes ago      /bin/sh -c mkdir -p /code                       0 B

```

node:alpine

```bash
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
7fce0a61c1d6        3 days ago          /bin/sh -c #(nop)  CMD ["node"]                 0 B
<missing>           3 days ago          /bin/sh -c apk add --no-cache --virtual .b...   3.71 MB
<missing>           3 days ago          /bin/sh -c #(nop)  ENV YARN_VERSION=0.23.2      0 B
<missing>           11 days ago         /bin/sh -c addgroup -g 1000 node     && ad...   50.5 MB
<missing>           11 days ago         /bin/sh -c #(nop)  ENV NODE_VERSION=7.9.0       0 B
<missing>           7 weeks ago         /bin/sh -c #(nop)  ENV NPM_CONFIG_LOGLEVEL...   0 B
```

alpine:3.4

```bash
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
<missing>           7 weeks ago         /bin/sh -c #(nop) ADD file:3df55c321c1c8d7...   4.81 MB
```



The command CMD in the Dockerfile is for setting the default command to execute. We can override the command when running the image.


```bash
$ echo 'console.log("Hello World Override CMD")' > override-cmd.js
$ docker build -t app:v3 .
$ docker run app:v3 node /code/override-cmd.js

Hello World Override CMD
```




examples of using nginx. Use port volume. show build vs runtime.







# Compose

```yaml
version: '2'
services:
  web:
    image: nginx:alpine
    ports:
      - 80:80
    depends_on:
      - php
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
  php:
    build: ./php/
    env_file: .env
    environment:
      - MYSQL_HOSTMAME=db
      - MYSQL_USER=root
    depends_on:
      - db
    ports:
      - 9000:9000
    volumes:
      - ./php:/code/
  db:
    image: mysql:latest
    env_file: .env
    environment:
      - MYSQL_ROOT_PASSWORD=123456
    ports:
      - 3306:3306
    volumes:
      - ./mysql/data:/var/lib/mysql
```



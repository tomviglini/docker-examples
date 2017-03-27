FROM node:alpine
RUN mkdir -p /code
WORKDIR /code
ADD . .
CMD ["node", "index.js"]

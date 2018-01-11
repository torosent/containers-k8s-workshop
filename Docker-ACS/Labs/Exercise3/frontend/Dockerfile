FROM node:latest

RUN mkdir /src
WORKDIR /code

RUN npm install -g nodemon@1.11.0

COPY . /code
RUN npm install

CMD ["npm", "start"]

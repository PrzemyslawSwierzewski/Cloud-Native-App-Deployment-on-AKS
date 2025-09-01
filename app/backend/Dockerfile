FROM node:lts-alpine

WORKDIR /usr/src

COPY package*.json ./
RUN npm install --silent

COPY . .

EXPOSE 4000

USER node

CMD ["npm", "start"]

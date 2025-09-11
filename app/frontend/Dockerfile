# Stage 1: Build React app
FROM node:16-alpine AS build

WORKDIR /usr/src

COPY package*.json ./
RUN npm install --silent

COPY . .

RUN npm run build

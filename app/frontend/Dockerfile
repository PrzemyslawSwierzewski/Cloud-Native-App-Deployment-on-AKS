# Stage 1: Build React app
FROM node:16-alpine AS build

WORKDIR /usr/src

COPY package*.json ./

ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

RUN npm install --silent

COPY . .

RUN npm run build

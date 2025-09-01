# Stage 1: Build React app
FROM node:16-alpine AS build

WORKDIR /usr/src

COPY package*.json ./
RUN npm install --silent

COPY . .

ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /usr/src/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

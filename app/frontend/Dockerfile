# Stage 1: Build React app
FROM node:16-alpine AS build

WORKDIR /usr/src

COPY package*.json ./
RUN npm install --silent

COPY . .
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy React build to nginx html directory
COPY --from=build /usr/src/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

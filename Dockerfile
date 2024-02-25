# Use the official Node.js image as the base image for building
FROM node:latest as build-stage

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the Vue.js app for production
RUN npm run build

# Use the official Nginx image as the base image for serving
FROM nginx:latest

COPY nginx.conf /etc/nginx/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy the built Vue.js app from the build-stage container to the Nginx container
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 8080 to the outside world
EXPOSE 8080

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]

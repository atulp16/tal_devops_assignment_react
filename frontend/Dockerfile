### STAGE 1: Build ###
FROM node:18 AS builder
WORKDIR /usr/src/app

# Set NODE_OPTIONS to use the legacy OpenSSL provider
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy package.json and package-lock.json first to leverage Docker caching
COPY package.json package-lock.json /usr/src/app/

# Install dependencies
RUN npm install --silent

# Copy the rest of the application files
COPY . /usr/src/app

# Run the build step
RUN npm run build

### STAGE 2: Production Environment ###
FROM nginx:1.13.12-alpine

# Copy the build output from the builder stage to the nginx container
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# Expose port 80 for the Nginx server
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

# Stage 1: Build Stage
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all source code into the container
COPY . .

# Build the application if needed (e.g., transpile TypeScript or bundle assets)
# For example, you could add a build step like:
#RUN npm run build  # Uncomment if you're building your app (e.g., for TypeScript)
#RUN npm run build

# Stage 2: Production Stage
FROM node:18-alpine

# Install curl in the backend image
RUN apk --no-cache add curl

# Set working directory
WORKDIR /app

# Copy dependencies from the build stage (no need to reinstall)
COPY --from=build /app/node_modules /app/node_modules

# Copy only the built source code (or your runtime files) from the build stage
COPY --from=build /app /app

# Expose the application port
EXPOSE 3001

# Command to run the app
CMD ["npm", "start"]

# Use official Node.js image
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy package.json and package-lock.json from root (not src/)
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy all backend source files from root
COPY . .

# Expose backend port
EXPOSE 5000

# Start the server
CMD ["npm", "start"]
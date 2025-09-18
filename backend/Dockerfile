# Use official Node.js image
FROM node:18

# Set working directory inside container
WORKDIR /app

# Copy package.json and package-lock.json from src folder
COPY src/package*.json ./

# Install dependencies
RUN npm install

# Copy all source files from src folder
COPY src ./

# Expose backend port
EXPOSE 5000

# Start the server
CMD ["node", "index.js"]
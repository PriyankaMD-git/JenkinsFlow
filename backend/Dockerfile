# Use Node.js base image
FROM node:18

# Set working directory inside container
WORKDIR /app

# Copy package.json and install dependencies
COPY src/package*.json ./
RUN npm install

# Copy all source files
COPY src ./

# Expose backend port
EXPOSE 5000

# Start the server
CMD ["node", "index.js"]
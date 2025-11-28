# todos-api/Dockerfile
FROM node:14-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

EXPOSE 8082

CMD ["npm", "start"]

# Stage 1: Hardhat (Backend) Environment
FROM node:18-alpine AS hardhat

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all files and build smart contracts
COPY . .
RUN npx hardhat compile

# Stage 2: React Frontend
FROM node:18-alpine AS react

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy frontend files and build React app
COPY . .
RUN npm run build

# Final Stage: Serve Frontend
FROM nginx:alpine

WORKDIR /usr/share/nginx/html
COPY --from=react /app/build .

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

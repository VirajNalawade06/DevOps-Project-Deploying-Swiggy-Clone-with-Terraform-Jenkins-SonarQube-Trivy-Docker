# Use a supported Node.js LTS version
FROM node:20-alpine

WORKDIR /app

# Copy dependency manifests first for better Docker caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application source code
COPY . .

# Build the production bundle
RUN npm run build

# Expose the app port
EXPOSE 3000

# Run the React development server for local container usage
CMD ["npm", "start"]

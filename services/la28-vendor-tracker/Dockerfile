FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
COPY src ./src
EXPOSE 3800
HEALTHCHECK --interval=30s --timeout=10s --start-period=45s --retries=8 \
  CMD node -e "require('http').get('http://localhost:3800/health', r => process.exit(r.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"
CMD ["node", "src/index.js"]

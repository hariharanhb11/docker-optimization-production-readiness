########################
# Build Stage
########################
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies first 
COPY app/package*.json ./
RUN npm ci

# Copy application source
COPY app/ .

########################
# Runtime Stage
########################
FROM node:20-alpine

WORKDIR /app

# Copy only built app from builder stage
COPY --from=builder /app .

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# App port
EXPOSE 3000

HEALTHCHECK --interval=30s \
  --timeout=5s \
  --start-period=10s \
  --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

# Start application
CMD ["node", "src/server.js"]

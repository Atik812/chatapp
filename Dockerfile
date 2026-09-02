# =========================
# Stage 1: Build frontend
# =========================
FROM node:22-alpine AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./

RUN npm ci

COPY frontend/ ./

RUN npm run build


# =========================
# Stage 2: Production backend
# =========================
FROM node:22-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

# Install backend dependencies first
COPY backend/package*.json ./backend/

RUN cd backend && npm ci --omit=dev

# Copy backend source
COPY backend/ ./backend/

# Copy compiled frontend
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

WORKDIR /app/backend/src

EXPOSE 5001

CMD ["node", "index.js"]
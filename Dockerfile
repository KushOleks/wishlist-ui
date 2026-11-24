FROM node:24.21.0-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
ARG VITE_API_BASE
ENV VITE_API_BASE=${VITE_API_BASE}
RUN test -n "$VITE_API_BASE" && npm run build

FROM build AS development
EXPOSE 5173
CMD ["sh", "-c", "npm ci --no-audit --no-fund && exec npm run dev -- --host 0.0.0.0 --port 5173"]

FROM nginx:1.28.0-alpine AS production
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/ /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=5 \
  CMD ["wget", "-q", "-O", "/dev/null", "http://127.0.0.1/health"]
CMD ["nginx", "-g", "daemon off;"]

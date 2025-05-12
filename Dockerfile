# syntax=docker/dockerfile:1

########################
# 🔧 Stage 1: Build
########################
FROM node:lts-alpine AS builder

# Устанавливаем переменные окружения
ENV NODE_ENV=production

WORKDIR /app

# Копируем только package.json и yarn.lock для кэширования слоев
COPY package.json yarn.lock ./

# Устанавливаем только продакшн-зависимости
RUN yarn install --production

# Копируем остальной исходный код
COPY . .

########################
# 🚀 Stage 2: Runtime
########################
FROM node:lts-alpine AS runtime

# Устанавливаем переменную окружения (на всякий случай)
ENV NODE_ENV=production

WORKDIR /app

# Копируем только node_modules и исходники из предыдущего этапа
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app .

# Открываем порт (если нужно)
EXPOSE 3000

# Запускаем приложение
CMD ["node", "src/index.js"]

# -------- build stage ---------------
FROM node:22-alpine AS builder

WORKDIR /app

RUN npm i -g pnpm

COPY package.json pnpm-lock.yaml ./

RUN pnpm install

COPY . .

RUN pnpm build


# --------- runtime stage ------------

FROM node:22-alpine AS runner

WORKDIR /app

RUN npm i -g pnpm

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json /app/pnpm-lock.yaml ./
COPY --from=builder /app/node_modules ./node_modules

CMD [ "pnpm", "start" ]

# Mist Backend

API REST do projeto Mist - Models Stylist.

## Stack

- Node.js com TypeScript.
- Fastify para API HTTP.
- Prisma ORM com PostgreSQL.
- RabbitMQ para mensageria.
- JWT, cookies HTTP-only e bcrypt para autenticacao.
- Swagger/Scalar para documentacao interativa.

## Execucao local

Instale as dependencias:

```bash
npm install
```

Crie o arquivo `.env`:

```bash
cp .env.example .env
```

Suba os servicos de infraestrutura:

```bash
docker compose up -d
```

Prepare o Prisma:

```bash
npm run prisma:generate
npm run prisma:migrate
```

Inicie o servidor:

```bash
npm run dev
```

## URLs

- API: `http://localhost:3333`
- Documentacao: `http://localhost:3333/docs`
- Health check: `http://localhost:3333/health`
- RabbitMQ Management: `http://localhost:15673`

## Modulos

- `auth`: cadastro, login, logout e verificacao de sessao.
- `clientes`: CRUD de clientes.
- `estilistas`: CRUD de estilistas.
- `agendamentos`: criacao, listagem, atualizacao de status e exclusao.
- `services/messaging`: publicacao e consumo de eventos RabbitMQ.
- `workers`: consumidores das filas de agendamento.

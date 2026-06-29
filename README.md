# Mist - Models Stylist

Mist e um sistema academico para conectar clientes a estilistas/model stylists. O projeto permite cadastro e autenticacao de usuarios, consulta de estilistas, criacao de solicitacoes de agendamento e acompanhamento do status do atendimento.

O repositorio esta organizado com:

- `code/backend`: API REST em Node.js/TypeScript com Fastify, Prisma, PostgreSQL e RabbitMQ.
- `code/mist_mobile`: aplicativo Flutter. O mesmo projeto contem os fluxos do app cliente e do app prestador/estilista, separados por telas, servicos e navegacao conforme o perfil autenticado.
- `diagramas`: artefatos visuais da arquitetura/modelagem.
- `documentos`: documentos das sprints e relatorio tecnico final.
- `testes`: colecao Postman para validacao manual da API.

## Tecnologias

- Backend: Node.js, TypeScript, Fastify, Prisma ORM, PostgreSQL, RabbitMQ, JWT, bcrypt, Swagger/Scalar.
- Mobile: Flutter/Dart, `http`, `shared_preferences`.
- Infra local: Docker Compose para PostgreSQL e RabbitMQ.

## Requisitos

- Node.js 20+.
- npm.
- Docker e Docker Compose.
- Flutter SDK 3.x.
- Emulador Android, dispositivo fisico ou ambiente desktop/web Flutter.

## Executando o backend

Entre na pasta do backend:

```bash
cd code/backend
```

Instale as dependencias:

```bash
npm install
```

Crie o arquivo `.env` a partir do exemplo:

```bash
cp .env.example .env
```

Suba PostgreSQL e RabbitMQ:

```bash
docker compose up -d
```

Execute as migrations e gere o client Prisma:

```bash
npm run prisma:generate
npm run prisma:migrate
```

Inicie a API:

```bash
npm run dev
```

Servicos locais:

- API: `http://localhost:3333`
- Documentacao da API: `http://localhost:3333/docs`
- Health check: `http://localhost:3333/health`
- RabbitMQ Management: `http://localhost:15673` (`admin` / `admin`)
- PostgreSQL: porta local `5433`

## Executando o app Flutter

Entre na pasta mobile:

```bash
cd code/mist_mobile
```

Instale as dependencias:

```bash
flutter pub get
```

Execute o aplicativo:

```bash
flutter run
```

Por padrao, o app usa `http://10.0.2.2:3333` em `lib/services/api_client.dart`, que funciona para emulador Android acessando a API da maquina local. Para dispositivo fisico, altere `baseUrl` para o IP da maquina na rede, por exemplo `http://192.168.0.10:3333`.

## Fluxos principais

- Cadastro e login de cliente ou estilista.
- Cliente consulta estilistas, cria agendamentos e acompanha solicitacoes.
- Estilista visualiza solicitacoes recebidas e atualiza o status.
- API publica eventos de criacao e atualizacao de agendamentos no RabbitMQ.
- Worker consome filas de prioridade e status para processamentos assincronos.

## Endpoints principais

- `POST /auth/signup`: cria conta de cliente ou estilista.
- `POST /auth/login`: autentica usuario.
- `POST /auth/logout`: encerra sessao.
- `GET /auth/check-auth`: valida autenticacao.
- `GET /clientes`, `GET /clientes/:id`, `PUT /clientes/:id`, `DELETE /clientes/:id`.
- `GET /estilistas`, `GET /estilistas/:id`, `PUT /estilistas/:id`, `DELETE /estilistas/:id`.
- `POST /agendamentos`, `GET /agendamentos`, `GET /agendamentos/:id`.
- `GET /agendamentos/cliente/:clienteId`.
- `GET /agendamentos/estilista/:estilistaId`.
- `PATCH /agendamentos/:id/status`.
- `DELETE /agendamentos/:id`.

## Testes manuais

A colecao Postman esta em `testes/ColecaoTestPostmanMist.json`. Depois de iniciar a API, importe a colecao no Postman e execute os cenarios de autenticacao, cadastro, consulta e agendamento.

## Relatorio final

O relatorio tecnico final esta em `documentos/RelatorioTecnicoFinal.md`.

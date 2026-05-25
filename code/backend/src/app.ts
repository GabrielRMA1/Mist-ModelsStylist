import Fastify from "fastify";
import swagger from "@fastify/swagger";
import fastifyCookie from '@fastify/cookie';
import scalarApiReference from "@scalar/fastify-api-reference";

import { clienteRoutes } from "./modules/clientes/clienteRoutes.js";
import { estilistaRoutes } from "./modules/estilistas/estilistaRoutes.js";
import { agendamentoRoutes } from "./modules/agendamentos/agendamentoRoutes.js";
import { authRoutes } from "./modules/auth/authRoutes.js";
import { rabbitMQConfig } from "./config/rabbitmq/index.js";

export const app = Fastify({
  logger: false,
});

app.register(fastifyCookie);

await app.register(swagger, {
  openapi: {
    info: {
      title: "Mist API",
      description: "Documentação da API do projeto Mist - Models Stylist.",
      version: "1.0.0",
    },
    servers: [
      {
        url: "http://localhost:3333",
        description: "Servidor local",
      },
    ],
    tags: [
      {
        name: "Clientes",
        description: "Rotas relacionadas aos clientes.",
      },
      {
        name: "Estilistas",
        description: "Rotas relacionadas aos estilistas.",
      },
      {
        name: "Agendamentos",
        description: "Rotas relacionadas às solicitações de agendamento.",
      },
    ],
  },
});

await app.register(scalarApiReference, {
  routePrefix: "/docs",
  configuration: {
    title: "Mist API Reference",
  },
});

try {
  await rabbitMQConfig.connect();
  app.log.info('RabbitMQ conectado com sucesso');
} catch (error) {
  app.log.error('Erro ao conectar ao RabbitMQ');
}

app.get("/health", async () => {
  return {
    status: "ok",
    message: "Mist API está funcionando.",
    rabbitmq: rabbitMQConfig.getConnectionStatus() ? "conectado" : "desconectado",
  };
});

await app.register(clienteRoutes, {
  prefix: "/clientes",
});

await app.register(estilistaRoutes, {
  prefix: "/estilistas",
});

await app.register(agendamentoRoutes, {
  prefix: "/agendamentos",
});

await app.register(authRoutes, {
  prefix: '/auth',
});

app.addHook('onClose', async () => {
  try {
    await rabbitMQConfig.close();
  } catch (error) {
    app.log.error('Erro ao fechar RabbitMQ');
  }
});
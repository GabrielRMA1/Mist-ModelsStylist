import Fastify from "fastify";
import swagger from "@fastify/swagger";
import scalarApiReference from "@scalar/fastify-api-reference";

import { clienteRoutes } from "./modules/clientes/clienteRoutes.js";

// Cria a instância principal do Fastify.
// O logger true faz o backend mostrar logs das requisições no terminal.
export const app = Fastify({
  logger: false,
});

// Registra o Swagger/OpenAPI.
// Ele gera a documentação automaticamente a partir dos schemas das rotas.
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

// Registra a interface visual da documentação.
// Ela ficará disponível em: http://localhost:3333/docs
await app.register(scalarApiReference, {
  routePrefix: "/docs",
  configuration: {
    title: "Mist API Reference",
  },
});

// Rota simples para testar se a API está funcionando.
app.get("/health", async () => {
  return {
    status: "ok",
    message: "Mist API está funcionando.",
  };
});

// Registra as rotas do módulo de clientes.
// Todas as rotas dentro de cliente.routes.ts terão o prefixo /clientes.
await app.register(clienteRoutes, {
  prefix: "/clientes",
});

// Depois, quando você criar os outros módulos, vai registrar aqui também:
//
// await app.register(estilistaRoutes, {
//   prefix: "/estilistas",
// });
//
// await app.register(agendamentoRoutes, {
//   prefix: "/agendamentos",
// });
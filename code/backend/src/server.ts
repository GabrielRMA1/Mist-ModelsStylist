import "dotenv/config";
import { app } from "./app.js";

const port = Number(process.env.PORT) || 3333;

try {
  await app.listen({
    port,
    host: "0.0.0.0",
  });

  console.log(`Servidor rodando em http://localhost:${port}`);
  console.log(`Documentação disponível em http://localhost:${port}/docs`);
} catch (error) {
  app.log.error(error);
  process.exit(1);
}

/*
import "dotenv/config";

import { app } from "./app.js";

import { rabbitMQConfig } from "./config/rabbitmq/index.js";
import { AgendamentoWorker } from "./workers/agendamentoWorker.js";

const port = Number(process.env.PORT) || 3333;

try {

  await rabbitMQConfig.connect();

  const agendamentoWorker = new AgendamentoWorker();
  await agendamentoWorker.iniciar();

  await app.listen({
    port,
    host: "0.0.0.0",
  });

  console.log(`Servidor rodando em http://localhost:${port}`);
  console.log(`Documentação disponível em http://localhost:${port}/docs`);
} catch (error) {
  app.log.error(error);
  process.exit(1);
}
*/
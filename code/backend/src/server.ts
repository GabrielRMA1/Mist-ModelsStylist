import "dotenv/config";
import { app } from "./app.js";

// Busca a porta no arquivo .env.
// Se não existir, usa 3333 como padrão.
const port = Number(process.env.PORT) || 3333;

try {
  // Inicia o servidor HTTP.
  // host: "0.0.0.0" permite acessar a API fora do localhost,
  // útil futuramente para testar com emulador ou app mobile.
  await app.listen({
    port,
    host: "0.0.0.0",
  });

  console.log(`Servidor rodando em http://localhost:${port}`);
  console.log(`Documentação disponível em http://localhost:${port}/docs`);
} catch (error) {
  // Se der erro ao iniciar, registra no log e encerra o processo.
  app.log.error(error);
  process.exit(1);
}
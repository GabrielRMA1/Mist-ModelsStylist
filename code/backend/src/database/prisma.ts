// Importa as variáveis do arquivo .env para process.env
import "dotenv/config";

// Adapter necessário no Prisma 7 para conectar com PostgreSQL
import { PrismaPg } from "@prisma/adapter-pg";

// PrismaClient gerado pelo Prisma.
// Ajuste esse caminho conforme o output do seu schema.prisma.
import { PrismaClient } from "../generated/prisma/client.js";

// Cria o adapter usando a DATABASE_URL do .env
const adapter = new PrismaPg({
  connectionString: process.env.DATABASE_URL!,
});

// Exporta uma única instância do PrismaClient.
// Isso evita criar várias conexões desnecessárias com o banco.
export const prisma = new PrismaClient({
  adapter,
});
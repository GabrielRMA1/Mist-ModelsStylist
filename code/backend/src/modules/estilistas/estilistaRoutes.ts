import type { FastifyInstance } from "fastify";
import { EstilistaController } from "./estilistaController.js";
import { authenticate } from "../../middlewares/auth.js";

export async function estilistaRoutes(app: FastifyInstance) {
  const estilistaController = new EstilistaController();

  app.post(
    "/",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Estilistas"],
        summary: "Criar estilista",
        description: "Cria um novo estilista no sistema.",
        body: {
          type: "object",
          required: ["nome", "email", "telefone", "especialidade"],
          properties: {
            nome: { type: "string" },
            email: { type: "string", format: "email" },
            telefone: { type: "string" },
            especialidade: { type: "string" },
            descricao: { type: "string" },
          },
        },
      },
    },
    estilistaController.criar
  );

  app.get(
    "/",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Estilistas"],
        summary: "Listar estilistas",
        description: "Retorna todos os estilistas cadastrados.",
      },
    },
    estilistaController.listarTodos
  );

  app.get(
    "/:id",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Estilistas"],
        summary: "Buscar estilista por ID",
        params: {
          type: "object",
          required: ["id"],
          properties: {
            id: { type: "string" },
          },
        },
      },
    },
    estilistaController.buscarPorId
  );

  app.put(
    "/:id",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Estilistas"],
        summary: "Atualizar estilista",
        params: {
          type: "object",
          required: ["id"],
          properties: {
            id: { type: "string" },
          },
        },
        body: {
          type: "object",
          properties: {
            nome: { type: "string" },
            email: { type: "string", format: "email" },
            telefone: { type: "string" },
            especialidade: { type: "string" },
            descricao: { type: "string" },
          },
        },
      },
    },
    estilistaController.atualizar
  );

  app.delete(
    "/:id",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Estilistas"],
        summary: "Deletar estilista",
        params: {
          type: "object",
          required: ["id"],
          properties: {
            id: { type: "string" },
          },
        },
      },
    },
    estilistaController.deletar
  );
}
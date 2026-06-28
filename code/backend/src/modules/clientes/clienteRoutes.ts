import type { FastifyInstance } from "fastify";
import { ClienteController } from "./clienteController.js";
import { authenticate } from "../../middlewares/auth.js";

export async function clienteRoutes(app: FastifyInstance) {
  const clienteController = new ClienteController();

  app.post(
    "/",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Clientes"],
        summary: "Criar cliente",
        description: "Cria um novo cliente no sistema.",
        body: {
          type: "object",
          required: ["nome", "userId"],
          properties: {
            nome: { type: "string" },
            telefone: { type: "string" },
            userId: { type: "number" },
          },
        },
        response: {
          201: {
            type: "object",
            properties: {
              id: { type: "number" },
              nome: { type: "string" },
              telefone: { type: "string" },
              userId: { type: "number" },
              createdAt: { type: "string" },
              updatedAt: { type: "string" },
            },
          },
        },
      },
    },
    clienteController.criar
  );

  app.get(
    "/",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Clientes"],
        summary: "Listar clientes",
        description: "Retorna todos os clientes cadastrados.",
      },
    },
    clienteController.listarTodos
  );

  app.get(
    "/:id",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Clientes"],
        summary: "Buscar cliente por ID",
        params: {
          type: "object",
          required: ["id"],
          properties: {
            id: { type: "string" },
          },
        },
      },
    },
    clienteController.buscarPorId
  );

  app.put(
    "/:id",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Clientes"],
        summary: "Atualizar cliente",
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
            telefone: { type: "string" },
          },
        },
      },
    },
    clienteController.atualizar
  );

  app.delete(
    "/:id",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Clientes"],
        summary: "Deletar cliente",
        params: {
          type: "object",
          required: ["id"],
          properties: {
            id: { type: "string" },
          },
        },
      },
    },
    clienteController.deletar
  );
}

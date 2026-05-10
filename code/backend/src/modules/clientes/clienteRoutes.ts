import type { FastifyInstance } from "fastify";
import { ClienteController } from "./clienteController.js";

export async function clienteRoutes(app: FastifyInstance) {
  const clienteController = new ClienteController();

  app.post(
    "/",
    {
      schema: {
        tags: ["Clientes"],
        summary: "Criar cliente",
        description: "Cria um novo cliente no sistema.",
        body: {
          type: "object",
          required: ["nome", "email", "telefone"],
          properties: {
            nome: { type: "string" },
            email: { type: "string", format: "email" },
            telefone: { type: "string" },
          },
        },
        response: {
          201: {
            type: "object",
            properties: {
              id: { type: "number" },
              nome: { type: "string" },
              email: { type: "string" },
              telefone: { type: "string" },
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
            email: { type: "string", format: "email" },
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
import type { FastifyInstance } from "fastify";
import { AgendamentoController } from "./agendamentoController.js";
import { authenticate } from "../../middlewares/auth.js";

export async function agendamentoRoutes(app: FastifyInstance) {
  const agendamentoController = new AgendamentoController();

  app.post(
    "/",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Agendamentos"],
        summary: "Criar agendamento",
        description: "Cria uma nova solicitação de agendamento.",
        body: {
          type: "object",
          required: ["clienteId", "estilistaId", "data", "tipoServico"],
          properties: {
            clienteId: { type: "number" },
            estilistaId: { type: "number" },
            data: {
              type: "string",
              description: "Data e horário no formato ISO.",
            },
            tipoServico: {
              type: "string",
              enum: [
                "CONSULTORIA_ESTILO",
                "MONTAGEM_LOOK",
                "ROUPA_SOB_MEDIDA",
                "ACOMPANHAMENTO_EVENTO",
                "OUTRO",
              ],
            },
            descricao: { type: "string" },
          },
        },
      },
    },
    agendamentoController.criar
  );

  app.get(
    "/",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Agendamentos"],
        summary: "Listar agendamentos",
        description: "Retorna todos os agendamentos cadastrados.",
      },
    },
    agendamentoController.listarTodos
  );

  app.get(
    "/:id",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Agendamentos"],
        summary: "Buscar agendamento por ID",
        params: {
          type: "object",
          required: ["id"],
          properties: {
            id: { type: "string" },
          },
        },
      },
    },
    agendamentoController.buscarPorId
  );

  app.get(
    "/cliente/:clienteId",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Agendamentos"],
        summary: "Listar agendamentos por cliente",
        params: {
          type: "object",
          required: ["clienteId"],
          properties: {
            clienteId: { type: "string" },
          },
        },
      },
    },
    agendamentoController.listarPorCliente
  );

  app.get(
    "/estilista/:estilistaId",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Agendamentos"],
        summary: "Listar agendamentos por estilista",
        params: {
          type: "object",
          required: ["estilistaId"],
          properties: {
            estilistaId: { type: "string" },
          },
        },
      },
    },
    agendamentoController.listarPorEstilista
  );

  app.patch(
    "/:id/status",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Agendamentos"],
        summary: "Atualizar status do agendamento",
        params: {
          type: "object",
          required: ["id"],
          properties: {
            id: { type: "string" },
          },
        },
        body: {
          type: "object",
          required: ["status"],
          properties: {
            status: {
              type: "string",
              enum: [
                "PENDENTE",
                "ACEITO",
                "RECUSADO",
                "CANCELADO",
                "CONCLUIDO",
              ],
            },
          },
        },
      },
    },
    agendamentoController.atualizarStatus
  );

  app.delete(
    "/:id",
    {
      preHandler: [authenticate],
      schema: {
        tags: ["Agendamentos"],
        summary: "Deletar agendamento",
        params: {
          type: "object",
          required: ["id"],
          properties: {
            id: { type: "string" },
          },
        },
      },
    },
    agendamentoController.deletar
  );
}
import type { FastifyInstance } from "fastify";
import { AgendamentoController } from "./agendamentoController.js";

export async function agendamentoRoutes(app: FastifyInstance) {
  const agendamentoController = new AgendamentoController();

  app.post(
    "/",
    {
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
              example: "2026-05-20T14:00:00.000Z",
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
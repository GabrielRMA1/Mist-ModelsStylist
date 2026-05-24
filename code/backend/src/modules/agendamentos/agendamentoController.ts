import type { FastifyReply, FastifyRequest } from "fastify";
import { AgendamentoService } from "./agendamentoService.js";
import {
  StatusAgendamento,
  TipoServico,
} from "../../generated/prisma/client.js";

interface CriarAgendamentoBody {
  clienteId: number;
  estilistaId: number;
  data: string;
  tipoServico: TipoServico;
  descricao?: string;
}

interface AtualizarStatusBody {
  status: StatusAgendamento;
}

interface AgendamentoParams {
  id: string;
}

interface ClienteParams {
  clienteId: string;
}

interface EstilistaParams {
  estilistaId: string;
}

export class AgendamentoController {
  private agendamentoService: AgendamentoService;

  constructor() {
    this.agendamentoService = new AgendamentoService();
  }

  criar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const body = request.body as CriarAgendamentoBody;
      const agendamento = await this.agendamentoService.criar(body);

      return reply.status(201).send(agendamento);
    } catch (error) {
      return reply.status(400).send({
        message:
          error instanceof Error ? error.message : "Erro ao criar agendamento.",
      });
    }
  };

  listarTodos = async (_request: FastifyRequest, reply: FastifyReply) => {
    const agendamentos = await this.agendamentoService.listarTodos();

    return reply.status(200).send(agendamentos);
  };

  buscarPorId = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as { id: number };

      if (Number.isNaN(id)) {
        return reply.status(400).send({
          message: "ID inválido.",
        });
      }

      const agendamento = await this.agendamentoService.buscarPorId(id);

      return reply.status(200).send(agendamento);
    } catch (error) {
      return reply.status(404).send({
        message:
          error instanceof Error
            ? error.message
            : "Erro ao buscar agendamento.",
      });
    }
  };

  listarPorCliente = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { clienteId } = request.params as { clienteId: number };

      if (Number.isNaN(clienteId)) {
        return reply.status(400).send({
          message: "ID do cliente inválido.",
        });
      }

      const agendamentos =
        await this.agendamentoService.listarPorCliente(clienteId);

      return reply.status(200).send(agendamentos);
    } catch (error) {
      return reply.status(404).send({
        message:
          error instanceof Error
            ? error.message
            : "Erro ao listar agendamentos do cliente.",
      });
    }
  };

  listarPorEstilista = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { estilistaId } = request.params as { estilistaId: number };

      if (Number.isNaN(estilistaId)) {
        return reply.status(400).send({
          message: "ID do estilista inválido.",
        });
      }

      const agendamentos =
        await this.agendamentoService.listarPorEstilista(estilistaId);

      return reply.status(200).send(agendamentos);
    } catch (error) {
      return reply.status(404).send({
        message:
          error instanceof Error
            ? error.message
            : "Erro ao listar agendamentos do estilista.",
      });
    }
  };

  atualizarStatus = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as { id: string };
      const body = request.body as AtualizarStatusBody;

      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({
          message: "ID inválido.",
        });
      }

      const agendamento = await this.agendamentoService.atualizarStatus(
        idNum,
        body,
      );

      return reply.status(200).send(agendamento);
    } catch (error) {
      return reply.status(400).send({
        message:
          error instanceof Error
            ? error.message
            : "Erro ao atualizar status do agendamento.",
      });
    }
  };

  deletar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as { id: number };

      if (Number.isNaN(id)) {
        return reply.status(400).send({
          message: "ID inválido.",
        });
      }

      await this.agendamentoService.deletar(id);

      return reply.status(204).send();
    } catch (error) {
      return reply.status(404).send({
        message:
          error instanceof Error
            ? error.message
            : "Erro ao deletar agendamento.",
      });
    }
  };
}

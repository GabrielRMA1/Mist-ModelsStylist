import type { FastifyReply, FastifyRequest } from "fastify";
import { AgendamentoService } from "./agendamentoService.js";
import { StatusAgendamento, TipoServico } from "../../generated/prisma/client.js";

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

  criar = async (
    request: FastifyRequest<{ Body: CriarAgendamentoBody }>,
    reply: FastifyReply
  ) => {
    try {
      const agendamento = await this.agendamentoService.criar(request.body);

      return reply.status(201).send(agendamento);
    } catch (error) {
      return reply.status(400).send({
        message:
          error instanceof Error
            ? error.message
            : "Erro ao criar agendamento.",
      });
    }
  };

  listarTodos = async (_request: FastifyRequest, reply: FastifyReply) => {
    const agendamentos = await this.agendamentoService.listarTodos();

    return reply.status(200).send(agendamentos);
  };

  buscarPorId = async (
    request: FastifyRequest<{ Params: AgendamentoParams }>,
    reply: FastifyReply
  ) => {
    try {
      const id = Number(request.params.id);

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

  listarPorCliente = async (
    request: FastifyRequest<{ Params: ClienteParams }>,
    reply: FastifyReply
  ) => {
    try {
      const clienteId = Number(request.params.clienteId);

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

  listarPorEstilista = async (
    request: FastifyRequest<{ Params: EstilistaParams }>,
    reply: FastifyReply
  ) => {
    try {
      const estilistaId = Number(request.params.estilistaId);

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

  atualizarStatus = async (
    request: FastifyRequest<{
      Params: AgendamentoParams;
      Body: AtualizarStatusBody;
    }>,
    reply: FastifyReply
  ) => {
    try {
      const id = Number(request.params.id);

      if (Number.isNaN(id)) {
        return reply.status(400).send({
          message: "ID inválido.",
        });
      }

      const agendamento = await this.agendamentoService.atualizarStatus(
        id,
        request.body
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

  deletar = async (
    request: FastifyRequest<{ Params: AgendamentoParams }>,
    reply: FastifyReply
  ) => {
    try {
      const id = Number(request.params.id);

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
import type { FastifyReply, FastifyRequest } from "fastify";
import { AgendamentoService } from "./agendamentoService.js";
import { AgendamentoMessagingService } from "../../services/messaging/agendamentoMessagingService.js";
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
  private messagingService: AgendamentoMessagingService | null;

  constructor() {
    this.agendamentoService = new AgendamentoService();
    try {
      this.messagingService = new AgendamentoMessagingService();
    } catch {
      this.messagingService = null;
    }
  }

  criar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const body = request.body as CriarAgendamentoBody;
      const agendamento = await this.agendamentoService.criar(body);

      if (this.messagingService) {
        setImmediate(() => {
          this.messagingService
            ?.publicarAgendamentoPrioritario({
              agendamentoId: agendamento.id,
              clienteId: agendamento.clienteId,
              estilistaId: agendamento.estilistaId,
              data: new Date(agendamento.data),
              tipoServico: agendamento.tipoServico,
              prioridade: 1,
              createdAt: agendamento.createdAt,
            })
            .then(() => {
              request.log.info(`Agendamento ${agendamento.id} enviado para fila de prioridade`);
            })
            .catch((messagingError) => {
              request.log.error(
                `Erro ao publicar agendamento ${agendamento.id} na fila de prioridade: ${messagingError instanceof Error ? messagingError.message : 'Erro desconhecido'}`
              );
            });
        });
      }

      return reply.status(201).send(agendamento);
    } catch (error) {
      return reply.status(400).send({
        message: error instanceof Error ? error.message : "Erro ao criar agendamento.",
      });
    }
  };

  listarTodos = async (_request: FastifyRequest, reply: FastifyReply) => {
    const agendamentos = await this.agendamentoService.listarTodos();
    return reply.status(200).send(agendamentos);
  };

  buscarPorId = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as AgendamentoParams;
      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({ message: "ID inválido." });
      }

      const agendamento = await this.agendamentoService.buscarPorId(idNum);
      return reply.status(200).send(agendamento);
    } catch (error) {
      return reply.status(404).send({
        message: error instanceof Error ? error.message : "Erro ao buscar agendamento.",
      });
    }
  };

  listarPorCliente = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { clienteId } = request.params as ClienteParams;
      const clienteIdNum = Number(clienteId);

      if (Number.isNaN(clienteIdNum)) {
        return reply.status(400).send({ message: "ID do cliente inválido." });
      }

      const agendamentos = await this.agendamentoService.listarPorCliente(clienteIdNum);
      return reply.status(200).send(agendamentos);
    } catch (error) {
      return reply.status(404).send({
        message: error instanceof Error ? error.message : "Erro ao listar agendamentos do cliente.",
      });
    }
  };

  listarPorEstilista = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { estilistaId } = request.params as EstilistaParams;
      const estilistaIdNum = Number(estilistaId);

      if (Number.isNaN(estilistaIdNum)) {
        return reply.status(400).send({ message: "ID do estilista inválido." });
      }

      const agendamentos = await this.agendamentoService.listarPorEstilista(estilistaIdNum);
      return reply.status(200).send(agendamentos);
    } catch (error) {
      return reply.status(404).send({
        message: error instanceof Error ? error.message : "Erro ao listar agendamentos do estilista.",
      });
    }
  };

  atualizarStatus = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as AgendamentoParams;
      const body = request.body as AtualizarStatusBody;
      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({ message: "ID inválido." });
      }

      const agendamento = await this.agendamentoService.atualizarStatus(idNum, body);

      if (this.messagingService) {
        setImmediate(() => {
          this.messagingService
            ?.publicarAtualizacaoStatus({
              agendamentoId: idNum,
              status: body.status,
              timestamp: new Date(),
            })
            .then(() => {
              request.log.info(`Status do agendamento ${idNum} atualizado para: ${body.status}`);
            })
            .catch((messagingError) => {
              const errorMessage = messagingError instanceof Error
                ? messagingError.message
                : 'Erro desconhecido';

              request.log.error(`Erro ao publicar status do agendamento ${idNum}: ${errorMessage}`);
            });
        });
      }

      return reply.status(200).send(agendamento);
    } catch (error) {
      return reply.status(400).send({
        message: error instanceof Error ? error.message : "Erro ao atualizar status do agendamento.",
      });
    }
  };

  deletar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as AgendamentoParams;
      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({ message: "ID inválido." });
      }

      await this.agendamentoService.deletar(idNum);
      return reply.status(204).send();
    } catch (error) {
      return reply.status(404).send({
        message: error instanceof Error ? error.message : "Erro ao deletar agendamento.",
      });
    }
  };
}

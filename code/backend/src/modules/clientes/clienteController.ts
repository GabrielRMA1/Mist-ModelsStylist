import type { FastifyReply, FastifyRequest } from "fastify";
import { ClienteService } from "./clienteService.js";

interface CriarClienteBody {
  nome: string;
  email: string;
  telefone: string;
}
interface AtualizarClienteBody {
  nome?: string;
  email?: string;
  telefone?: string;
}
interface ClienteParams {
  id: string;
}
export class ClienteController {
  private clienteService: ClienteService;

  constructor() {
    this.clienteService = new ClienteService();
  }

  criar = async (
    request: FastifyRequest<{ Body: CriarClienteBody }>,
    reply: FastifyReply
  ) => {
    try {
      const cliente = await this.clienteService.criar(request.body);

      return reply.status(201).send(cliente);
    } catch (error) {
      return reply.status(400).send({
        message: error instanceof Error ? error.message : "Erro ao criar cliente.",
      });
    }
  };

  listarTodos = async (_request: FastifyRequest, reply: FastifyReply) => {
    const clientes = await this.clienteService.listarTodos();

    return reply.status(200).send(clientes);
  };

  buscarPorId = async (
    request: FastifyRequest<{ Params: ClienteParams }>,
    reply: FastifyReply
  ) => {
    try {
      const id = Number(request.params.id);

      if (Number.isNaN(id)) {
        return reply.status(400).send({
          message: "ID inválido.",
        });
      }

      const cliente = await this.clienteService.buscarPorId(id);

      return reply.status(200).send(cliente);
    } catch (error) {
      return reply.status(404).send({
        message: error instanceof Error ? error.message : "Erro ao buscar cliente.",
      });
    }
  };

  atualizar = async (
    request: FastifyRequest<{
      Params: ClienteParams;
      Body: AtualizarClienteBody;
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

      const cliente = await this.clienteService.atualizar(id, request.body);

      return reply.status(200).send(cliente);
    } catch (error) {
      return reply.status(400).send({
        message:
          error instanceof Error ? error.message : "Erro ao atualizar cliente.",
      });
    }
  };

  deletar = async (
    request: FastifyRequest<{ Params: ClienteParams }>,
    reply: FastifyReply
  ) => {
    try {
      const id = Number(request.params.id);

      if (Number.isNaN(id)) {
        return reply.status(400).send({
          message: "ID inválido.",
        });
      }

      await this.clienteService.deletar(id);

      return reply.status(204).send();
    } catch (error) {
      return reply.status(404).send({
        message: error instanceof Error ? error.message : "Erro ao deletar cliente.",
      });
    }
  };
}
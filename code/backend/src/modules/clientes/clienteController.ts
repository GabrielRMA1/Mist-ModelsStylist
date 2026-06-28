import type { FastifyReply, FastifyRequest } from "fastify";

import { ClienteService } from "./clienteService.js";

interface CriarClienteBody {
  nome: string;
  telefone?: string;
  userId: number;
}

interface AtualizarClienteBody {
  nome?: string;
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

  criar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const body = request.body as CriarClienteBody;
      const cliente = await this.clienteService.criar(body);

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

  buscarPorId = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as ClienteParams;
      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({ message: "ID invalido." });
      }

      const cliente = await this.clienteService.buscarPorId(idNum);
      return reply.status(200).send(cliente);
    } catch (error) {
      return reply.status(404).send({
        message: error instanceof Error ? error.message : "Erro ao buscar cliente.",
      });
    }
  };

  atualizar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as ClienteParams;
      const body = request.body as AtualizarClienteBody;
      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({ message: "ID invalido." });
      }

      const cliente = await this.clienteService.atualizar(idNum, body);
      return reply.status(200).send(cliente);
    } catch (error) {
      return reply.status(400).send({
        message: error instanceof Error ? error.message : "Erro ao atualizar cliente.",
      });
    }
  };

  deletar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as ClienteParams;
      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({ message: "ID invalido." });
      }

      await this.clienteService.deletar(idNum);
      return reply.status(204).send();
    } catch (error) {
      return reply.status(404).send({
        message: error instanceof Error ? error.message : "Erro ao deletar cliente.",
      });
    }
  };
}

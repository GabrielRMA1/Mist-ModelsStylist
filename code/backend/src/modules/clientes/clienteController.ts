import type { FastifyReply, FastifyRequest } from "fastify";
import { ClienteService } from "./clienteService.js";

// Tipagem do body da rota POST /clientes
interface CriarClienteBody {
  nome: string;
  email: string;
  telefone: string;
}

// Tipagem do body da rota PUT /clientes/:id
interface AtualizarClienteBody {
  nome?: string;
  email?: string;
  telefone?: string;
}

// Tipagem dos params das rotas com :id
interface ClienteParams {
  id: string;
}

// Controller lida com request e reply.
// Ele não acessa banco diretamente.
export class ClienteController {
  private clienteService: ClienteService;

  constructor() {
    this.clienteService = new ClienteService();
  }

  // POST /clientes
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

  // GET /clientes
  listarTodos = async (_request: FastifyRequest, reply: FastifyReply) => {
    const clientes = await this.clienteService.listarTodos();

    return reply.status(200).send(clientes);
  };

  // GET /clientes/:id
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

  // PUT /clientes/:id
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

  // DELETE /clientes/:id
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
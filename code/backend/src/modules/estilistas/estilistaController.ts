import type { FastifyReply, FastifyRequest } from "fastify";
import { EstilistaService } from "./estilistaService.js";

interface CriarEstilistaBody {
  nome: string;
  email: string;
  telefone: string;
  especialidade: string;
  descricao?: string;
}

interface AtualizarEstilistaBody {
  nome?: string;
  email?: string;
  telefone?: string;
  especialidade?: string;
  descricao?: string;
}

interface EstilistaParams {
  id: string;
}

export class EstilistaController {
  private estilistaService: EstilistaService;

  constructor() {
    this.estilistaService = new EstilistaService();
  }

  criar = async (
    request: FastifyRequest<{ Body: CriarEstilistaBody }>,
    reply: FastifyReply
  ) => {
    try {
      const estilista = await this.estilistaService.criar(request.body);

      return reply.status(201).send(estilista);
    } catch (error) {
      return reply.status(400).send({
        message:
          error instanceof Error ? error.message : "Erro ao criar estilista.",
      });
    }
  };

  listarTodos = async (_request: FastifyRequest, reply: FastifyReply) => {
    const estilistas = await this.estilistaService.listarTodos();

    return reply.status(200).send(estilistas);
  };

  buscarPorId = async (
    request: FastifyRequest<{ Params: EstilistaParams }>,
    reply: FastifyReply
  ) => {
    try {
      const id = Number(request.params.id);

      if (Number.isNaN(id)) {
        return reply.status(400).send({
          message: "ID inválido.",
        });
      }

      const estilista = await this.estilistaService.buscarPorId(id);

      return reply.status(200).send(estilista);
    } catch (error) {
      return reply.status(404).send({
        message:
          error instanceof Error ? error.message : "Erro ao buscar estilista.",
      });
    }
  };

  atualizar = async (
    request: FastifyRequest<{
      Params: EstilistaParams;
      Body: AtualizarEstilistaBody;
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

      const estilista = await this.estilistaService.atualizar(
        id,
        request.body
      );

      return reply.status(200).send(estilista);
    } catch (error) {
      return reply.status(400).send({
        message:
          error instanceof Error
            ? error.message
            : "Erro ao atualizar estilista.",
      });
    }
  };

  deletar = async (
    request: FastifyRequest<{ Params: EstilistaParams }>,
    reply: FastifyReply
  ) => {
    try {
      const id = Number(request.params.id);

      if (Number.isNaN(id)) {
        return reply.status(400).send({
          message: "ID inválido.",
        });
      }

      await this.estilistaService.deletar(id);

      return reply.status(204).send();
    } catch (error) {
      return reply.status(404).send({
        message:
          error instanceof Error ? error.message : "Erro ao deletar estilista.",
      });
    }
  };
}
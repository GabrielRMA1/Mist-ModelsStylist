import type { FastifyReply, FastifyRequest } from "fastify";

import { EstilistaService } from "./estilistaService.js";

interface CriarEstilistaBody {
  nome: string;
  telefone?: string;
  especialidade: string;
  descricao?: string;
  userId: number;
}

interface AtualizarEstilistaBody {
  nome?: string;
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

  criar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const body = request.body as CriarEstilistaBody;
      const estilista = await this.estilistaService.criar(body);

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

  buscarPorId = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as EstilistaParams;
      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({ message: "ID invalido." });
      }

      const estilista = await this.estilistaService.buscarPorId(idNum);
      return reply.status(200).send(estilista);
    } catch (error) {
      return reply.status(404).send({
        message:
          error instanceof Error ? error.message : "Erro ao buscar estilista.",
      });
    }
  };

  atualizar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as EstilistaParams;
      const body = request.body as AtualizarEstilistaBody;
      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({ message: "ID invalido." });
      }

      const estilista = await this.estilistaService.atualizar(idNum, body);
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

  deletar = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const { id } = request.params as EstilistaParams;
      const idNum = Number(id);

      if (Number.isNaN(idNum)) {
        return reply.status(400).send({ message: "ID invalido." });
      }

      await this.estilistaService.deletar(idNum);
      return reply.status(204).send();
    } catch (error) {
      return reply.status(404).send({
        message:
          error instanceof Error ? error.message : "Erro ao deletar estilista.",
      });
    }
  };
}

import { prisma } from "../../database/prisma.js";

interface CriarEstilistaData {
  nome: string;
  email: string;
  telefone: string;
  especialidade: string;
  descricao?: string;
}

interface AtualizarEstilistaData {
  nome?: string;
  email?: string;
  telefone?: string;
  especialidade?: string;
  descricao?: string;
}

export class EstilistaRepository {
  async criar(data: CriarEstilistaData) {
    return prisma.estilista.create({
      data,
    });
  }

  async listarTodos() {
    return prisma.estilista.findMany({
      orderBy: {
        id: "asc",
      },
    });
  }

  async buscarPorId(id: number) {
    return prisma.estilista.findUnique({
      where: {
        id,
      },
    });
  }

  async buscarPorEmail(email: string) {
    return prisma.estilista.findUnique({
      where: {
        email,
      },
    });
  }

  async atualizar(id: number, data: AtualizarEstilistaData) {
    return prisma.estilista.update({
      where: {
        id,
      },
      data,
    });
  }

  async deletar(id: number) {
    return prisma.estilista.delete({
      where: {
        id,
      },
    });
  }
}
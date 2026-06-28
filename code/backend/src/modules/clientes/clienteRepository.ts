import { prisma } from "../../database/prisma.js";

interface CriarClienteData {
  nome: string;
  telefone?: string;
  userId: number;
}

interface AtualizarClienteData {
  nome?: string;
  telefone?: string;
}

export class ClienteRepository {
  async criar(data: CriarClienteData) {
    return prisma.cliente.create({
      data,
    });
  }

  async listarTodos() {
    return prisma.cliente.findMany({
      orderBy: {
        id: "asc",
      },
    });
  }

  async buscarPorId(id: number) {
    return prisma.cliente.findUnique({
      where: {
        id,
      },
    });
  }

  async atualizar(id: number, data: AtualizarClienteData) {
    return prisma.cliente.update({
      where: {
        id,
      },
      data,
    });
  }

  async deletar(id: number) {
    return prisma.cliente.delete({
      where: {
        id,
      },
    });
  }
}

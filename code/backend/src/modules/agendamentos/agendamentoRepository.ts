import { prisma } from "../../database/prisma.js";
import { StatusAgendamento, TipoServico } from "../../generated/prisma/client.js";

interface CriarAgendamentoData {
  clienteId: number;
  estilistaId: number;
  data: Date;
  tipoServico: TipoServico;
  descricao?: string;
}

interface AtualizarStatusData {
  status: StatusAgendamento;
}

export class AgendamentoRepository {
  async criar(data: CriarAgendamentoData) {
    return prisma.agendamento.create({
      data: {
        clienteId: data.clienteId,
        estilistaId: data.estilistaId,
        data: data.data,
        tipoServico: data.tipoServico,
        descricao: data.descricao ?? null,
        status: "PENDENTE",
      },
      include: {
        cliente: true,
        estilista: true,
      },
    });
  }

  async listarTodos() {
    return prisma.agendamento.findMany({
      orderBy: {
        id: "asc",
      },
      include: {
        cliente: true,
        estilista: true,
      },
    });
  }

  async buscarPorId(id: number) {
    return prisma.agendamento.findUnique({
      where: {
        id,
      },
      include: {
        cliente: true,
        estilista: true,
      },
    });
  }

  async listarPorCliente(clienteId: number) {
    return prisma.agendamento.findMany({
      where: {
        clienteId,
      },
      orderBy: {
        id: "asc",
      },
      include: {
        cliente: true,
        estilista: true,
      },
    });
  }

  async listarPorEstilista(estilistaId: number) {
    return prisma.agendamento.findMany({
      where: {
        estilistaId,
      },
      orderBy: {
        id: "asc",
      },
      include: {
        cliente: true,
        estilista: true,
      },
    });
  }

  async atualizarStatus(id: number, data: AtualizarStatusData) {
    return prisma.agendamento.update({
      where: {
        id,
      },
      data: {
        status: data.status,
      },
      include: {
        cliente: true,
        estilista: true,
      },
    });
  }

  async deletar(id: number) {
    return prisma.agendamento.delete({
      where: {
        id,
      },
    });
  }
}
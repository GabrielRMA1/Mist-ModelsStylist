// Importa a instância do Prisma configurada no projeto
import { prisma } from "../../database/prisma.js";

// Tipo usado para criar um cliente.
// Aqui ficam só os dados que vêm do cadastro.
interface CriarClienteData {
  nome: string;
  email: string;
  telefone: string;
}

// Tipo usado para atualizar um cliente.
// O Partial significa que os campos são opcionais.
interface AtualizarClienteData {
  nome?: string;
  email?: string;
  telefone?: string;
}

// Repository é a camada responsável por acessar o banco de dados.
export class ClienteRepository {
  // Cria um novo cliente no banco.
  async criar(data: CriarClienteData) {
    return prisma.cliente.create({
      data,
    });
  }

  // Lista todos os clientes cadastrados.
  async listarTodos() {
    return prisma.cliente.findMany({
      orderBy: {
        id: "asc",
      },
    });
  }

  // Busca um cliente pelo ID.
  async buscarPorId(id: number) {
    return prisma.cliente.findUnique({
      where: {
        id,
      },
    });
  }

  // Busca um cliente pelo e-mail.
  // Isso é útil para validar se já existe cadastro com o mesmo e-mail.
  async buscarPorEmail(email: string) {
    return prisma.cliente.findUnique({
      where: {
        email,
      },
    });
  }

  // Atualiza os dados de um cliente.
  async atualizar(id: number, data: AtualizarClienteData) {
    return prisma.cliente.update({
      where: {
        id,
      },
      data,
    });
  }

  // Remove um cliente do banco.
  async deletar(id: number) {
    return prisma.cliente.delete({
      where: {
        id,
      },
    });
  }
}
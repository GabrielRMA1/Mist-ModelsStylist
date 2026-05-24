import { prisma } from '../../database/prisma.js'

export class AuthRepository {
  async findUserByEmail(email: string) {
    return prisma.user.findUnique({
      where: {
        email,
      },
    })
  }

  async createUser(data: {
    email: string
    senha: string
    role: 'CLIENTE' | 'ESTILISTA'
  }) {
    return prisma.user.create({
      data,
    })
  }

  async createCliente(data: {
    nome: string
    telefone?: string
    userId: number
  }) {
    return prisma.cliente.create({
      data,
    })
  }

  async createEstilista(data: {
    nome: string
    telefone?: string
    especialidade: string
    descricao?: string
    userId: number
  }) {
    return prisma.estilista.create({
      data,
    })
  }
}
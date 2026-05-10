import { ClienteRepository } from "./clienteRepository.js";

// Dados necessários para criar um cliente.
interface CriarClienteInput {
  nome: string;
  email: string;
  telefone: string;
}

// Dados permitidos para atualizar um cliente.
interface AtualizarClienteInput {
  nome?: string;
  email?: string;
  telefone?: string;
}

// Service é a camada de regra de negócio.
// Ele valida dados e decide quando chamar o repository.
export class ClienteService {
  private clienteRepository: ClienteRepository;

  constructor() {
    this.clienteRepository = new ClienteRepository();
  }

  // Cria um cliente depois de validar regras básicas.
  async criar(data: CriarClienteInput) {
    const clienteComMesmoEmail =
      await this.clienteRepository.buscarPorEmail(data.email);

    if (clienteComMesmoEmail) {
      throw new Error("Já existe um cliente cadastrado com este e-mail.");
    }

    return this.clienteRepository.criar(data);
  }

  // Lista todos os clientes.
  async listarTodos() {
    return this.clienteRepository.listarTodos();
  }

  // Busca cliente por ID e valida se ele existe.
  async buscarPorId(id: number) {
    const cliente = await this.clienteRepository.buscarPorId(id);

    if (!cliente) {
      throw new Error("Cliente não encontrado.");
    }

    return cliente;
  }

  // Atualiza cliente depois de verificar se ele existe.
  async atualizar(id: number, data: AtualizarClienteInput) {
    await this.buscarPorId(id);

    if (data.email) {
      const clienteComMesmoEmail =
        await this.clienteRepository.buscarPorEmail(data.email);

      if (clienteComMesmoEmail && clienteComMesmoEmail.id !== id) {
        throw new Error("Já existe outro cliente cadastrado com este e-mail.");
      }
    }

    return this.clienteRepository.atualizar(id, data);
  }

  // Deleta cliente depois de verificar se ele existe.
  async deletar(id: number) {
    await this.buscarPorId(id);

    return this.clienteRepository.deletar(id);
  }
}
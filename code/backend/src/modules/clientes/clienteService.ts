import { ClienteRepository } from "./clienteRepository.js";

interface CriarClienteInput {
  nome: string;
  email: string;
  telefone: string;
}

interface AtualizarClienteInput {
  nome?: string;
  email?: string;
  telefone?: string;
}
export class ClienteService {
  private clienteRepository: ClienteRepository;

  constructor() {
    this.clienteRepository = new ClienteRepository();
  }

  async criar(data: CriarClienteInput) {
    const clienteComMesmoEmail =
      await this.clienteRepository.buscarPorEmail(data.email);

    if (clienteComMesmoEmail) {
      throw new Error("Já existe um cliente cadastrado com este e-mail.");
    }

    return this.clienteRepository.criar(data);
  }

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

  async deletar(id: number) {
    await this.buscarPorId(id);

    return this.clienteRepository.deletar(id);
  }
}
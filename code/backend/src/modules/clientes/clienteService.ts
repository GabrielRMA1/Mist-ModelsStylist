import { ClienteRepository } from "./clienteRepository.js";

interface CriarClienteInput {
  nome: string;
  telefone?: string;
  userId: number;
}

interface AtualizarClienteInput {
  nome?: string;
  telefone?: string;
}

export class ClienteService {
  private clienteRepository: ClienteRepository;

  constructor() {
    this.clienteRepository = new ClienteRepository();
  }

  async criar(data: CriarClienteInput) {
    return this.clienteRepository.criar(data);
  }

  async listarTodos() {
    return this.clienteRepository.listarTodos();
  }

  async buscarPorId(id: number) {
    const cliente = await this.clienteRepository.buscarPorId(id);

    if (!cliente) {
      throw new Error("Cliente nao encontrado.");
    }

    return cliente;
  }

  async atualizar(id: number, data: AtualizarClienteInput) {
    await this.buscarPorId(id);
    return this.clienteRepository.atualizar(id, data);
  }

  async deletar(id: number) {
    await this.buscarPorId(id);
    return this.clienteRepository.deletar(id);
  }
}

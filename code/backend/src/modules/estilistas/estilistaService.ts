import { EstilistaRepository } from "./estilistaRepository.js";

interface CriarEstilistaInput {
  nome: string;
  telefone?: string;
  especialidade: string;
  descricao?: string;
  userId: number;
}

interface AtualizarEstilistaInput {
  nome?: string;
  telefone?: string;
  especialidade?: string;
  descricao?: string;
}

export class EstilistaService {
  private estilistaRepository: EstilistaRepository;

  constructor() {
    this.estilistaRepository = new EstilistaRepository();
  }

  async criar(data: CriarEstilistaInput) {
    return this.estilistaRepository.criar(data);
  }

  async listarTodos() {
    return this.estilistaRepository.listarTodos();
  }

  async buscarPorId(id: number) {
    const estilista = await this.estilistaRepository.buscarPorId(id);

    if (!estilista) {
      throw new Error("Estilista nao encontrado.");
    }

    return estilista;
  }

  async atualizar(id: number, data: AtualizarEstilistaInput) {
    await this.buscarPorId(id);
    return this.estilistaRepository.atualizar(id, data);
  }

  async deletar(id: number) {
    await this.buscarPorId(id);
    return this.estilistaRepository.deletar(id);
  }
}

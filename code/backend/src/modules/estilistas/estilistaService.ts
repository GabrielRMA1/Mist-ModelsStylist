import { EstilistaRepository } from "./estilistaRepository.js";

interface CriarEstilistaInput {
  nome: string;
  email: string;
  telefone: string;
  especialidade: string;
  descricao?: string;
}

interface AtualizarEstilistaInput {
  nome?: string;
  email?: string;
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
    const estilistaComMesmoEmail =
      await this.estilistaRepository.buscarPorEmail(data.email);

    if (estilistaComMesmoEmail) {
      throw new Error("Já existe um estilista cadastrado com este e-mail.");
    }

    return this.estilistaRepository.criar(data);
  }

  async listarTodos() {
    return this.estilistaRepository.listarTodos();
  }

  async buscarPorId(id: number) {
    const estilista = await this.estilistaRepository.buscarPorId(id);

    if (!estilista) {
      throw new Error("Estilista não encontrado.");
    }

    return estilista;
  }

  async atualizar(id: number, data: AtualizarEstilistaInput) {
    await this.buscarPorId(id);

    if (data.email) {
      const estilistaComMesmoEmail =
        await this.estilistaRepository.buscarPorEmail(data.email);

      if (estilistaComMesmoEmail && estilistaComMesmoEmail.id !== id) {
        throw new Error("Já existe outro estilista cadastrado com este e-mail.");
      }
    }

    return this.estilistaRepository.atualizar(id, data);
  }

  async deletar(id: number) {
    await this.buscarPorId(id);

    return this.estilistaRepository.deletar(id);
  }
}
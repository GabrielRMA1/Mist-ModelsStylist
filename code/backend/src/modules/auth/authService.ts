import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

import type { FastifyReply } from "fastify";

import { env } from "../../env.js";
import { AuthRepository } from "./authRepository.js";

const authRepository = new AuthRepository();

export class AuthService {
  async signup(
    data: {
      nome: string;
      email: string;
      senha: string;
      telefone?: string;

      role: "CLIENTE" | "ESTILISTA";

      especialidade?: string;
      descricao?: string;
    },
    reply: FastifyReply,
  ) {
    const existingUser = await authRepository.findUserByEmail(data.email);

    if (existingUser) {
      throw new Error("Email já cadastrado");
    }

    const senhaHash = await bcrypt.hash(data.senha, 10);

    const user = await authRepository.createUser({
      email: data.email,
      senha: senhaHash,
      role: data.role,
    });

    let clienteOuEstilista: any = null;

    if (data.role === "CLIENTE") {
      clienteOuEstilista = await authRepository.createCliente({
        nome: data.nome,
        ...(data.telefone && {
          telefone: data.telefone,
        }),
        userId: user.id,
      });
    }

    if (data.role === "ESTILISTA") {
      clienteOuEstilista = await authRepository.createEstilista({
        nome: data.nome,

        ...(data.telefone && {
          telefone: data.telefone,
        }),

        especialidade: data.especialidade ?? "",

        ...(data.descricao && {
          descricao: data.descricao,
        }),

        userId: user.id,
      });
    }

    const token = jwt.sign(
      {
        userId: user.id,
        role: user.role,
      },
      env.JWT_SECRET,
      {
        expiresIn: "7d",
      },
    );

    reply.setCookie("token", token, {
      httpOnly: true,
      sameSite: "lax",
      secure: false,
      path: "/",
    });

    return {
      message: "Usuário criado com sucesso",
      token,
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
      },
      profile: clienteOuEstilista,
    };
  }

  async login(
    data: {
      email: string;
      senha: string;
    },
    reply: FastifyReply,
  ) {
    const user = await authRepository.findUserByEmail(data.email);

    if (!user) {
      throw new Error("Email ou senha inválidos");
    }

    const senhaCorreta = await bcrypt.compare(data.senha, user.senha);

    if (!senhaCorreta) {
      throw new Error("Email ou senha inválidos");
    }

    const token = jwt.sign(
      {
        userId: user.id,
        role: user.role,
      },
      env.JWT_SECRET,
      {
        expiresIn: "7d",
      },
    );

    reply.setCookie("token", token, {
      httpOnly: true,
      sameSite: "lax",
      secure: false,
      path: "/",
    });

    // Buscar dados do cliente ou estilista
    let profile = null;
    if (user.role === "CLIENTE") {
      profile = await authRepository.findClienteByUserId(user.id);
    } else if (user.role === "ESTILISTA") {
      profile = await authRepository.findEstilistaByUserId(user.id);
    }

    return {
      message: "Login realizado com sucesso",
      token,
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
      },
      profile,
    };
  }

  async logout(reply: FastifyReply) {
    reply.clearCookie("token");

    return {
      message: "Logout realizado com sucesso",
    };
  }
}

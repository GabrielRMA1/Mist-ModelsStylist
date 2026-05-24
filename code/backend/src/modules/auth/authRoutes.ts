import type { FastifyInstance } from "fastify";

import { authenticate } from "../../middlewares/auth.js";

import { AuthController } from "./authController.js";

const authController = new AuthController();

export async function authRoutes(app: FastifyInstance) {
  app.post(
    "/signup",
    {
      schema: {
        tags: ["Auth"],
        summary: "Criar conta",
        description: "Cria uma nova conta de cliente ou estilista.",

        body: {
          type: "object",

          required: ["nome", "email", "senha", "role"],

          properties: {
            nome: {
              type: "string"
            },

            email: {
              type: "string"
            },

            senha: {
              type: "string",
              
            },

            telefone: {
              type: "string"
            },

            role: {
              type: "string",

              enum: ["CLIENTE", "ESTILISTA"],
            },

            especialidade: {
              type: "string"
            },

            descricao: {
              type: "string"
            },
          },
        },
      },
    },
    authController.signup
  );

  app.post(
    "/login",
    {
      schema: {
        tags: ["Auth"],
        summary: "Login",
        description: "Autentica um usuário no sistema.",

        body: {
          type: "object",

          required: ["email", "senha"],

          properties: {
            email: {
              type: "string"
            },

            senha: {
              type: "string"
              
            },
          },
        },
      },
    },
    authController.login
  );

  app.post(
    "/logout",
    {
      schema: {
        tags: ["Auth"],
        summary: "Logout",
        description: "Desloga o usuário autenticado.",
      },

      preHandler: [authenticate],
    },
    authController.logout
  );

  app.get(
    "/check-auth",
    {
      schema: {
        tags: ["Auth"],
        summary: "Verificar autenticação",
        description: "Verifica se o usuário está autenticado.",
      },

      preHandler: [authenticate],
    },
    authController.checkAuth
  );
}
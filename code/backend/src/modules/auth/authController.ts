import type { FastifyReply, FastifyRequest } from 'fastify'

import { AuthService } from './authService.js'

const authService = new AuthService()

export class AuthController {
  async signup(request: FastifyRequest, reply: FastifyReply) {
    try {
      const response = await authService.signup(
        request.body as any,
        reply,
      )

      return reply.status(201).send(response)
    } catch (error) {
      return reply.status(400).send({
        message:
          error instanceof Error
            ? error.message
            : 'Erro ao criar conta',
      })
    }
  }

  async login(request: FastifyRequest, reply: FastifyReply) {
    try {
      const response = await authService.login(
        request.body as any,
        reply,
      )

      return reply.send(response)
    } catch (error) {
      return reply.status(401).send({
        message:
          error instanceof Error
            ? error.message
            : 'Erro no login',
      })
    }
  }

  async logout(
    _request: FastifyRequest,
    reply: FastifyReply,
  ) {
    const response = await authService.logout(reply)

    return reply.send(response)
  }

  async checkAuth(
    request: FastifyRequest,
    reply: FastifyReply,
  ) {
    const profile = await authService.profile(
      request.user.id,
      request.user.role,
    )

    return reply.send({
      authenticated: true,
      user: request.user,
      profile,
    })
  }
}

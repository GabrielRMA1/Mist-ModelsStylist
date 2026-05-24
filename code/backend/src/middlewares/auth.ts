import type { FastifyReply, FastifyRequest } from 'fastify'
import jwt from 'jsonwebtoken'

import { env } from '../env.js'

interface JwtPayload {
  userId: number
  role: 'CLIENTE' | 'ESTILISTA'
}

export async function authenticate(
  request: FastifyRequest,
  reply: FastifyReply,
) {
  const token = request.cookies?.token

  if (!token) {
    return reply.status(401).send({
      message: 'Unauthorized',
    })
  }

  try {
    const decoded = jwt.verify(token, env.JWT_SECRET) as JwtPayload

    request.user = {
      id: decoded.userId,
      role: decoded.role,
    }
  } catch {
    return reply.status(401).send({
      message: 'Invalid token',
    })
  }
}
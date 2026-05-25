import { z } from "zod";

const envSchema = z.object({
	PORT: z.coerce.number().default(3333),
	DATABASE_URL: z.string().url().startsWith("postgresql://"),
	JWT_SECRET: z.string().min(1),
	NODE_ENV: z
		.enum(["development", "production", "test"])
		.default("development"),
	RABBITMQ_URL: z.string().url().startsWith("amqp://"),
	RABBITMQ_HOST: z.string().default("localhost"),
	RABBITMQ_PORT: z.coerce.number().default(5672),
	RABBITMQ_USER: z.string().default("admin"),
	RABBITMQ_PASS: z.string().default("admin"),
	RABBITMQ_VHOST: z.string().default("/")

});

export const env = envSchema.parse(process.env);
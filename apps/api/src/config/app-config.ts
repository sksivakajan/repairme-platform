import { existsSync } from 'node:fs';
import { resolve } from 'node:path';

const NODE_ENVS = ['development', 'test', 'production'] as const;
type NodeEnv = (typeof NODE_ENVS)[number];

// The single repository-level .env, shared with Docker Compose and Prisma.
// src/config and dist/config sit at the same depth, so this resolves for both.
const ROOT_ENV_FILE = resolve(import.meta.dirname, '../../../../.env');

/**
 * Validated application configuration, injected through Nest DI.
 */
export class AppConfig {
  constructor(
    readonly nodeEnv: NodeEnv,
    readonly port: number,
    readonly databaseUrl: string,
  ) {}

  /**
   * Loads the root .env when present (variables already set in the process
   * environment take precedence), then validates. Throws on invalid
   * configuration so the app fails fast at startup.
   */
  static load(): AppConfig {
    if (existsSync(ROOT_ENV_FILE)) {
      process.loadEnvFile(ROOT_ENV_FILE);
    }
    return AppConfig.validate(process.env);
  }

  static validate(env: NodeJS.ProcessEnv): AppConfig {
    const errors: string[] = [];

    const nodeEnv = (env.NODE_ENV ?? 'development') as NodeEnv;
    if (!NODE_ENVS.includes(nodeEnv)) {
      errors.push(`NODE_ENV must be one of: ${NODE_ENVS.join(', ')}`);
    }

    const port = Number(env.PORT ?? 3000);
    if (!Number.isInteger(port) || port < 1 || port > 65535) {
      errors.push('PORT must be an integer between 1 and 65535');
    }

    const databaseUrl = env.DATABASE_URL ?? '';
    if (!/^postgres(ql)?:\/\//.test(databaseUrl)) {
      errors.push('DATABASE_URL must be a postgresql:// connection URL');
    }

    if (errors.length > 0) {
      throw new Error(
        `Invalid environment configuration:\n- ${errors.join('\n- ')}`,
      );
    }

    return new AppConfig(nodeEnv, port, databaseUrl);
  }
}

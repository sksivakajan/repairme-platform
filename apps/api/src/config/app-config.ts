import { existsSync } from 'node:fs';
import { resolve } from 'node:path';

const NODE_ENVS = ['development', 'test', 'production'] as const;
type NodeEnv = (typeof NODE_ENVS)[number];

// The single repository-level .env, shared with Docker Compose and Prisma.
// src/config and dist/config sit at the same depth, so this resolves for both.
const ROOT_ENV_FILE = resolve(import.meta.dirname, '../../../../.env');
const DEFAULT_UPLOAD_DIR = resolve(import.meta.dirname, '../../storage/uploads');

/**
 * Validated application configuration, injected through Nest DI.
 */
export class AppConfig {
  constructor(
    readonly nodeEnv: NodeEnv,
    readonly port: number,
    readonly databaseUrl: string,
    /** Firebase project whose ID tokens are accepted. Unset = Firebase login disabled. */
    readonly firebaseProjectId: string | undefined,
    /** Development only: accept `Authorization: Dev <phone>` instead of a Firebase token. */
    readonly authDevBypass: boolean,
    /** Development only: expose /v1/dev endpoints that simulate technicians and operators. */
    readonly devTools: boolean,
    readonly uploadDir: string,
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

    const firebaseProjectId = env.FIREBASE_PROJECT_ID?.trim() || undefined;
    if (firebaseProjectId && !/^[a-z0-9-]{6,30}$/.test(firebaseProjectId)) {
      errors.push('FIREBASE_PROJECT_ID must be a valid Firebase project ID');
    }

    const authDevBypass = parseBoolean(env.AUTH_DEV_BYPASS, 'AUTH_DEV_BYPASS', errors);
    const devTools = parseBoolean(env.DEV_TOOLS, 'DEV_TOOLS', errors);
    if (nodeEnv === 'production' && (authDevBypass || devTools)) {
      errors.push('AUTH_DEV_BYPASS and DEV_TOOLS must never be enabled in production');
    }

    const uploadDir = env.UPLOAD_DIR?.trim()
      ? resolve(env.UPLOAD_DIR)
      : DEFAULT_UPLOAD_DIR;

    if (errors.length > 0) {
      throw new Error(
        `Invalid environment configuration:\n- ${errors.join('\n- ')}`,
      );
    }

    return new AppConfig(
      nodeEnv,
      port,
      databaseUrl,
      firebaseProjectId,
      authDevBypass,
      devTools,
      uploadDir,
    );
  }
}

function parseBoolean(
  value: string | undefined,
  name: string,
  errors: string[],
): boolean {
  if (value === undefined || value === '') return false;
  if (value === 'true') return true;
  if (value === 'false') return false;
  errors.push(`${name} must be "true" or "false"`);
  return false;
}

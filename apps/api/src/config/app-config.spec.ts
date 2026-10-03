import { AppConfig } from './app-config.js';

describe('AppConfig.validate', () => {
  const databaseUrl = 'postgresql://user:pass@localhost:5432/db';

  it('applies defaults for optional values', () => {
    const config = AppConfig.validate({ DATABASE_URL: databaseUrl });

    expect(config.nodeEnv).toBe('development');
    expect(config.port).toBe(3000);
    expect(config.databaseUrl).toBe(databaseUrl);
  });

  it('rejects a missing DATABASE_URL', () => {
    expect(() => AppConfig.validate({})).toThrow(/DATABASE_URL/);
  });

  it('rejects an invalid PORT', () => {
    expect(() =>
      AppConfig.validate({ DATABASE_URL: databaseUrl, PORT: 'abc' }),
    ).toThrow(/PORT/);
  });

  it('rejects an unknown NODE_ENV', () => {
    expect(() =>
      AppConfig.validate({ DATABASE_URL: databaseUrl, NODE_ENV: 'staging' }),
    ).toThrow(/NODE_ENV/);
  });
});

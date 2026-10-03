import { AppConfig } from './app-config.js';

describe('AppConfig.validate', () => {
  const databaseUrl = 'postgresql://user:pass@localhost:5432/db';

  it('applies defaults for optional values', () => {
    const config = AppConfig.validate({ DATABASE_URL: databaseUrl });

    expect(config.nodeEnv).toBe('development');
    expect(config.port).toBe(3000);
    expect(config.databaseUrl).toBe(databaseUrl);
    expect(config.firebaseProjectId).toBeUndefined();
    expect(config.authDevBypass).toBe(false);
    expect(config.devTools).toBe(false);
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

  it('refuses development auth bypass and dev tools in production', () => {
    expect(() =>
      AppConfig.validate({
        DATABASE_URL: databaseUrl,
        NODE_ENV: 'production',
        AUTH_DEV_BYPASS: 'true',
      }),
    ).toThrow(/never be enabled in production/);
    expect(() =>
      AppConfig.validate({
        DATABASE_URL: databaseUrl,
        NODE_ENV: 'production',
        DEV_TOOLS: 'true',
      }),
    ).toThrow(/never be enabled in production/);
  });

  it('rejects malformed booleans and Firebase project IDs', () => {
    expect(() =>
      AppConfig.validate({ DATABASE_URL: databaseUrl, DEV_TOOLS: 'yes' }),
    ).toThrow(/DEV_TOOLS/);
    expect(() =>
      AppConfig.validate({
        DATABASE_URL: databaseUrl,
        FIREBASE_PROJECT_ID: 'Bad Project!',
      }),
    ).toThrow(/FIREBASE_PROJECT_ID/);
  });
});

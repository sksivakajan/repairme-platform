import { INestApplication, ValidationPipe } from '@nestjs/common';

/** HTTP setup shared by main.ts and the e2e tests. */
export function setupApp(app: INestApplication): void {
  app.setGlobalPrefix('v1', { exclude: ['health'] });
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
}

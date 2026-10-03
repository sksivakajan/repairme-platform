import { INestApplication, ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import type { NextFunction, Request, Response } from 'express';
import helmet from 'helmet';
import { AppConfig } from './config/app-config.js';

const ROOT_PATHS = ['/health', '/openapi.json'];

/** HTTP setup shared by main.ts and the e2e tests. */
export function setupApp(app: INestApplication): void {
  // Security headers. The API only serves JSON, so nothing may be loaded or framed.
  app.use(
    helmet({
      contentSecurityPolicy: {
        useDefaults: false,
        directives: {
          defaultSrc: ["'none'"],
          frameAncestors: ["'none'"],
          baseUri: ["'none'"],
          formAction: ["'none'"],
        },
      },
    }),
  );
  // Everything except the health check and the spec lives under /v1. Answer
  // other paths here: Express's default 404 page would replace the policy above.
  app.use((req: Request, res: Response, next: NextFunction) => {
    if (req.path === '/v1' || req.path.startsWith('/v1/') || ROOT_PATHS.includes(req.path)) {
      return next();
    }
    res.status(404).json({ message: `Cannot ${req.method} ${req.path}`, error: 'Not Found', statusCode: 404 });
  });
  app.setGlobalPrefix('v1', { exclude: ['health'] });
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // OpenAPI spec (JSON only) for security scanning and client tooling; never in production.
  if (app.get(AppConfig).nodeEnv !== 'production') {
    const document = SwaggerModule.createDocument(
      app,
      new DocumentBuilder()
        .setTitle('RepairMe API')
        .addApiKey({ type: 'apiKey', in: 'header', name: 'Authorization' }, 'auth')
        .addSecurityRequirements('auth')
        .build(),
    );
    SwaggerModule.setup('docs', app, document, {
      jsonDocumentUrl: 'openapi.json',
      swaggerUiEnabled: false,
    });
  }
}

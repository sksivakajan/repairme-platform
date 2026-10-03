import { Controller, Get, ServiceUnavailableException } from '@nestjs/common';
import { Public } from '../auth/decorators.js';
import { HealthService, HealthStatus } from './health.service.js';

@Public()
@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  async check(): Promise<HealthStatus> {
    const health = await this.healthService.check();
    if (health.status !== 'ok') {
      // 503 so load balancers and uptime monitors mark the instance unhealthy.
      throw new ServiceUnavailableException(health);
    }
    return health;
  }
}

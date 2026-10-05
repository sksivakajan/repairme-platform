import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service.js';
import { LEGAL_DOCUMENTS, type LegalDocument } from './legal-documents.js';

export type LegalDocumentSummary = Omit<LegalDocument, 'content'>;

export interface DocumentRef {
  type: string;
  version: string;
}

@Injectable()
export class LegalService {
  constructor(private readonly prisma: PrismaService) {}

  /** Only published documents are current policies. */
  private published(): LegalDocument[] {
    return LEGAL_DOCUMENTS.filter((d) => d.status === 'PUBLISHED');
  }

  list(): LegalDocumentSummary[] {
    return this.published().map(({ content: _content, ...summary }) => summary);
  }

  get(type: string): LegalDocument {
    const document = this.published().find((d) => d.type === type);
    if (!document) throw new NotFoundException('Document not found');
    return document;
  }

  /** The documents the customer must accept (current version) but has not yet. */
  async pending(userId: string): Promise<DocumentRef[]> {
    const required = this.published().filter((d) => d.requiresAcceptance);
    if (required.length === 0) return [];
    const accepted = await this.prisma.legalAcceptance.findMany({
      where: { userId, documentType: { in: required.map((d) => d.type) } },
      select: { documentType: true, documentVersion: true },
    });
    return required
      .filter((d) => !accepted.some((a) => a.documentType === d.type && a.documentVersion === d.version))
      .map((d) => ({ type: d.type, version: d.version }));
  }

  /** Checks that every ref is a current published document, and that nothing required is missing. */
  validateAcceptance(refs: DocumentRef[], mustCoverRequired: boolean): void {
    const current = this.published();
    for (const ref of refs) {
      const document = current.find((d) => d.type === ref.type);
      if (!document || document.version !== ref.version) {
        throw new BadRequestException(`"${ref.type}" ${ref.version} is not the current version`);
      }
    }
    if (mustCoverRequired) {
      const missing = current.filter(
        (d) => d.requiresAcceptance && !refs.some((r) => r.type === d.type && r.version === d.version),
      );
      if (missing.length > 0) {
        throw new BadRequestException(`Please accept: ${missing.map((d) => d.title).join(', ')}`);
      }
    }
  }

  async record(userId: string, refs: DocumentRef[]): Promise<void> {
    for (const ref of refs) {
      await this.prisma.legalAcceptance.upsert({
        where: {
          userId_documentType_documentVersion: {
            userId,
            documentType: ref.type,
            documentVersion: ref.version,
          },
        },
        update: {},
        create: { userId, documentType: ref.type, documentVersion: ref.version },
      });
    }
  }

  history(userId: string) {
    return this.prisma.legalAcceptance.findMany({
      where: { userId },
      orderBy: { acceptedAt: 'desc' },
      select: { documentType: true, documentVersion: true, acceptedAt: true },
    });
  }
}

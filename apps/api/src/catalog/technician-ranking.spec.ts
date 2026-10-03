import { rankTopRated, type RankableTechnician } from './technician-ranking.js';

const category = (slug: string, sortOrder: number) => ({
  category: { slug, name: slug.toUpperCase(), sortOrder },
});

const technician = (
  displayName: string,
  ratingSum: number,
  ratingCount: number,
  categories = [category('general', 9)],
): RankableTechnician => ({
  displayName,
  ratingSum,
  ratingCount,
  jobsCompleted: ratingCount,
  categories,
});

describe('rankTopRated', () => {
  it('orders by average rating, then by number of ratings', () => {
    const ranked = rankTopRated([
      technician('Nuwan Silva', 312, 67), // 4.66
      technician('Ruwan Jay', 48, 10), // 4.8 from 10 ratings
      technician('Kasun Perera', 1018, 212), // 4.80
      technician('Sunil Fernando', 96, 20), // 4.8 from 20 ratings
    ]);
    expect(ranked.map((t) => t.firstName)).toEqual(['Kasun', 'Sunil', 'Ruwan', 'Nuwan']);
    expect(ranked[0].rating).toBe(4.8);
  });

  it('skips unrated technicians and applies the limit', () => {
    const ranked = rankTopRated(
      [technician('New Tech', 0, 0), technician('A B', 9, 2), technician('C D', 8, 2)],
      1,
    );
    expect(ranked.map((t) => t.firstName)).toEqual(['A']);
  });

  it('exposes only the first name and the main trade', () => {
    const [view] = rankTopRated([
      technician('Kasun Perera', 50, 10, [category('general', 9), category('electrical', 1)]),
    ]);
    expect(view).toEqual({
      firstName: 'Kasun',
      categorySlug: 'electrical',
      categoryName: 'ELECTRICAL',
      rating: 5,
      ratingCount: 10,
      jobsCompleted: 10,
    });
  });
});

/** How many technicians the customer home screen shows. */
export const TOP_RATED_LIMIT = 10;

export interface RankableTechnician {
  displayName: string;
  ratingSum: number;
  ratingCount: number;
  jobsCompleted: number;
  categories: { category: { slug: string; name: string; sortOrder: number } }[];
}

/**
 * Orders rated technicians by average rating, then by number of ratings, and
 * returns only what a customer browsing the app may see: first name, main
 * trade and rating (no full name or IDs).
 */
export function rankTopRated(
  technicians: RankableTechnician[],
  limit = TOP_RATED_LIMIT,
) {
  return technicians
    .filter((technician) => technician.ratingCount > 0)
    .map((technician) => ({
      technician,
      average: technician.ratingSum / technician.ratingCount,
    }))
    .sort(
      (a, b) =>
        b.average - a.average ||
        b.technician.ratingCount - a.technician.ratingCount,
    )
    .slice(0, limit)
    .map(({ technician, average }) => {
      const trade = technician.categories
        .map(({ category }) => category)
        .sort((a, b) => a.sortOrder - b.sortOrder)[0];
      return {
        firstName: technician.displayName.trim().split(/\s+/)[0],
        categorySlug: trade?.slug ?? null,
        categoryName: trade?.name ?? null,
        rating: Math.round(average * 10) / 10,
        ratingCount: technician.ratingCount,
        jobsCompleted: technician.jobsCompleted,
      };
    });
}

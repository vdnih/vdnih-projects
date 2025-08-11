import { getList } from '@/libs/microcms';
import { LIMIT } from '@/constants';
import Pagination from '@/components/Pagination';
import ArticleList from '@/components/ArticleList';

type Props = {
  params: Promise<{
    current: string;
  }>;
  searchParams: Promise<{
    q?: string;
  }>;
};

export const revalidate = 60;

export default async function Page({ params, searchParams }: Props) {
  const { current } = await params;
  const { q } = await searchParams;
  const currentNumber = parseInt(current, 10);
  const data = await getList({
    limit: LIMIT,
    offset: LIMIT * (currentNumber - 1),
    q,
  });
  return (
    <>
      <ArticleList articles={data.contents} />
      <Pagination
        totalCount={data.totalCount}
        current={currentNumber}
        basePath="/search"
        q={q}
      />
    </>
  );
}

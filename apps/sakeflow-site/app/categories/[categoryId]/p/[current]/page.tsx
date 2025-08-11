import { getList } from '@/libs/microcms';
import { LIMIT } from '@/constants';
import Pagination from '@/components/Pagination';
import ArticleList from '@/components/ArticleList';

type Props = {
  params: Promise<{
    categoryId: string;
    current: string;
  }>;
};

export const revalidate = 60;

export default async function Page({ params }: Props) {
  const { categoryId, current } = await params;
  const currentPage = parseInt(current, 10);
  const data = await getList({
    limit: LIMIT,
    offset: LIMIT * (currentPage - 1),
    filters: `category[equals]${categoryId}`,
  });
  return (
    <>
      <ArticleList articles={data.contents} />
      <Pagination totalCount={data.totalCount} current={currentPage} basePath={`/categories/${categoryId}`} />
    </>
  );
}


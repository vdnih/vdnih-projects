import { getList } from '@/libs/microcms';
import { LIMIT } from '@/constants';
import Pagination from '@/components/Pagination';
import ArticleList from '@/components/ArticleList';

type Props = {
  params: {
    categoryId: string;
    current: string;
  };
};

export const revalidate = 60;

export default async function Page({ params }: Props) {
  const { categoryId } = params;
  const current = parseInt(params.current, 10);
  const data = await getList({
    limit: LIMIT,
    offset: LIMIT * (current - 1),
    filters: `category[equals]${categoryId}`,
  });
  return (
    <>
      <ArticleList articles={data.contents} />
      <Pagination totalCount={data.totalCount} current={current} basePath={`/categories/${categoryId}`} />
    </>
  );
}

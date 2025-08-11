import { getList } from '@/libs/microcms';
import { LIMIT } from '@/constants';
import Pagination from '@/components/Pagination';
import ArticleList from '@/components/ArticleList';

type Props = {
  params: Promise<{
    tagId: string;
    current: string;
  }>;
};

export const revalidate = 60;

export default async function Page({ params }: Props) {
  const { tagId, current } = await params;
  const currentNumber = parseInt(current, 10);
  const data = await getList({
    limit: LIMIT,
    offset: LIMIT * (currentNumber - 1),
    filters: `tags[contains]${tagId}`,
  });
  return (
    <>
      <ArticleList articles={data.contents} />
      <Pagination totalCount={data.totalCount} current={currentNumber} basePath={`/tags/${tagId}`} />
    </>
  );
}

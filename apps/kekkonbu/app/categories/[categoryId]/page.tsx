import { Metadata } from 'next';
import { getList, getCategory } from '@/libs/microcms';
import { LIMIT } from '@/constants';
import Pagination from '@/components/Pagination';
import ArticleList from '@/components/ArticleList';

type Props = {
  params: {
    categoryId: string;
  };
};

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { categoryId } = params;
  const category = await getCategory(categoryId);
  return {
    title: category.name,
    openGraph: {
      title: category.name,
    },
    alternates: {
      canonical: `/categories/${categoryId}`,
    },
  };
}

export default async function Page({ params }: Props) {
  const { categoryId } = params;
  const data = await getList({
    limit: LIMIT,
    filters: `category[equals]${categoryId}`,
  });
  return (
    <>
      <ArticleList articles={data.contents} />
      <Pagination totalCount={data.totalCount} basePath={`/categories/${categoryId}`} />
    </>
  );
}
import { Metadata } from 'next';
import { getDetail } from '@/libs/microcms';
import Article from '@/components/Article';

// Next.js 15の型定義に合わせる
type ArticlePageProps = {
  params: { slug: string };
  searchParams: Record<string, string | string[] | undefined>;
}

export const revalidate = 60;

export async function generateMetadata({ params, searchParams }: ArticlePageProps): Promise<Metadata> {
  const draftKey = typeof searchParams.dk === 'string' ? searchParams.dk : undefined;
  const data = await getDetail(params.slug, {
    draftKey,
  });

  return {
    title: data.title,
    description: data.description,
    openGraph: {
      title: data.title,
      description: data.description,
      images: data?.thumbnail?.url ? [data.thumbnail.url] : [],
    },
  };
}

export default async function Page({ params, searchParams }: ArticlePageProps) {
  const draftKey = typeof searchParams.dk === 'string' ? searchParams.dk : undefined;
  const data = await getDetail(params.slug, {
    draftKey,
  });

  return <Article data={data} />;
}

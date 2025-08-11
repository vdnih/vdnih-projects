import { Metadata } from 'next';
import { getDetail } from '@/libs/microcms';
import Article from '@/components/Article';

// Next.js 15の型定義に合わせる
type ArticlePageProps = {
  params: Promise<{ slug: string }>;
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}

export const revalidate = 60;

export async function generateMetadata({ params, searchParams }: ArticlePageProps): Promise<Metadata> {
  const { slug } = await params;
  const search = await searchParams;
  const draftKey = typeof search.dk === 'string' ? search.dk : undefined;
  const data = await getDetail(slug, {
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
  const { slug } = await params;
  const search = await searchParams;
  const draftKey = typeof search.dk === 'string' ? search.dk : undefined;
  const data = await getDetail(slug, {
    draftKey,
  });

  return <Article data={data} />;
}

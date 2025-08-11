import { Metadata } from 'next';
import { getDetail } from '@/libs/microcms';
import Article from '@/components/Article';

type Props = {
  params: Promise<{
    slug: string;
  }>;
  searchParams: Promise<{
    dk?: string;
  }>;
};

export const revalidate = 60;

export async function generateMetadata({ params, searchParams }: Props): Promise<Metadata> {
  const { slug } = await params;
  const { dk } = await searchParams;
  const data = await getDetail(slug, {
    draftKey: dk,
  });

  return {
    title: data.title,
    description: data.description,
    openGraph: {
      title: data.title,
      description: data.description,
      images: [data?.thumbnail?.url || ''],
    },
  };
}

export default async function Page({ params, searchParams }: Props) {
  const { slug } = await params;
  const { dk } = await searchParams;
  const data = await getDetail(slug, {
    draftKey: dk,
  });

  return <Article data={data} />;
}

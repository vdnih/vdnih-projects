import { createClient } from 'microcms-js-sdk';
import type {
  MicroCMSQueries,
  MicroCMSImage,
  MicroCMSDate,
  MicroCMSContentId,
} from 'microcms-js-sdk';
import { unstable_noStore as noStore } from 'next/cache';

// カテゴリの型定義
export type Category = {
  name: string;
  value: string;
} & MicroCMSContentId & MicroCMSDate;

// ライターの型定義
export type Writer = {
  name: string;
  profile: string;
  image?: MicroCMSImage;
} & MicroCMSContentId & MicroCMSDate;

// ブログの型定義
export type Blog = {
  title: string;
  content: string;
  thumbnail?: MicroCMSImage;
  category: Category;
  writer: Writer;
  description: string;
};

export type Article = Blog & MicroCMSContentId & MicroCMSDate;

type MicroCMSClient = ReturnType<typeof createClient>;

const createStubClient = (): MicroCMSClient => ({
  get: async () => null,
  getList: async () => ({ contents: [] }),
  getListDetail: async () => null,
} as unknown as MicroCMSClient);

export const getClient = (): MicroCMSClient => {
  if (process.env.DISABLE_CMS === '1') {
    return createStubClient();
  }

  const serviceDomain = process.env.MICROCMS_SERVICE_DOMAIN;
  const apiKey = process.env.MICROCMS_API_KEY;

  if (!serviceDomain) {
    throw new Error('MICROCMS_SERVICE_DOMAIN is required');
  }
  if (!apiKey) {
    throw new Error('MICROCMS_API_KEY is required');
  }

  return createClient({ serviceDomain, apiKey });
};

// ブログ一覧を取得
export const getList = async (queries?: MicroCMSQueries) => {
  noStore();
  const client = getClient();
  try {
    const listData = await client.getList<Blog>({
      endpoint: 'blogs',
      queries,
    });
    return listData;
  } catch (error) {
    console.error('Failed to fetch blog list:', error);
    return { contents: [] } as any;
  }
};

// ブログの詳細を取得
export const getDetail = async (contentId: string, queries?: MicroCMSQueries) => {
  noStore();
  const client = getClient();
  try {
    const detailData = await client.getListDetail<Blog>({
      endpoint: 'blogs',
      contentId,
      queries,
    });
    return detailData;
  } catch (error) {
    console.error('Failed to fetch blog detail:', error);
    return {} as Article;
  }
};

// カテゴリ一覧を取得
export const getCategoryList = async () => {
  noStore();
  const client = getClient();
  try {
    const listData = await client.getList<Category>({
      endpoint: 'categories',
    });
    return listData;
  } catch (error) {
    console.error('Failed to fetch category list:', error);
    return { contents: [] } as any;
  }
};

// カテゴリの詳細を取得
export const getCategory = async (categoryId: string) => {
  noStore();
  const client = getClient();
  try {
    const categoryData = await client.get({
      endpoint: 'categories',
      contentId: categoryId,
    });
    return categoryData;
  } catch (error) {
    console.error('Failed to fetch category:', error);
    return {} as any;
  }
};

import { env } from './env';

export async function getPosts() {
  const res = await fetch(`${env.NEXT_PUBLIC_CMS_BASE_URL}/posts`, {
    headers: env.CMS_API_TOKEN ? { Authorization: `Bearer ${env.CMS_API_TOKEN}` } : undefined
  });
  return res.json();
}

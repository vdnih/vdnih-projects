import { z } from 'zod';

const schema = z.object({
  NEXT_PUBLIC_CMS_BASE_URL: z.string().url(),
  CMS_API_TOKEN: z.string().optional()
});

export const env = schema.parse({
  NEXT_PUBLIC_CMS_BASE_URL: process.env.NEXT_PUBLIC_CMS_BASE_URL,
  CMS_API_TOKEN: process.env.CMS_API_TOKEN
});

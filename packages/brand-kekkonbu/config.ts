export const brand = {
  key: 'kekkonbu',
  siteTitle: 'kekkonbu',
  description: '＜kekkonbu の説明＞',
  theme: {
    primary: '#2255ee'
  },
  og: { defaultImagePath: '/ogp.png' }
} as const;
export type Brand = typeof brand;

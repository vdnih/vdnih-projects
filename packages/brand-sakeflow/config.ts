export const brand = {
  key: 'sakeflow',
  siteTitle: 'sakeflow',
  description: '＜sakeflow の説明＞',
  theme: {
    primary: '#ff5500'
  },
  og: { defaultImagePath: '/ogp.png' }
} as const;
export type Brand = typeof brand;

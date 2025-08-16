import React from 'react';
import type { Brand } from 'brand/config';

export function RootLayout(
  { brand, children }: { brand: Brand; children: React.ReactNode }
) {
  return (
    <html lang="ja">
      <head>
        <title>{brand.siteTitle}</title>
        <meta name="description" content={brand.description} />
      </head>
      <body style={{ ['--brand-primary' as any]: brand.theme.primary }}>
        {children}
      </body>
    </html>
  );
}

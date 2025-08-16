import { RootLayout } from '@core-web/layouts/RootLayout';
import { brand } from 'brand/config';
import './globals.css';

export default function Layout({ children }: { children: React.ReactNode }) {
  return <RootLayout brand={brand}>{children}</RootLayout>;
}

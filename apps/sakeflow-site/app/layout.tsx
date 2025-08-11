import { getCategoryList } from '@/libs/microcms';
import { LIMIT } from '@/constants';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import Nav from '@/components/Nav';
import './globals.css';
import styles from './layout.module.css';

export const metadata = {
  metadataBase: new URL(process.env.BASE_URL || 'http://localhost:3000'),
  title: 'sakeflow',
  description: 'お酒と旅行を楽しむライフスタイルブログ',
  openGraph: {
    title: 'sakeflow',
    description: 'お酒と旅行を楽しむライフスタイルブログ',
    images: '/ogp.png',
  },
  alternates: {
    canonical: '/',
  },
};

type Props = {
  children: React.ReactNode;
};

export default async function RootLayout({ children }: Props) {
  const categories = await getCategoryList();
  return (
    <html lang="ja">
      <body>
        <Header />
        <Nav categories={categories.contents} />
        <main className={styles.main}>{children}</main>
        <Footer />
      </body>
    </html>
  );
}

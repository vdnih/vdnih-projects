import { Category } from '@/libs/microcms';
import CategoryList from '@/components/CategoryList';
import SearchField from '@/components/SearchField';
import Link from 'next/link';
import { Suspense } from 'react';
import styles from './index.module.css';

type Props = {
  categories: Category[];
};

export default function Nav({ categories }: Props) {
  return (
    <nav className={styles.nav}>
      <h1 className={styles.title}>結婚部</h1>
      <div className={styles.menu}>
        <Link href="/about" className={styles.menuItem}>
          このブログについて
        </Link>
      </div>
      <Suspense fallback={null}>
        <SearchField />
      </Suspense>
      <div className={styles.categories}>
        {categories.map((category) => (
          <CategoryList key={category.id} category={category} />
        ))}
      </div>
    </nav>
  );
}

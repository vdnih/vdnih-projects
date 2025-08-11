import { Category } from '@/libs/microcms';
import CategoryList from '@/components/CategoryList';
import SearchField from '@/components/SearchField';
import styles from './index.module.css';

type Props = {
  categories: Category[];
};

export default function Nav({ categories }: Props) {
  return (
    <nav className={styles.nav}>
      <SearchField />
      <div className={styles.categories}>
        {categories.map((category) => (
          <CategoryList key={category.id} category={category} />
        ))}
      </div>
    </nav>
  );
}
import { computed, effect, Injectable, signal } from '@angular/core';

import { MenuItem } from '../models/layout.model';

@Injectable({ providedIn: 'root' })
export class SidebarNavService {
  // ==============================
  // 🔹 Señales privadas
  // ==============================
  private readonly _menuItems = signal<MenuItem[]>([
    {
      id: 1,
      url: '/',
      label: '',
      name: 'Home',
      href: '/home',
      icon: 'home',
      iconComponent: undefined,
      title: '',
      variant: '',
      divider: false,
    },
    {
      id: 2,
      url: '/dashboard',
      label: '',
      name: 'Dashboard',
      href: '/dashboard',
      icon: 'home',
      iconComponent: undefined,
      title: '',
      variant: '',
      divider: false,
    },
    {
      id: 3,
      url: '/',
      label: '',
      name: 'Settings',
      href: '/settings',
      icon: 'home',
      iconComponent: undefined,
      title: '',
      variant: '',
      divider: false,
    },
    {
      id: 4,
      url: '/',
      label: '',
      name: 'Profile',
      href: '/profile',
      icon: 'home',
      iconComponent: undefined,
      title: '',
      variant: '',
      divider: false,
    },
  ]);

  private readonly _searchTerm = signal<string>('');

  // ==============================
  // 🔹 Computed / efectos privados
  // ==============================
  private readonly _filteredMenuItems = computed(() => {
    const term = this._searchTerm().toLowerCase();
    if (!term) return this._menuItems();
    return this._menuItems().filter((item) => item.name.toLowerCase().includes(term));
  });

  private readonly _logEffect = effect(() => {
    console.log('Menu filtrado actualizado:', this._filteredMenuItems());
  });

  // ==============================
  // 🔹 Señales públicas
  // ==============================
  public readonly menuItems = this._menuItems.asReadonly();
  public readonly searchTerm = this._searchTerm.asReadonly();
  public readonly filteredMenuItems = this._filteredMenuItems;

  // ==============================
  // 🔹 Métodos públicos
  // ==============================
  public addMenuItem(item: MenuItem): void {
    const nextId = Math.max(...this._menuItems().map((i) => Number(i.id)), 0) + 1;
    this._menuItems.set([...this._menuItems(), { ...item, id: nextId }]);
  }

  public updateMenuItem(id: number, updatedItem: Partial<MenuItem>): void {
    const current = [...this._menuItems()];
    const index = current.findIndex((i) => i.id === id);
    if (index !== -1) {
      current[index] = { ...current[index], ...updatedItem };
      this._menuItems.set(current);
    }
  }

  public deleteMenuItem(id: number): void {
    this._menuItems.set(this._menuItems().filter((i) => i.id !== id));
  }

  public searchMenuItems(term: string): void {
    this._searchTerm.set(term);
  }

  public setMenuItems(items: MenuItem[]): void {
    this._menuItems.set([...items]);
  }

  public clearSearch(): void {
    this._searchTerm.set('');
  }
}

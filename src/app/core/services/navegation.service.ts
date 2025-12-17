import { computed, effect, Injectable, signal } from '@angular/core';

import { MenuItem } from '../models/layout.model';

@Injectable({ providedIn: 'root' })
export class MenuService {
  // ==============================
  // 🔹 Señales privadas
  // ==============================
  private readonly _menuItems = signal<MenuItem[]>([
    {
      id: 0,
      url: 'admin',
      label: 'Admin',
      name: 'Admin',
      href: '',
      icon: 'home',
      divider: true,
    },
    {
      id: 1,
      url: 'dashboard',
      label: 'Dashboard',
      name: 'Dashboard',
      href: '',
      icon: 'newspaper',
      divider: true,
    },
    {
      id: 2,
      url: 'table',
      label: 'Tablas',
      name: 'Tablas',
      href: '',
      icon: 'monitoring',
      divider: true,
    },
    {
      id: 3,
      url: 'card',
      label: 'Card',
      name: 'Card',
      href: '',
      icon: 'monitoring',
      divider: true,
    },
  ]);

  private readonly _searchTerm = signal<string>('');

  // ==============================
  // 🔹 Effects privados
  // ==============================
  private readonly _saveEffect = effect(() => {
    localStorage.setItem('menuItems', JSON.stringify(this._menuItems()));
  });

  private readonly _initEffect = effect(
    () => {
      this.loadMenuItems();
    },
    { allowSignalWrites: true },
  );

  // ==============================
  // 🔹 Computed / derivadas privadas
  // ==============================
  private readonly _filteredMenuItems = computed(() => {
    const term = this._searchTerm().toLowerCase();
    if (!term) return this._menuItems();
    return this._menuItems().filter((item) => item.name.toLowerCase().includes(term));
  });

  // ==============================
  // 🔹 Señales públicas solo lectura
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
    const items = [...this._menuItems()];
    const index = items.findIndex((i) => Number(i.id) === id);
    if (index !== -1) {
      items[index] = { ...items[index], ...updatedItem };
      this._menuItems.set(items);
    }
  }

  public deleteMenuItem(id: number): void {
    this._menuItems.set(this._menuItems().filter((i) => Number(i.id) !== id));
  }

  public searchMenuItems(term: string): void {
    this._searchTerm.set(term);
  }

  public setMenuItems(items: MenuItem[]): void {
    this._menuItems.set([...items]);
  }

  public loadMenuItems(): void {
    const saved = localStorage.getItem('menuItems');
    if (saved) {
      this._menuItems.set(JSON.parse(saved));
    }
  }

  public clearMenu(): void {
    this._menuItems.set([]);
    this._searchTerm.set('');
  }
}

import { computed, effect,Injectable, signal } from '@angular/core';

import { MenuItem } from '../models/layout.model';

@Injectable({ providedIn: 'root' })
export class SidebarNavService {
  // 🔹 Señal privada que mantiene la lista completa de elementos del menú
  private readonly _menuItems = signal<MenuItem[]>([
    { id: 1, url: '/', label: '', name: 'Home', href: '/home', icon: 'home', iconComponent: undefined, title: '', variant: '', divider: false },
    { id: 2, url: '/dashboard', label: '', name: 'Dashboard', href: '/dashboard', icon: 'home', iconComponent: undefined, title: '', variant: '', divider: false },
    { id: 3, url: '/', label: '', name: 'Settings', href: '/settings', icon: 'home', iconComponent: undefined, title: '', variant: '', divider: false },
    { id: 4, url: '/', label: '', name: 'Profile', href: '/profile', icon: 'home', iconComponent: undefined, title: '', variant: '', divider: false },
  ]);

  // 🔹 Señal privada para término de búsqueda
  private readonly _searchTerm = signal<string>('');

  // 🔹 Señal pública solo lectura: lista completa del menú
  public readonly menuItems = this._menuItems.asReadonly();

  // 🔹 Señal pública solo lectura: término de búsqueda
  public readonly searchTerm = this._searchTerm.asReadonly();

  // 🔹 Computed: lista filtrada según el término de búsqueda
  public readonly filteredMenuItems = computed(() => {
    const term = this._searchTerm().toLowerCase();
    if (!term) return this._menuItems();
    return this._menuItems().filter(item =>
      item.name.toLowerCase().includes(term)
    );
  });

  // 🔹 Effect opcional: log cuando cambia la lista filtrada (para debug)
  private readonly filteredEffect = effect(() => {
    console.log('Menu filtrado actualizado:', this.filteredMenuItems());
  });

  // ==============================
  // 🔹 Métodos públicos
  // ==============================

  /** Agrega un nuevo item al menú */
  public addMenuItem(item: MenuItem): void {
    const nextId = Math.max(...this._menuItems().map(i => i.id), 0) + 1;
    this._menuItems.set([...this._menuItems(), { ...item, id: nextId }]);
  }

  /** Actualiza un item existente */
  public updateMenuItem(id: number, updatedItem: Partial<MenuItem>): void {
    const current = [...this._menuItems()];
    const index = current.findIndex(i => i.id === id);
    if (index !== -1) {
      current[index] = { ...current[index], ...updatedItem };
      this._menuItems.set(current);
    }
  }

  /** Elimina un item por ID */
  public deleteMenuItem(id: number): void {
    this._menuItems.set(this._menuItems().filter(i => i.id !== id));
  }

  /** Actualiza el término de búsqueda */
  public searchMenuItems(term: string): void {
    this._searchTerm.set(term);
  }

  /** Reemplaza toda la lista del menú */
  public setMenuItems(items: MenuItem[]): void {
    this._menuItems.set([...items]);
  }

  /** Limpia el término de búsqueda */
  public clearSearch(): void {
    this._searchTerm.set('');
  }
}

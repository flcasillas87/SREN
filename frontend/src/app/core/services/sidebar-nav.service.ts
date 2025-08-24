import { BehaviorSubject, Observable } from 'rxjs';
import { Injectable } from '@angular/core';
import { MenuItem } from '../models/layout.model';

@Injectable({ providedIn: 'root' })
export class SidebarNavService {
  // BehaviorSubject que mantiene la lista de elementos del menú
  private menuItemsSubject = new BehaviorSubject<MenuItem[]>([
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
      name: 'Home',
      href: '/home',
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
      name: 'Home',
      href: '/home',
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
      name: 'Home',
      href: '/home',
      icon: 'home',
      iconComponent: undefined,
      title: '',
      variant: '',
      divider: false,
    },
  ]);

  // BehaviorSubject que mantiene la lista filtrada de elementos del menú
  private filteredMenuItemsSubject = new BehaviorSubject<MenuItem[]>(
    this.menuItemsSubject.value,
  );

  // Observable que expone la lista de elementos del menú
  menuItems$: Observable<MenuItem[]> = this.menuItemsSubject.asObservable();

  // Observable que expone la lista filtrada de elementos del menú
  filteredMenuItems$: Observable<MenuItem[]> =
    this.filteredMenuItemsSubject.asObservable();

  // Métodos para manipular los elementos de menú
  addMenuItem(item: MenuItem): void {
    const currentItems = this.menuItemsSubject.value;
    this.menuItemsSubject.next([...currentItems, item]);
    this.filteredMenuItemsSubject.next(this.menuItemsSubject.value); // Actualiza la lista filtrada
  }

  // Método para actualizar un elemento existente del menú
  updateMenuItem(id: number, updatedItem: MenuItem): void {
    const currentItems = this.menuItemsSubject.value;
    const index = currentItems.findIndex((item) => item.id === id);
    if (index !== -1) {
      currentItems[index] = updatedItem;
      this.menuItemsSubject.next([...currentItems]);
      this.filteredMenuItemsSubject.next(this.menuItemsSubject.value); // Actualiza la lista filtrada
    }
  }

  // Método para eliminar un elemento del menú
  deleteMenuItem(id: number): void {
    const currentItems = this.menuItemsSubject.value.filter(
      (item) => item.id !== id,
    );
    this.menuItemsSubject.next(currentItems);
    this.filteredMenuItemsSubject.next(this.menuItemsSubject.value); // Actualiza la lista filtrada
  }

  // Método para buscar elementos del menú por término de búsqueda
  searchMenuItems(searchTerm: string): void {
    const filteredItems = this.menuItemsSubject.value.filter((item) =>
      item.name.toLowerCase().includes(searchTerm.toLowerCase()),
    );
    this.filteredMenuItemsSubject.next(filteredItems); // Actualiza los elementos filtrados
  }
}

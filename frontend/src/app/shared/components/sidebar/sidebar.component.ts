import { ChangeDetectionStrategy, Component, computed,signal } from '@angular/core';

import { SidebarHeaderComponent } from './sidebar-header/sidebar-header.component';
import { SidebarNavComponent } from './sidebar-nav/sidebar-nav.component';

export interface NavItem {
  label: string;
  route: string;
}

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [SidebarHeaderComponent, SidebarNavComponent],
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SidebarComponent {
  // 🔹 Señal privada de los items de navegación
  private readonly _navItems = signal<NavItem[]>([
    { label: 'Dashboard', route: '/' },
    { label: 'Usuarios', route: '/usuarios' },
    { label: 'Ajustes', route: '/ajustes' }
  ]);

  // 🔹 Señal privada del título
  private readonly _title = signal('Menú');

  // 🔹 Señales públicas solo lectura para template
  public readonly navItems = this._navItems.asReadonly();
  public readonly title = this._title.asReadonly();

  // 🔹 Computed ejemplo: número de items
  public readonly navCount = computed(() => this._navItems().length);

  // ==============================
  // 🔹 Métodos públicos para modificar señales
  // ==============================

  /** Actualiza el título */
  public setTitle(value: string): void {
    this._title.set(value);
  }

  /** Reemplaza todos los items de navegación */
  public setNavItems(items: NavItem[]): void {
    this._navItems.set([...items]);
  }

  /** Agrega un item de navegación */
  public addNavItem(item: NavItem): void {
    this._navItems.set([...this._navItems(), item]);
  }

  /** Elimina un item por label o route */
  public removeNavItem(route: string): void {
    this._navItems.set(this._navItems().filter(i => i.route !== route));
  }
}

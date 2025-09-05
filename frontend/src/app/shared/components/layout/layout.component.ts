import { ChangeDetectionStrategy, Component, signal } from '@angular/core';
import { RouterModule } from '@angular/router';

import { FooterComponent } from '../footer/footer.component';
import { HeaderComponent } from '../header/header.component';
import { SidebarComponent } from '../sidebar/sidebar.component';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [FooterComponent, HeaderComponent, SidebarComponent, RouterModule],
  templateUrl: './layout.component.html',
  styleUrls: ['./layout.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class LayoutComponent {
  /** Signal privada para controlar el sidebar */
  private readonly _sidebarOpen = signal<boolean>(true);

  /** Estado público y de solo lectura para el template */
  public readonly isSidebarOpen = this._sidebarOpen.asReadonly();

  /** Alterna el estado del sidebar */
  public toggleSidebar(): void {
    this._sidebarOpen.update((open: boolean) => !open);
  }
}

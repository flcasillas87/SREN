import { ChangeDetectionStrategy, Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { FooterComponent } from '@shared/components/footer/footer.component';
import { HeaderComponent } from '@shared/components/header/header.component';
import { SidebarComponent } from '@shared/components/sidebar/sidebar.component';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [
    HeaderComponent, // ✅ debe ser standalone
    SidebarComponent, // ✅ debe ser standalone
    FooterComponent, // ✅ debe ser standalone
    RouterModule, // ✅ NgModule
  ],
  templateUrl: './layout.component.html',
  styleUrls: ['./layout.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class LayoutComponent {
  public sidebarOpen() {
    throw new Error('Method not implemented.');
  }
  public toggleSidebar() {
    throw new Error('Method not implemented.');
  }
}

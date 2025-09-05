import { ChangeDetectionStrategy, Component } from '@angular/core';
import { RouterModule } from '@angular/router';

import { FooterComponent } from './footer/footer.component';
import { HeaderComponent } from './header/header.component';
import { SidebarComponent } from './sidebar/sidebar.component';

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
export class LayoutComponent {}

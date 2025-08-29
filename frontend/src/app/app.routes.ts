import { Routes } from '@angular/router';
import { NotFoundComponent } from './features/errors/not-found/not-found.component';
import { HeaderComponent } from './shared/components/header/header.component';
import { LayoutComponent } from './shared/components/layout/layout.component';
import { CentralesListComponent } from './features/centrales-list/centrales-list.component';

export const routes: Routes = [
  { path: '', component: NotFoundComponent },
  { path: 'header', component: HeaderComponent },
  { path: 'layout', component: LayoutComponent },
  { path: 'centrales', component: CentralesListComponent },
];

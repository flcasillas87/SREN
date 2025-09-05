import { ChangeDetectionStrategy, Component } from '@angular/core';

import { HeaderBrandComponent } from '../header/header-brand/header-brand.component';
import { HeaderDividerComponent } from '../header/header-divider/header-divider.component';
import { HeaderLogoComponent } from '../header/header-logo/header-logo.component';
import { HeaderNavComponent } from '../header/header-nav/header-nav.component';
import { HeaderSearchComponent } from '../header/header-search/header-search.component';
import { HeaderTextComponent } from '../header/header-text/header-text.component';
import { HeaderTogglerComponent } from '../header/header-toggler/header-toggler.component';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [
    HeaderBrandComponent,
    HeaderLogoComponent,
    HeaderNavComponent,
    HeaderTextComponent,
    HeaderDividerComponent,
    HeaderSearchComponent,
    HeaderTogglerComponent,
  ],
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HeaderComponent {}

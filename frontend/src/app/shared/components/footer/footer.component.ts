import { ChangeDetectionStrategy, Component, inject,  } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatDividerModule } from '@angular/material/divider';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { RouterModule } from '@angular/router'; // Importando RouterModule

import { FooterContentService } from '../../../core/services/footer-content.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'app-footer',
  templateUrl: './footer.component.html',
  styleUrls: ['./footer.component.css'],
    imports: [
    MatCardModule,
    MatDividerModule,
    MatIconModule,
    MatListModule,
    RouterModule
  ],
})
export class FooterComponent {
  private footerContentService = inject(FooterContentService);
  
  // Creamos un signal con computed para manejar el contenido
  footerContent$ = this.footerContentService.footerContent();

}











import { ChangeDetectionStrategy, Component, effect, inject, signal } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatDividerModule } from '@angular/material/divider';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { RouterModule } from '@angular/router';

import { FooterContentService } from '../../../core/services/footer-content.service';

@Component({
  selector: 'app-footer',
  standalone: true,
  imports: [
    MatCardModule,
    MatDividerModule,
    MatIconModule,
    MatListModule,
    RouterModule,
  ],
  templateUrl: './footer.component.html',
  styleUrls: ['./footer.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class FooterComponent {
  /** Servicio privado inyectado para obtener contenido del footer */
  private readonly _footerContentService = inject(FooterContentService);

  /** Signal reactiva que almacena el contenido del footer */
  public readonly footerContent = signal<string>(this._footerContentService.footerContent());

  /** Efecto que actualiza la señal automáticamente */
  private readonly _footerEffect = effect(() => {
    this.footerContent.set(this._footerContentService.footerContent());
  });
}

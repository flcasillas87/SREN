import { ChangeDetectionStrategy, Component, effect, inject, signal } from '@angular/core';
import { RouterModule } from '@angular/router';
import { FooterContent } from '@core/models/layout.model';
import { FooterContentService } from '@core/services/footer-content.service';

@Component({
  selector: 'app-footer',
  standalone: true,
  imports: [ RouterModule],
  templateUrl: './footer.component.html',
  styleUrls: ['./footer.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class FooterComponent {
  // Privados
  private readonly _footerContentService = inject(FooterContentService);

  private readonly _footerEffect = effect(() => {
    this.footerContent.set(this._footerContentService.footerContent());
  });

  // Públicos
  public readonly footerContent = signal<FooterContent>(this._footerContentService.footerContent());
}

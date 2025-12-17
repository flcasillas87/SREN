import { ChangeDetectionStrategy, Component, signal } from '@angular/core';

@Component({
  selector: 'app-header-search', // ✅ coincide con el archivo y uso
  standalone: true,
  templateUrl: './header-search.component.html',
  styleUrls: ['./header-search.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HeaderSearchComponent {
  /** Signal reactiva para el término de búsqueda */
  public readonly searchTerm = signal<string>('');
}

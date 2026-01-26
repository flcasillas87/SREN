import { ChangeDetectionStrategy, Component, inject, Signal, signal } from '@angular/core';
import { Router, RouterModule } from '@angular/router';

@Component({
  selector: 'app-not-found',
  standalone: true,
  imports: [RouterModule],
  changeDetection: ChangeDetectionStrategy.OnPush, // 🔹 OnPush activado
  templateUrl: './not-found.component.html',
  styleUrls: ['./not-found.component.css'],
})
export class NotFoundComponent {
  // 🔹 Router inyectado usando inject()
  private readonly _router = inject(Router);

  // 🔹 Mensajes dinámicos como signals
  public readonly title: Signal<string> = signal('Error 404 - Página no encontrada');
  public readonly description: Signal<string> = signal('La página que buscas no existe o ha sido eliminada.');

  // 🔹 Método para redirigir a home
  public goHome(): void {
    this._router.navigate(['/home']);
  }
}

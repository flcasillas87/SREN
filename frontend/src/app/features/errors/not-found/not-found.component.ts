import { Component, signal } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-not-found',
  standalone: true,
  imports: [RouterModule, MatCardModule, MatButtonModule, MatIconModule],
  templateUrl: './not-found.component.html',
  styleUrls: ['./not-found.component.css'],
})
export class NotFoundComponent {
  // Mensaje dinámico opcional como signal
  public readonly title = signal<string>('Error 404 - Página no encontrada');
  public readonly description = signal<string>('La página que buscas no existe o ha sido eliminada.');

  // Método opcional para redirigir a home
  public goHome(): void {
    // Aquí podrías usar Router.navigate si lo inyectas
    console.log('Redirigir al home');
  }
}

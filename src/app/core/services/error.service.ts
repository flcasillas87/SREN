// core/error.service.ts
import { Injectable, Signal, signal } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class ErrorService {
  // 🔹 Señal privada para el mensaje de error
  private readonly _errorMessage = signal<string | null>(null);

  // 🔹 Señal pública readonly para exponer solo lectura
  public readonly errorMessage: Signal<string | null> = this._errorMessage.asReadonly();

  /** Establece un mensaje de error y lo limpia automáticamente después de 5 segundos */
  public setError(message: string): void {
    this._errorMessage.set(message);
    setTimeout(() => this.clearError(), 5000);
  }

  /** Limpia el mensaje de error */
  public clearError(): void {
    this._errorMessage.set(null);
  }
}

//maneja un signal global para mostrar mensajes tipo toast o logs

// core/error.service.ts
import { Injectable, signal } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class ErrorService {
  errorMessage = signal<string | null>(null);

  setError(message: string) {
    this.errorMessage.set(message);
    setTimeout(() => this.clearError(), 5000); // auto-clear después de 5s
  }

  clearError() {
    this.errorMessage.set(null);
  }
}
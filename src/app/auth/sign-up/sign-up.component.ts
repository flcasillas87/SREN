import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { FormBuilder, FormControl, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { material_modules } from '@core/providers/material.provider';
import { AuthService } from '@services/auth.service';
import { AuthError } from '@supabase/supabase-js';

interface SignUpForm {
  email: FormControl<string>;
  password: FormControl<string>;
}

@Component({
  selector: 'app-sign-up',
  standalone: true,
  imports: [material_modules, ReactiveFormsModule, RouterLink],
  templateUrl: './sign-up.component.html',
  styleUrl: './sign-up.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export default class SignUpComponent {
  private readonly _formBuilder = inject(FormBuilder);
  private readonly _authService = inject(AuthService);
  private readonly _router = inject(Router);

  public readonly isLoading = signal(false);

  public readonly signUpForm = this._formBuilder.group<SignUpForm>({
    email: new FormControl('', { nonNullable: true, validators: [Validators.required, Validators.email] }),
    password: new FormControl('', { nonNullable: true, validators: [Validators.required, Validators.minLength(6)] }),
  });

  public async submit(): Promise<void> {
    if (this.signUpForm.invalid) return;

    this.isLoading.set(true);

    try {
      const { email, password } = this.signUpForm.getRawValue();
      
      const { data, error } = await this._authService.signUp({ email, password });

      if (error) throw error;

      if (data.user && !data.session) {
        alert('Registro exitoso. Revisa tu correo.');
        this._router.navigateByUrl('/auth/login');
      } else {
        this._router.navigateByUrl('/');
      }

    } catch (error: unknown) {
      let message = 'Error inesperado';
      if (error instanceof AuthError) message = error.message;
      else if (error instanceof Error) message = error.message;
      
      console.error('[SignUpComponent]:', message);
    } finally {
      this.isLoading.set(false);
    }
  }
}

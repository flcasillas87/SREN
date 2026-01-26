import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { FormBuilder, FormControl, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '@services/auth.service';

interface LogInForm {
  email: FormControl<null | string>;
  password: FormControl<null | string>;
}
@Component({
  selector: 'app-log-in',
  imports: [ ReactiveFormsModule, RouterLink],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export default class LoginComponent {
  private _formBuilder = inject(FormBuilder);
  private _authService = inject(AuthService);
  private _router = inject(Router);

  public logInForm = this._formBuilder.nonNullable.group<LogInForm>({
    email: this._formBuilder.control(null, [Validators.required, Validators.email]),
    password: this._formBuilder.control(null, [Validators.required]),
  });

  public async submit() {
    if (this.logInForm.invalid) return;

    try {
      const { error } = await this._authService.logIn({
        email: this.logInForm.value.email ?? '',
        password: this.logInForm.value.password ?? '',
      });

      if (error) throw error;

      this._router.navigateByUrl('/');
    } catch (error) {
      if (error instanceof Error) {
        console.log(error);
      }
    }
  }
}

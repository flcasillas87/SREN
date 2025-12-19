import { inject, Injectable, signal } from '@angular/core';
import { SupabaseService } from '@services/supabase.service';
import {
  AuthChangeEvent,
  Session,
  SignInWithPasswordCredentials,
  SignUpWithPasswordCredentials,
} from '@supabase/supabase-js';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly _supabase = inject(SupabaseService).getClient();

  private readonly _session = signal<Session | null>(null);
  private _initialized = false;

  private initOnce(): void {
    if (this._initialized) {
      return;
    }

    this._initialized = true;

    void this._supabase.auth.getSession().then(({ data }) => {
      this._session.set(data.session);
    });

    this._supabase.auth.onAuthStateChange(
      (_event: AuthChangeEvent, session: Session | null) => {
        this._session.set(session);
      },
    );
  }

  public session(): Session | null {
    this.initOnce();
    return this._session();
  }

  public async logIn(
    credentials: SignInWithPasswordCredentials,
  ) {
    console.log('[AuthService.logIn] credentials:', credentials);

    const response =
      await this._supabase.auth.signInWithPassword(credentials);

    if (response.error) {
      console.error(
        '[AuthService] Login error:',
        response.error.message,
      );
    } else {
      console.log(
        '[AuthService] Login OK:',
        response.data.user?.email,
      );
    }

    return response;
  }

  public async signUp(
    credentials: SignUpWithPasswordCredentials,
  ) {
    return this._supabase.auth.signUp(credentials);
  }

  public async signOut(): Promise<void> {
    await this._supabase.auth.signOut();
    this._session.set(null);
  }
}


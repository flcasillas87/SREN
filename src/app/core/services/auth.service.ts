import { inject,Injectable } from '@angular/core';
import { SupabaseService } from '@services/supabase.service';
import { SignUpWithPasswordCredentials } from '@supabase/supabase-js';

@Injectable({  providedIn: 'root',})

export class AuthService {

  private _supabaseClient = inject(SupabaseService).getClient();

  public session() {
    return this._supabaseClient.auth.getSession();
  }

  public signUp(credentials: SignUpWithPasswordCredentials) {
    return this._supabaseClient.auth.signUp(credentials);
  }

  public logIn(credentials: SignUpWithPasswordCredentials) {
    return this._supabaseClient.auth.signInWithPassword(credentials);
  }

  public signOut() {
    return this._supabaseClient.auth.signOut();
  }


}
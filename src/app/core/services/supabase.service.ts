import { Injectable } from '@angular/core';
import { environment } from '@env/environment';
import { createClient, SupabaseClient } from '@supabase/supabase-js';

@Injectable({ providedIn: 'root' })
export class SupabaseService {
  // Initialize the Supabase client
  private readonly _supabaseClient: SupabaseClient = createClient(environment.supabaseUrl, environment.supabaseKey);

  // Expose the Supabase client
  public getClient(): SupabaseClient {
    return this._supabaseClient;
  }
}

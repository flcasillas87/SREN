import { Injectable } from '@angular/core';
import { Firestore, collectionData, collection } from '@angular/fire/firestore';
import { AngularFirestore } from '@angular/fire/compat/firestore';
import { Observable } from 'rxjs';
import { environment } from '../../../enviroments/environment';

interface Item {
  name: string;
}

@Injectable({
  providedIn: 'root',
})
export class DataService {
  private firestore = environment.firebaseConfig;

  //Obtener Registro
  constructor(private db: AngularFirestore) {}
  getUsuarios(): Observable<any[]> {
    return this.db.collection<any>('usuarios').valueChanges();
  }
  
  //Guardar Registro
  guardarUsuario(usuario: any): Promise<any> {
    return this.db.collection('usuarios').add(usuario);
  }
  
  //Eliminar Registro
  eliminarUsuario(id: string): Promise<any> {
    return this.db.collection('usuarios').doc(id).delete();
  }


}
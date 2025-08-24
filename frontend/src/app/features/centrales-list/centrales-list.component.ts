import { Central } from '../../centrales/models/central.model';
import { CentralesService } from '../../centrales/services/centrales.service';
import { ChangeDetectionStrategy, Component, computed, DestroyRef, effect, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatTableModule } from '@angular/material/table';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'app-centrales-list',
  imports: [
    CommonModule,
    MatProgressSpinnerModule,
    MatTableModule
  ],
  templateUrl: './centrales-list.component.html', 
  styleUrl: './centrales-list.component.css'
})
export class CentralesListComponent  {

  private centralesService = inject(CentralesService);

  centrales: Central[] = [];
  displayedColumns = [
    'central_id', 'nombre', 'estado_operacion', 'tipo_central',
    'ubicacion_estado', 'ubicacion_municipio', 'capacidad_mw',
    'combustible_principal', 'combustible_secundario'
  ];
  loading = false;

  

  cargarCentrales() {

  }
}









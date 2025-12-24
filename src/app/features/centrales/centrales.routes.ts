import type { Routes } from '@angular/router';
import { CentralDetallePage } from '@centrales/pages/central-detalle/central-detalle.page';
import { CentralHistoricoPage } from '@centrales/pages/central-historico/central-historico.page';
import { CentralOperacionPage } from '@centrales/pages/central-operacion/central-operacion.page';

import { CentralesLayout } from './layout/centrales-layout/centrales-layout';

export const centralesRoutes: Routes = [
    {
        path: '',
        component: CentralesLayout,
        children: [
            { path: 'detalle', component: CentralDetallePage },
            { path: 'operacion', component: CentralOperacionPage },
            { path: 'historico', component: CentralHistoricoPage },
            { path: '', redirectTo: 'centrales', pathMatch: 'full' }
        ]
    }
];
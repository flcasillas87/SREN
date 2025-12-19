import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '@services/auth.service';


// Guard to protect routes for authenticated users
export const authGuard: CanActivateFn = async () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    const { data } = await authService.session();
    if (!data.session) {
        router.navigateByUrl('/login');
        return false;
    }
    return true;
}

// Guard to protect routes for unauthenticated users
export const publicGuard: CanActivateFn = async () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    const { data } = await authService.session();

    if (data.session) {
        router.navigateByUrl('/');
        return false;
    }

    return false;
};
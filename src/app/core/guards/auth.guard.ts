import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '@services/auth.service';

export const authGuard: CanActivateFn = () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    const session = authService.session();

    console.log('[authGuard] session:', session);

    return session
        ? true
        : router.createUrlTree(['/login']);
};

export const publicGuard: CanActivateFn = () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    const session = authService.session();

    console.log('[publicGuard] session:', session);

    return session
        ? router.createUrlTree(['/'])
        : true;
};
import { createAction, props } from '@ngrx/store';

export const setMessage = createAction('[Hello Component] Set Message', props<{ message: string }>());
export const clearMessage = createAction('[Hello Component] Clear Message');

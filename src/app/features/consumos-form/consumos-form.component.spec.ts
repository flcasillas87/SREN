import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ConsumosFormComponent } from './consumos-form.component';

describe('ConsumosFormComponent', () => {
  let component: ConsumosFormComponent;
  let fixture: ComponentFixture<ConsumosFormComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ConsumosFormComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(ConsumosFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

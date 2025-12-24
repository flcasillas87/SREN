import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CentralSelector } from './central-selector';

describe('CentralSelector', () => {
  let component: CentralSelector;
  let fixture: ComponentFixture<CentralSelector>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CentralSelector]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CentralSelector);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

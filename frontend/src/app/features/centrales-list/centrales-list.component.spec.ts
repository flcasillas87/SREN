import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CentralesList } from './centrales-list.component';

describe('CentralesList', () => {
  let component: CentralesList;
  let fixture: ComponentFixture<CentralesList>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CentralesList],
    }).compileComponents();

    fixture = TestBed.createComponent(CentralesList);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

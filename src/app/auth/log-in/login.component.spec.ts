import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AuthLogIn } from './login.component';

describe('AuthLogIn', () => {
  let component: AuthLogIn;
  let fixture: ComponentFixture<AuthLogIn>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AuthLogIn]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AuthLogIn);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

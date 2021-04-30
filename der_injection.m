function [dSinj] = der_injection(datoteka)
    ds = feval(datoteka);
  dSdg = ds.inj_size(1,1);
   phi = ds.fi_min:ds.fi_step:ds.fi_max;
switch ds.inj_type
    case 'P'
        dSinj = dSdg;
    case 'Q'
        dSinj = 1j*dSdg;
    case 'S'        
        dSinj = dSdg * (cos(phi) + 1j * sin(phi));
end
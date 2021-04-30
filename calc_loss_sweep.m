function [DP, DQ, U, Qslack, Pslack, Umax, Umin, St, iter] = calc_loss_sweep(Sdg,A,ds,NB,NL,f,Zbranch,Ysh,Sd,BusLDC,iseg)
if isempty(Sdg)
    A = 1;
    Sdg = 0;
end
row_iseg = ds.LDC(iseg,2:end);
load_factor = row_iseg(BusLDC);
if size(load_factor,1) == 1; load_factor = load_factor.'; end
Sd = Sd.*load_factor;
Sd(A) = Sd(A) - Sdg/1000/ds.Sbase;
[U, Sf, St, iter] = calc_u_pq_sum(ds.Uslack(iseg),NB,NL,f,Zbranch,Ysh,Sd,ds.tol,ds.iter_max);
DP = real(sum(Sf-St)) * ds.Sbase * 1000;
DQ = imag(sum(Sf-St)) * ds.Sbase * 1000;
Qslack = imag(Sf(1)) * ds.Sbase * 1000;
Pslack = real(Sf(1)) * ds.Sbase * 1000;
Umax = max(abs(U));
Umin = min(abs(U));
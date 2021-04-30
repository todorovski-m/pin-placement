function [NB, NL, f, t_pod, Zbranch, Ysh, Sd, BusLDC] = data_sep(ds)
        t = ds.branch(:,2);
[temp, i] = sort(t);
    t_pod = temp;
ds.branch = ds.branch(i,:);
[f, t, Zbranch, Ybranch, Sd, Qc, BusLDC] = ...
    deal(ds.branch(:,1),ds.branch(:,2), ...
         ds.branch(:,3)+1j*ds.branch(:,4),1j*ds.branch(:,5)/1e6, ...
         ds.branch(:,6)+1j*ds.branch(:,7),ds.branch(:,8),ds.branch(:,9));
     NL = size(ds.branch,1);
     NB = max([f; t]);
  Zbase = ds.Ubase^2/ds.Sbase;
 BusLDC = [1; BusLDC];
     Sd = [0; Sd]/1000/ds.Sbase;
    Ysh = [0; 1j*Qc]/1000/ds.Sbase;
     Yb = sparse(f, f, Ybranch/2, NB, NB) + sparse(t, t, Ybranch/2, NB, NB);
    Ysh = Ysh + Yb * ones(NB,1) * Zbase;
Zbranch = Zbranch / Zbase;
function [U, Sf, St, iter] = calc_u_pq_sum(Uslack,NB,NL,f,Zbranch,Ysh,Sd,epsilon,iter_max)
U = Uslack * ones(NB,1);
Uold = U;
iter = 0;
finish = 0;
%% Addition of artificial branch numerated with 1 that enables equality 
%% between branch numbers and its appropriate receiving end node numbers
      f = [0; f];
Zbranch = [0; Zbranch];
NL = NL + 1;
while finish == 0 && iter < iter_max
    iter = iter + 1;
    S = Sd + conj(Ysh).*abs(U).^2;
    St = S;
    Sf = St;
    for k = NL:-1:2
        i = f(k);
        Sf(k) = St(k) + Zbranch(k) * abs(St(k)/U(k))^2;
        St(i) = St(i) + Sf(k);
    end
    for k = 2:NL
        i = f(k);
        U(k) = U(i) - Zbranch(k) * conj(Sf(k)/U(i));
    end    
    DU = abs(U - Uold);
    if max(DU) > epsilon
        Uold = U;
        finish = 0;
    else
        finish = 1;
    end
end
Sf = Sf(2:end);
St = St(2:end);
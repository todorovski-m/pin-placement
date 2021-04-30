function print_sol_dp(fid, DP, DQ, U, Qslack, Umin, A)
U = abs(U);
fprintf(fid,'  DP(kW)  DQ(kvar)   Umin(pu)      Qslack(kvar)\n');
[Umin_i, imin] = min(U);
fprintf(fid,'%8.4f %9.4f %10.6f @%3i %12.4f\n',DP,DQ,Umin_i,imin,Qslack);
ind = find(U(A) < Umin);
if ~isempty(ind)
    fprintf(fid,'------- Low Voltages ------------------\n');
    for j = 1:length(ind)
    	fprintf(fid,'        U(%2i) = %.6f\n',A(ind(j)),U(A(ind(j))));
    end
end
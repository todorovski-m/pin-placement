function [A, Sdg, DP, DQ, U, Qslack, Pslack, Umax, Umin, iter, cp_time, Zag, Inj, maxi, lindp, ZZ] = dg_clust_dp(input_file)
%% Input read and data preparation
if nargin == 0
    input_file = 'case69';
end
%% ds-structure read
     ds = feval(input_file);
    LDC = ds.LDC(:,2);
   iseg = find(LDC == 1);
[NB, NL, f, t_pod, Zbranch, Ysh, Sd, BusLDC] = data_sep(ds);
%% Base case   
   [DP, ~, ~] = calc_loss_sweep([],[],ds,NB,NL,f,Zbranch,Ysh,Sd,BusLDC,iseg);     
   DP0 = DP; 
%% Solution check for comparison purposes
nds = [61]'; %Solution nodes
sds = [1843.992-1j*1311.221]'; %Power injections
[DP, ~, ~] = calc_loss_sweep(sds,nds,ds,NB,NL,f,Zbranch,Ysh,Sd,BusLDC,iseg);
DPx = DP;
%% Base Case Calculations
fid = fopen('dg_clust_dp.txt','w');
fprintf(fid,'%s\n',input_file);
fprintf(fid,'\n========== Base Case ===================\n');
[DP, DQ, U, Qslack] = calc_loss_sweep([],[],ds,NB,NL,f,Zbranch,Ysh,Sd,BusLDC,iseg);
print_sol_dp(fid, DP, DQ, U, Qslack, ds.Umin, t_pod);
fprintf(fid,'\n========== Base Case with Qd = 0 =========\n');
[DP, DQ, U, Qslack] = calc_loss_sweep([],[],ds,NB,NL,f,Zbranch,Ysh,real(Sd),BusLDC,iseg);
print_sol_dp(fid, DP, DQ, U, Qslack, ds.Umin, t_pod);
fprintf(fid,'\n========== Base Case with Pd = 0 =========\n');
[DP, DQ, U, Qslack] = calc_loss_sweep([],[],ds,NB,NL,f,Zbranch,Ysh,1j*imag(Sd),BusLDC,iseg);
print_sol_dp(fid, DP, DQ, U, Qslack, ds.Umin, t_pod);
%% Power Injection Selection
[dSinj] = der_injection(input_file);
%% Optimisation
locs = zeros(ds.LOC_dg,1);
dgs = zeros(ds.LOC_dg,1);
dps = zeros(ds.LOC_dg,1);
maxi = zeros(ds.LOC_dg,1);
lindp = zeros(ds.LOC_dg,1);
Zag = zeros(ds.LOC_dg,length(t_pod));
Inj = zeros(ds.LOC_dg,length(t_pod));
Itt = [];
Inn = [];
ZZ = [];
sdx = Sd;
dpx = DP0;
tic
for m = 1:ds.LOC_dg
    [DP, ~, ~, ~, ~, ~, Node, Sdg, Zagubi, Injekcii, ~, ~, zz] = Cluster(ds,dSinj,DP0,NB,NL,f,Zbranch,Ysh,sdx,BusLDC,iseg,t_pod);
    sdx(Node) = sdx(Node)-(Sdg/1000/ds.Sbase);
    locs(m) = Node;
    dgs(m) = Sdg;
    dps(m) = DP;
    maxi(m) = max(abs(Injekcii));
    lindp(m)= DP;
    Zag(m,:) = Zagubi/dpx;
    dpx = DP;
    Inj(m,:) = abs(Injekcii)/maxi(m);
    ZZ = [ZZ; zz];
end
cp_time = toc;
[DP, DQ, U, Qslack, Pslack, Umax, Umin, ~, iter] = calc_loss_sweep(dgs,locs,ds,NB,NL,f,Zbranch,Ysh,Sd,BusLDC,iseg);
A = locs;
Sdg = dgs;
%% Printing of Output Results 
fprintf(fid,'\n========== PIN Optimal Location ==========\n');
fprintf(fid,'---------- CLUSTER METHOD ---------------------\n');
fprintf(fid,'\n---------- MIN dP -----------------------------\n');
print_sol_dp(fid, DP, DQ, U, Qslack, ds.Umin, A);
fprintf(fid,'\n---------- TOTAL Sinj (kVA) -------------------\n');    
B = sum(Sdg);
s = sprintz(B,'%.4f');
fprintf(fid, '%s\n ', s);
fprintf(fid,' Bus               Sdg(kVA)\n');
for i = 1:length(A)
    if abs(Sdg(i)) > 0
        s = sprintz(Sdg(i),'%.4f');
        fprintf(fid,'%4i                %s \n',A(i),s);
    end
end
fprintf(fid,'\n');
fprintf(fid,'\nt = %.3f sec\n',cp_time);
fprintf('\nt = %.4f sec\n',cp_time);
fclose(fid);
system(['copy dg_clust_dp.txt ' input_file '_dp.txt']);
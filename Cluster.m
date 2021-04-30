function [dP, dQ, Umin, Umax, Qslack, Pslack, Node, Sdg, Zagubi, Injections, itt, inj, zz] = Cluster(ds,dSinj,DP0,NB,NL,f,Zbranch,Ysh,Sd,BusLDC,iseg,t_pod)
ds.iter_max = 1;
DP = zeros(1,length(t_pod));
DQ = zeros(1,length(t_pod));
Q_slack = zeros(1,length(t_pod));
P_slack = zeros(1,length(t_pod));
U_max = zeros(1,length(t_pod));
U_min = zeros(1,length(t_pod));
S_dg = zeros(1,length(t_pod));
Zagubi = zeros(1,length(t_pod));
Injections = zeros(1,length(t_pod));
ZZ = zeros(200,length(t_pod));
   for i = 1:length(t_pod)
       finish = false;
       p = 0;
       best = DP0;
       dp = zeros(1,length(dSinj));
       dq = zeros(1,length(dSinj));
       qslack = zeros(1,length(dSinj));
       pslack = zeros(1,length(dSinj));
       u_max = zeros(1,length(dSinj));
       u_min = zeros(1,length(dSinj));
       sdg = zeros(1,1);
       while ~finish
           p = p+1;
           for k = 1:length(dSinj)
               Sdgx = sdg;
               Sdgx = Sdgx + dSinj(k);
               [dp(1,k), dq(1,k), ~, qslack(1,k), pslack(1,k), u_max(1,k), u_min(1,k), ~] = calc_loss_sweep(Sdgx,t_pod(i),ds,NB,NL,f,Zbranch,Ysh,Sd,BusLDC,iseg);
           end
           dp(u_max > ds.Umax) = inf;
           dpmin = min(min(dp)); 
           [~,ind] = find(dp == dpmin);
           if isvector(ind)
               ind = ind(1);
           end
           if dpmin < best
               sdg = sdg + dSinj(ind);
               best = dpmin;
           else
               finish = true;
           end
           ZZ(p,i) = dpmin;
       end
       DP(i) = dp(ind);
       DQ(i) = dq(ind);
       Q_slack(i) = qslack(ind);
       P_slack(i) = pslack(ind);
       U_max(i) = u_max(ind);
       U_min(i) = u_min(ind);
       S_dg(i) = sdg;
       Zagubi(i) = DP(i);
       Injections(i) = S_dg(i);
   end
   DP_min = min(DP);
   [~,Node] = find(DP == DP_min);
  dP = DP(Node);
  dQ = DQ(Node);
  Qslack = Q_slack(Node);
  Pslack = P_slack(Node);
  Umax = U_max(Node);
  Umin = U_min(Node);
  Sdg = S_dg(Node);
  zz = nonzeros(ZZ(:,Node));
  Node = Node + 1;
  %% For Results
  finish = false;
  best = DP0;
  dp = zeros(1,length(dSinj));
  dq = zeros(1,length(dSinj));
  qslack = zeros(1,length(dSinj));
  pslack = zeros(1,length(dSinj));
  u_max = zeros(1,length(dSinj));
  u_min = zeros(1,length(dSinj));
  sdg = zeros(1,1);
  iter = 0;
  itt = [];
  inj = [];
  while ~finish
      for k = 1:length(dSinj)
          Sdgx = sdg;
          Sdgx = Sdgx + dSinj(k);
          [dp(1,k), dq(1,k), ~, qslack(1,k), pslack(1,k), u_max(1,k), u_min(1,k), ~, ~] = calc_loss_sweep(Sdgx,Node,ds,NB,NL,f,Zbranch,Ysh,Sd,BusLDC,iseg);
      end
      dp(u_max > ds.Umax) = inf;
      dpmin = min(min(dp));
      [~,ind] = find(dp == dpmin);
      if isvector(ind)
          ind = ind(1);
      end
      if dpmin < best
          sdg = sdg + dSinj(ind);
          best = dpmin;
      else
          finish = true;
      end
      iter = iter + 1;
      itt(iter) = iter;
      inj(iter) = sdg;
  end
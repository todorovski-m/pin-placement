function [t,tmin] = time(input_file,nt)
if nargin == 0
    input_file = 'case69';
end
cp_time = zeros(nt,1);
for i = 1:length(cp_time)
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, vreme, ~, ~, ~, ~, ~, ~, ~, ~] = dg_clust_dp(input_file);
    cp_time(i) = vreme;
end
t = mean(cp_time);
tmin = min(cp_time);
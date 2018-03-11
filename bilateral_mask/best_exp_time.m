function [ t_best ] = best_exp_time( I_hdr, I_std )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
I_std = I_std.^2.2;
T = I_std./I_hdr;
T(T == inf)= 0; T(isnan(T)) = 0;
w = exp(-4*(I_std - 0.5).^2/0.5^2);
t_best = sum(sum(sum(w.*T)))/sum(sum(sum(w)));

end


function [Xfit, LL, BIC] = fit_M3RescorlaWagner_depdQ_YS_bads(resp_vec,reward_vec)

obFunc = @(x) lik_M3RescorlaWagner_depdQ_YS(a, r, x(1), x(2));

X0 = [rand exprnd(1)];
LB = [0 0];
UB = [1 10^2];
[Xfit, NegLL] = bads(obFunc, X0,  LB, UB,LB,UB);




LL = -NegLL;
BIC = length(X0) * log(length(a)) + 2*NegLL;
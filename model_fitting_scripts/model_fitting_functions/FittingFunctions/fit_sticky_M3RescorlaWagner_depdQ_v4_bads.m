% function is wrapper for bads fitting
% includes fitting from multiple starting pts
% written by YS 27/3/23

function [best_Xfit, best_LL, best_BIC] = fit_sticky_M3RescorlaWagner_depdQ_v4_bads(resp_vec,reward_vec, n_start_pts)

obFunc = @(x) lik_RW_with_sticky(resp_vec, reward_vec, x(1), x(2),x(3));

rng(2)
%define Bounds of sesarch space

% these are hard bounds
LB = [0 0 -100];
UB = [1 100 100];

%plausible bounds
PLB= [0 0 -10];
PUB=[1 20 10];


%create collector variable
all_Xfit=nan(n_start_pts,length(LB));
all_X0=nan(n_start_pts,length(LB));

all_LL=nan(n_start_pts,1);
all_BIC=nan(n_start_pts,1);

for i=1:n_start_pts
try
    X0 = [rand exprnd(1) exprnd(1)];

    [Xfit, NegLL] = bads(obFunc, X0,  LB, UB,PLB,PUB);

    LL = -NegLL;
    BIC = length(X0) * log(length(resp_vec)) + 2*NegLL;

    %storing variables
    all_Xfit(i,:)=Xfit';
    all_X0(i,:)=X0';

    all_LL(i)=LL;
    all_BIC(i)=BIC;
catch
    h=9;
end
end
%choosing the best fit % need to check this may be a mistake!
[~,ind_min_LL]=min(all_LL,[],'omitnan');
best_Xfit=all_Xfit(ind_min_LL,:);
best_LL=all_LL(ind_min_LL,:);
best_BIC=all_BIC(ind_min_LL,:);

end
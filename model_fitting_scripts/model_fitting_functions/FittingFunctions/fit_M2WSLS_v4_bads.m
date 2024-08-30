function [best_Xfit, best_LL, best_BIC] = fit_M2WSLS_v4_bads(resp_vec, reward_vec,n_start_pts)

obFunc = @(x) lik_M2WSLS_v4(resp_vec, reward_vec, x);

X0 = rand;
LB = 0;
UB = 1;

PLB=0;
PUB=1;


%create collector variable
all_Xfit=nan(n_start_pts,length(LB));
all_X0=nan(n_start_pts,length(LB));

all_LL=nan(n_start_pts,1);
all_BIC=nan(n_start_pts,1);

for i=1:n_start_pts
try
    X0 = [rand];

    [Xfit, NegLL] = bads(obFunc, X0,  LB, UB,PLB,PUB);

    LL = -NegLL;
    BIC = length(X0) * log(length(resp_vec)) + 2*NegLL;

    %storing variables
    all_Xfit(i,:)=Xfit';
    all_X0(i,:)=X0';

    all_LL(i)=NegLL;
    all_BIC(i)=BIC;
catch
    h=8;
end
end
%choosing the best fit % need to check this may be a mistake!
[~,ind_min_LL]=min(all_LL,[],'omitnan');
best_Xfit=all_Xfit(ind_min_LL,:);
best_LL=all_LL(ind_min_LL,:);
best_BIC=all_BIC(ind_min_LL,:);

end



function [BIC, iBEST, BEST] = fit_all_YS(a, r)

[~, ~, BIC(1)] = fit_M2WSLS_v4_bads(a, r,1);
[~, ~, BIC(2)] = fit_M3RescorlaWagner_depdQ_v4_bads(a, r,1);
[~, ~, BIC(3)] = fit_sticky_M3RescorlaWagner_depdQ_v4_bads(a,r,1);

[M, iBEST] = min(BIC);
BEST = BIC == M;
BEST = BEST / sum(BEST);
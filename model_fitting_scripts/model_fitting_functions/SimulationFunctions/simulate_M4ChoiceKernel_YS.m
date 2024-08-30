%adapted by YS
%27.2.23
%% INPUT
%stim_vec: vector with stimulus (coded in cntngcy space, values 1/2)
% alpha_c : double ranging from 0-1. learning rate of choice kernel
% beta_c: double (0-Inf) inverse temperature of choice 


function [a, r] = simulate_M4ChoiceKernel_YS(stim_vec, alpha_c, beta_c)

CK = [0 0];

T=length(stim_vec);

for t = 1:T
    
    % compute choice probabilities
    p = exp(beta_c*CK) / sum(exp(beta_c*CK));
    
    % make choice according to choice probababilities
    a(t) = choose(p);
    
     % generate reward based on choice& stimulus congruency
    if (a(t)==stim_vec(t))
        r(t) = 1;
    else
        r(t)=0;
    end
    
    % update choice kernel
    CK = (1-alpha_c) * CK;
    CK(a(t)) = CK(a(t)) + alpha_c * 1;
            
    
end

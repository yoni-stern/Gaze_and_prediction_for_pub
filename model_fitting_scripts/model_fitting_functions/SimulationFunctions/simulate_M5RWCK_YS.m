%adapted by YS
%27.2.23
%% INPUT
%stim_vec: vector with stimulus (coded in cntngcy space, values 1/2)
% alpha : double ranging from 0-1. learning rate of Q
% Beta: double (0-Inf) inverse temperature of Q updating
% alpha_c : double ranging from 0-1. learning rate of choice kernel
% beta_c: double (0-Inf) inverse temperature of choice 


function [a, r] = simulate_M5RWCK_YS(stim_vec, alpha, beta, alpha_c, beta_c)

T=length(stim_vec);


Q = [0.5 0.5];
CK = [0 0];

for t = 1:T
    
    % compute choice probabilities
    V = beta * Q + beta_c * CK;
    p = exp(V) / sum(exp(V));
                
    % make choice according to choice probababilities
    a(t) = choose(p);
    
     % generate reward based on choice& stimulus congruency
    if (a(t)==stim_vec(t))
        r(t) = 1;
    else
        r(t)=0;
    end

    
    % update values
    delta = r(t) - Q(a(t));
    Q(a(t)) = Q(a(t)) + alpha * delta;

    % update choice kernel
    CK = (1-alpha_c) * CK;
    CK(a(t)) = CK(a(t)) + alpha_c * 1;
            
    
end

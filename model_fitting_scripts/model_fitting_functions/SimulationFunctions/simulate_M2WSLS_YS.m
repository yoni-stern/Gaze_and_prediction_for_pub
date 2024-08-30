%adapted by YS
%27.2.23
%% INPUT
%stim_vec: vector with stimulus (coded in cntngcy space, values 1/2)
% epsilon : double ranging from 0-1. This is degree of random choosing. 

function [a, r] = simulate_M2WSLS_YS(stim_vec, epsilon)

T=length(stim_vec);

% last reward/action (initialize as nan)
rLast = nan;
aLast = nan;

for t = 1:T
    
    % compute choice probabilities
    if isnan(rLast)
        
        % first trial choose randomly
        p = [0.5 0.5];
        
    else
        
        % choice depends on last reward
        if rLast == 1
            
            % win stay (with probability 1-epsilon)
            p = epsilon/2*[1 1];
            p(aLast) = 1-epsilon/2;
            
        else
            
            % lose shift (with probability 1-epsilon)
            p = (1-epsilon/2) * [1 1];
            p(aLast) = epsilon / 2;
            
        end
    end
    
    % make choice according to choice probababilities
    a(t) = choose(p);
    
    % generate reward based on choice& stimulus congruency
    if (a(t)==stim_vec(t))
        r(t) = 1;
    else
        r(t)=0;
    end
    
    
    aLast = a(t);
    rLast = r(t);
end

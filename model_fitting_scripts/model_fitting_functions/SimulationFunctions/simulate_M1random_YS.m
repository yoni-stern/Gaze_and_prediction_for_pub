%adapted by YS
%27.2.23
%% INPUT
%stim_vec: vector with stimulus (coded in cntngcy space, values 1/2)
% b : double ranging from 0-1. This is the bias in choosing one option
function [a, r] = simulate_M1random_YS(stim_vec,b)

T=length(stim_vec);
for t = 1:T
    
    % compute choice probabilities
    p = [b 1-b];
    
    % make choice according to choice probababilities
    a(t) = choose(p);
    
    % generate reward based on choice
    if (a(t)==stim_vec(t))
        r(t) = 1;
    else
        r(t)=0;
    end
    
end

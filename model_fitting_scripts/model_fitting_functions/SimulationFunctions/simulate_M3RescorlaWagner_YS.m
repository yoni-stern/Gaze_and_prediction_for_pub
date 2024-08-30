%adapted by YS
%27.2.23
%% INPUT
%stim_vec: vector with stimulus (coded in cntngcy space, values 1/2)
% alpha : double ranging from 0-1. learning rate.
% Beta: double (0-Inf) inverse temperature


function [a, r,traj_struct] = simulate_M3RescorlaWagner_YS(stim_vec, alpha, beta)
%initial values 
Q = [0.5 0.5];

T=length(stim_vec);

%make collector variable

traj_struct.delta=nan(1,T);
traj_struct.p=nan(1,T);
traj_struct.q=nan(1,T);

for t = 1:T
    
    % compute choice probabilities
    p = exp(beta*Q) / sum(exp(beta*Q));
    
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

    %storing all the trial by trial trajectories
    traj_struct.delta(t)=delta;
    traj_struct.p(t)=p(a(t));
    traj_struct.q(t)=Q(a(t));


end


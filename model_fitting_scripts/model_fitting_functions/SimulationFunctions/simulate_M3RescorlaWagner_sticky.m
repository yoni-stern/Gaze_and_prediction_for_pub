%adapted by YS
%27.2.23
%% INPUT
%stim_vec: vector with stimulus (coded in cntngcy space, values 1/2)
% alpha : double ranging from 0-1. learning rate.
% Beta: double (0-Inf) inverse temperature


function [resp_vec, reward_vec,all_q1,all_delta] = simulate_M3RescorlaWagner_sticky(stim_vec, alpha, beta,rho)
%initial values 
Q = [0.5 0.5];

T=length(stim_vec);

%make collector variable
resp_vec=nan(1,T);

reward_vec=nan(1,T);

all_delta=nan(1,T);

all_q1=nan(1,T);

for t = 1:T
    if t>1
    % 1. give value of 1 to choice that is repitiotion of previous trial
    rep_vec=[0,0];
    rep_vec(resp_vec(t-1))= 1; %choice that was made on previous trial is given value of 1
    else
       rep_vec=[0,0];
    end
    

    % 2. compute choice probabilities
    %with stickiness parameter and repition value
    p = exp(beta*Q + rho*rep_vec) / sum(exp(beta*Q+rho*rep_vec));
    
    
    % make choice according to choice probababilities
    resp_vec(t) = choose(p);
    
     % generate reward based on choice& stimulus congruency
    if (resp_vec(t)==stim_vec(t))
        reward_vec(t) = 1;
    else
        reward_vec(t)=0;
    end
    
    % update values
    delta = reward_vec(t) - Q(resp_vec(t));
    Q(resp_vec(t)) = Q(resp_vec(t)) + alpha * delta;
% updating the Q not chosen so that Q1 + Q2 =1
    Q([1,2]~=resp_vec(t))=1-Q(resp_vec(t));
    
    %storing all the trial by trial trajectories of Q and delta
    all_q1=Q(1);
    all_delta=delta;


end


%% script that works best- 240323

%adapted by YS 23/03/23 using stim vec
%adapted for URI 
% has bug fix using resp & reward vectors YS
%EXTRACT_TRAJ_M3RESCORLAWAGNER_YS 
%function extracts the trial by trail Q and delta

function [traj_struct] = extract_traj_M3RescorlaWagner_depdQ_v4(resp_vec, stim_vec,alpha, beta)



T=length(resp_vec);

%make collector variable

traj_struct.delta=nan(T,1);
traj_struct.p=nan(T,1);
traj_struct.p_choice=nan(T,1);

traj_struct.q=nan(T,1);

%initial values
Q=[.5,.5];


for t = 1:T

    % compute choice probabilities
    p = exp(beta*Q) / sum(exp(beta*Q));

    delta = stim_vec(t) - Q(resp_vec(t));

    %storing values


    traj_struct.delta(t)=delta;
    traj_struct.p_choice(t)=p(resp_vec(t));
    traj_struct.p(t)=p(1);

%     traj_struct.q(t)=Q(resp_vec(t));
    traj_struct.q(t)=Q(1);

    %updating
    Q(resp_vec(t)) = Q(resp_vec(t)) + alpha * delta;

    %updating the other Q so that sum is 1
    Q([1,2]~=resp_vec(t))=1-Q(resp_vec(t));

%     delta = 1-stim_vec(t) - Q(3-resp_vec(t));
% Q(3-resp_vec(t)) = Q(3-resp_vec(t)) + alpha * delta;

%    
end
end




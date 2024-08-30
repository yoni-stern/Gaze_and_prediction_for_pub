%% Updated by YS 22/1/24 to include unpacking function so that output of function is table
%% script that works best- 240323

%adapted by YS 23/03/23 using stim vec
%adapted for URI 
% has bug fix using resp & reward vectors YS
%EXTRACT_TRAJ_M3RESCORLAWAGNER_YS 
%function extracts the trial by trail Q and delta

function [traj_tbt] = extract_traj_StickyRescorlaWagner_depdQ_v5(resp_vec, reward_vec,alpha, beta,rho)



T=length(resp_vec);



tbl_col_names=["q";"delta";"prev_delta";"p";"p_choice"];


traj_tbt=array2table(nan(T,length(tbl_col_names)),'VariableNames',tbl_col_names);

%initial values
Q=[.5,.5];



for t = 1:T

    % getting repition vector
    if t>1
    % 1. give value of 1 to choice that is repitiotion of previous trial
    rep_vec=[0,0];
    rep_vec(resp_vec(t-1))= 1; %choice that was made on previous trial is given value of 1
    else
       rep_vec=[0,0];
    end

    % compute choice probabilities
    %with stickiness parameter and repition value
    p = exp(beta*Q + rho*rep_vec) / sum(exp(beta*Q+rho*rep_vec));

    % 3. extract the choice probability for choice actually made
    choiceProb(t) = p(resp_vec(t));
    delta = reward_vec(t) - Q(resp_vec(t));

    %storing values


    traj_tbt.delta(t)=delta;
    traj_tbt.p_choice(t)=p(resp_vec(t));
    traj_tbt.p(t)=p(1);

%     traj_struct.q(t)=Q(resp_vec(t));
    traj_tbt.q(t)=Q(1);

    %updating
    Q(resp_vec(t)) = Q(resp_vec(t)) + alpha * delta;

    %updating the other Q so that sum is 1
    Q([1,2]~=resp_vec(t))=1-Q(resp_vec(t));


   

    
end

%create prev delta
traj_tbt.prev_delta=[nan;abs(traj_tbt.delta(1:end-1))];
%store the stimulus & response
traj_tbt.reward_vec=reward_vec;
sub_resp_vec=resp_vec;
sub_resp_vec(sub_resp_vec==2)=0;
traj_tbt.resp_vec=sub_resp_vec;

end




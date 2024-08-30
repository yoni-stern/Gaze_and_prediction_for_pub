function     [sub_all_traj_tbl]=adhoc_extract_traj_wrapper(sub_tbt,sub_param);

%This is an adhoc script to re extract the trajectory of RW and RW sticky
%written by YS 15/2/24

% the logic is  that we do extraction twice once for response & once for
% eyes

%% explicit responses
% Define here that stim & response are the explicit response!!!
sub_stim_vec=sub_tbt.stim_cntgncy;
sub_resp_vec=sub_tbt.resp_cntgncy;

%Step 1:
%recode 0 into 2

sub_stim_vec( sub_stim_vec==0)=2;  sub_resp_vec( sub_resp_vec==0)=2;

%calculate reward vector
sub_reward_vec=sub_resp_vec==sub_stim_vec;

%Step 2 extract explicit parameters
% for RW
RW_alpha=sub_param.("expl.RW_alpha"); RW_beta=sub_param.("expl.RW_beta");

%for sticky RW
RWS_alpha=sub_param.("expl.RWS_alpha"); RWS_beta=sub_param.("expl.RWS_beta");
RWS_rho=sub_param.("expl.RWS_rho");

%Step 3 extract trajectory for RW
[expl_RW_traj_tbt] = extract_traj_M3RescorlaWagner_depdQ_v5(sub_resp_vec, sub_reward_vec,RW_alpha, RW_beta);
%adding prefix
expl_RW_traj_tbt.Properties.VariableNames=strcat("expl.RW",".",expl_RW_traj_tbt.Properties.VariableNames);

% Step 4 extract trajectory for RWS
[expl_RWS_traj_tbt] = extract_traj_StickyRescorlaWagner_depdQ_v5(sub_resp_vec, sub_reward_vec,RWS_alpha, RWS_beta,RWS_rho);
%adding prefix
expl_RWS_traj_tbt.Properties.VariableNames=strcat("expl.RWS",".",expl_RWS_traj_tbt.Properties.VariableNames);


%% Doing Same for Eyes

% Define here that stim & response are the EYE response!!!
sub_stim_vec=sub_tbt.stim_cntgncy;
sub_resp_vec=sub_tbt.eye_resp_cntgncy;

%Step 1:
%recode 0 into 2

sub_stim_vec( sub_stim_vec==0)=2;  sub_resp_vec( sub_resp_vec==0)=2;

%calculate reward vector
sub_reward_vec=sub_resp_vec==sub_stim_vec;

%Step 2 extract EYE parameters
% for RW
RW_alpha=sub_param.("eye.RW_alpha"); RW_beta=sub_param.("eye.RW_beta");

%for sticky RW
RWS_alpha=sub_param.("eye.RWS_alpha"); RWS_beta=sub_param.("eye.RWS_beta");
RWS_rho=sub_param.("eye.RWS_rho");

%Step 3 extract trajectory for RW
[eye_RW_traj_tbt] = extract_traj_M3RescorlaWagner_depdQ_v5(sub_resp_vec, sub_reward_vec,RW_alpha, RW_beta);
%adding prefix
eye_RW_traj_tbt.Properties.VariableNames=strcat("eye.RW",".",eye_RW_traj_tbt.Properties.VariableNames);

% Step 4 extract trajectory for RWS
[eye_RWS_traj_tbt] = extract_traj_StickyRescorlaWagner_depdQ_v5(sub_resp_vec, sub_reward_vec,RWS_alpha, RWS_beta,RWS_rho);
%adding prefix
eye_RWS_traj_tbt.Properties.VariableNames=strcat("eye.RWS",".",eye_RWS_traj_tbt.Properties.VariableNames);

%% Step 3 concating all the tables

sub_all_traj_tbl=[expl_RW_traj_tbt,expl_RWS_traj_tbt,eye_RW_traj_tbt,eye_RWS_traj_tbt];
end
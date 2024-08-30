function [param_tbl,RW_traj_tbl] = model_fit_wrapper(sub_stim_vec,sub_resp_vec,n_fit_rep,col_name_prefix)
% Wrapper function to do all of model fit
% Written by YS 18/1/24


%Step 1:
%recode 0 into 2

sub_stim_vec( sub_stim_vec==0)=2;  sub_resp_vec( sub_resp_vec==0)=2;

%calculate reward vector
sub_reward_vec=sub_resp_vec==sub_stim_vec;

%% %Fitting RW% %%%%

%Step 2: fitting RW currently using BADS (this automaticaly chooses the
%best fit out of all the iterations)
[RW_param, LL_RW, BIC_RW] = fit_M3RescorlaWagner_depdQ_v4_bads(sub_resp_vec, sub_reward_vec,n_fit_rep);

%Step 3: extracting tbt RW trajectory from winning model fit-add unpacker
%here 
RW_traj_tbl = extract_traj_M3RescorlaWagner_depdQ_v5(sub_resp_vec, sub_reward_vec,RW_param(1), RW_param(2)); 

%% Fitting WinStayLoseSwitch
% Step 4: fit WSLS %add a try catch phrase
[WSLS_param, LL_WSLS, BIC_WSLS] = fit_M2WSLS_v4_bads(sub_resp_vec,sub_reward_vec,n_fit_rep);

%step 5: add a function to extract trajectory?
%% Fitting sticky
[RWS_param, LL_RWS, BIC_RWS] = fit_sticky_M3RescorlaWagner_depdQ_v4_bads(sub_resp_vec, sub_reward_vec,n_fit_rep);

%% Step 6: Model comparison

% if (min(BIC_RW,BIC_WSLS)==BIC_RW)
%     best_model="RW";
% elseif(min(BIC_RW,BIC_WSLS)==BIC_WSLS)
%     best_model="WSLS";
% end

if (min([BIC_RW,BIC_WSLS,BIC_RWS])==BIC_RW)
    best_model="RW";
elseif(min([BIC_RW,BIC_WSLS,BIC_RWS])==BIC_WSLS)
    best_model="WSLS";
elseif(min([BIC_RW,BIC_WSLS,BIC_RWS])==BIC_RWS)
    best_model="RWS";
end
%% step 7 exporting to table
%Step 7a: export the parameters
% param_tbl=table(RW_param(1), RW_param(2),LL_RW,BIC_RW,...
%     WSLS_param,BIC_WSLS,LL_WSLS,best_model,...
%     'VariableNames',["RW_alpha","RW_beta","RW_LL","RW_BIC","WSLS_eps","WSLS_BIC","WSLS_LL","Win_model"]);

param_tbl=table(RW_param(1), RW_param(2),LL_RW,BIC_RW,...
    WSLS_param,BIC_WSLS,LL_WSLS,best_model,...
    RWS_param(1), RWS_param(2),RWS_param(3),LL_RWS,BIC_RWS,...
    'VariableNames',["RW_alpha","RW_beta","RW_LL","RW_BIC",...
        "WSLS_eps","WSLS_BIC","WSLS_LL","Win_model"...
        "RWS_alpha","RWS_beta","RWS_rho","RWS_LL","RWS_BIC"]);

% Step 7b: adding source prefix
param_tbl.Properties.VariableNames=strcat(col_name_prefix,".",param_tbl.Properties.VariableNames);
RW_traj_tbl.Properties.VariableNames=strcat(col_name_prefix,".",RW_traj_tbl.Properties.VariableNames);

end
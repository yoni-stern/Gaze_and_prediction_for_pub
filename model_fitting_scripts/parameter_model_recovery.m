%% Script for parameter & model recovery
% This is script for parameter recovery for SM


%%  sourcing functions

% adding function path
% Determine where your m-file's folder is.
folder = fileparts(which(matlab.desktop.editor.getActiveFilename));
% Add that folder plus all subfolders to the path.
addpath(genpath(pwd()));

%add Colin & Wilson's function (functions with ending YS are adapted by me)
addpath(genpath("../TenSimpleRulesModeling-master"))

%add HGF functions
addpath(genpath("../../my_HGF_scripts"))
% load parameter file

addpath("preprocessing_functions")

%% load files
%currently using root file location
path_tbt_input="/Users/yonistern/Documents/GitHub/WTB_for_publication/WTB_for_pub/processed_csv/exp_combined";

% path_tbt_input="/Users/yonistern/Documents/YONI_BACKUP/WTB_article/data_for_publication/processed_csv/exp_combined";
path_pp_functions="preprocessing_functions";
%loading file that contains all data
fname_wtb_tbt_csv="all_exp_mean_gz_tbt_all_sub_210923.csv";


fname_prereg_wtb_tbt_csv="all_exp_mean_gz_tbt_only_prereg_ss_trials_210923.csv";

%loading trial by trial table- Explicit responses (this should have all
%trials for all subjects) & Eye response
tbt_wtb_csv_all_exp=readtable(fullfile(path_tbt_input,fname_wtb_tbt_csv));
% pre reg subjects
prereg_tbt_wtb_csv_=readtable(fullfile(path_tbt_input,fname_prereg_wtb_tbt_csv));

%% some clean up for files

%filter out trial 160
tbt_wtb_csv_all_exp(tbt_wtb_csv_all_exp.TrialNumber==160,:)=[];

%  Extract only prereg subjects
sub_name_vec=unique(prereg_tbt_wtb_csv_.sub_name);

% %select relevant experiments
% tbt_wtb_csv=tbt_wtb_csv_all_exp(tbt_wtb_csv_all_exp.exp_name=="exploration"|tbt_wtb_csv_all_exp.exp_name=="replication",:);
%currently analyzng all experiments
tbt_wtb_csv=tbt_wtb_csv_all_exp;



%%This is SUPER IMPORTANT!!! ALL OF SUBJECTS ORDER IS BASED ON THIS!!!
%%(Shitty matlab :(  )


% get # of subjects
n_sub=length(sub_name_vec);

%% generate random numbers to simulate & recover
%DEFINE HERE NUMBER OF SIMULATIONS
N_sim=1000;

%%RW
%alpha
rw_alpha_int=[0,1];
rw_alpha_sim = rw_alpha_int(1) + (rw_alpha_int(2)-rw_alpha_int(1)).*rand(N_sim,1);

rw_beta_int=[0,20];
rw_beta_sim = rw_beta_int(1) + (rw_beta_int(2)-rw_beta_int(1)).*rand(N_sim,1);

%RWS
%alpha
rws_alpha_int=[0,1];
rws_alpha_sim = rws_alpha_int(1) + (rws_alpha_int(2)-rws_alpha_int(1)).*rand(N_sim,1);
%beta
rws_beta_int=[0,20];
rws_beta_sim = rws_beta_int(1) + (rws_beta_int(2)-rws_beta_int(1)).*rand(N_sim,1);
%rho
rws_rho_int=[-10,10];
rws_rho_sim = rws_rho_int(1) + (rws_rho_int(2)-rws_rho_int(1)).*rand(N_sim,1);

%WSLS
wsls_epsilon_int=[0,1];
wsls_epsilon_sim=wsls_epsilon_int(1) + (wsls_epsilon_int(2)-wsls_epsilon_int(1)).*rand(N_sim,1);

% choose subject(trial sequence))
sub_sim=randi(n_sub,N_sim,1);

% Collector variables
rec_rw_Xfit=nan(N_sim,2);

rec_rws_Xfit=nan(N_sim,3);



%% Rough Draft parameter recovery
for sim_num=1:N_sim
    
    %Step 1: getting stimulus vector
    sub_name=sub_name_vec{sub_sim(sim_num)};
    sub_tbt=tbt_wtb_csv(strcmp(tbt_wtb_csv.sub_name,sub_name),:);

    %making sure that trials are in correct order
    sub_tbt=sortrows(sub_tbt,"TrialNumber");

    sub_stim_vec=sub_tbt.stim_cntgncy;
    sub_stim_vec( sub_stim_vec==0)=2;

    
    %% Step 2: simulate RW
    resp_vec=[];reward_vec=[];
    %simulate
    [resp_vec, reward_vec] =simulate_M3RescorlaWagner_v4(sub_stim_vec, rw_alpha_sim(sim_num), rw_beta_sim(sim_num));
    % recover
    [rec_rw_Xfit(sim_num,:)] = fit_M3RescorlaWagner_depdQ_v4_bads(resp_vec,reward_vec, 1);
    
    %% Step 3: RWS
    resp_vec=[];reward_vec=[];
    %simulate
    [resp_vec, reward_vec] =simulate_M3RescorlaWagner_sticky(sub_stim_vec, rws_alpha_sim(sim_num), rws_beta_sim(sim_num),rws_rho_sim(sim_num));
    % recover
    [rec_rws_Xfit(sim_num,:)] = fit_sticky_M3RescorlaWagner_depdQ_v4_bads(resp_vec,reward_vec, 1);
    
    %% Step 4: WSLS
    resp_vec=[];reward_vec=[];

    [resp_vec, reward_vec] =simulate_M2WSLS_YS(sub_stim_vec, wsls_epsilon_sim(sim_num));

    [rec_wsls_Xfit(sim_num,:)] = fit_M2WSLS_v4_bads(resp_vec, reward_vec,1);



    
end

%% Exporting
%make into table
parameter_recovery_tbl=table(rw_alpha_sim,rw_beta_sim,rec_rw_Xfit(:,1),rec_rw_Xfit(:,2), ...
    rws_alpha_sim,rws_beta_sim,rws_rho_sim,rec_rws_Xfit(:,1),rec_rws_Xfit(:,2),rec_rws_Xfit(:,3), ...
    wsls_epsilon_sim,rec_wsls_Xfit,...
    'VariableNames',["sim_RW_alpha","sim_RW_beta","rec_RW_alpha","rec_RW_beta"...
    "sim_RWS_alpha","sim_RWS_beta","sim_RWS_rho","rec_RWS_alpha","rec_RWS_beta","rec_RWS_rho"...
    "sim_WSLS_eps","rec_WSLS_eps"]);

path_export=fullfile("/Users/yonistern/Documents/GitHub/WTB_for_publication/WTB_for_pub/processed_csv/exp_combined","parameter_model_recovery_files");

writetable(parameter_recovery_tbl,fullfile(path_export,"parameter_recovery_120824.csv"))


%% Parameter recovery

 
% initialize collector variable
CM = zeros(3);

for count = 1:1000
    
%Step 1: getting stimulus vector
    sub_name=sub_name_vec{sub_sim(count)};
    sub_tbt=tbt_wtb_csv(strcmp(tbt_wtb_csv.sub_name,sub_name),:);

    %making sure that trials are in correct order
    sub_tbt=sortrows(sub_tbt,"TrialNumber");

    sub_stim_vec=sub_tbt.stim_cntgncy;
    sub_stim_vec( sub_stim_vec==0)=2;
    

    % Model 1:WSLS
    epsilon = rand;
    [a, r] = simulate_M2WSLS_YS(sub_stim_vec, epsilon);
    [BIC, iBEST, BEST] = fit_all_YS(a, r);
    CM(1,:) = CM(1,:) + BEST;
    
    
    % Model 2: RW
    alpha = rand;
    beta = 1+exprnd(1);
    [a, r] = simulate_M3RescorlaWagner_YS(sub_stim_vec, alpha, beta);
    [BIC, iBEST, BEST] = fit_all_YS(a, r);
    CM(2,:) = CM(2,:) + BEST;
    
    % Model 3
    alpha_s = rand;
    beta_s = 1+exprnd(1);
    rho_s=1+exprnd(1);
    [a, r] = simulate_M3RescorlaWagner_sticky(sub_stim_vec, alpha_s, beta_s,rho_s);
    [BIC, iBEST, BEST] = fit_all_YS(a, r);
    CM(3,:) = CM(3,:) + BEST;
    
    
end

figure(1); clf;
    FM = round(100*CM/sum(CM(1,:)))/100;
    t = imageTextMatrix(FM);
    set(t(FM'<0.3), 'color', 'w')
    hold on;
    [l1, l2] = addFacetLines(CM);
    set(t, 'fontsize', 22)
%     title(['count = ' num2str(count)]);
    set(gca, 'xtick', [1:3],'xticklabels', ["WSLS","RW","sRW"], 'ytick', [1:3],'yticklabels',["WSLS","RW","sRW"], 'fontsize', 28, ...
        'xaxislocation', 'top', 'tickdir', 'out')
    xlabel('fit model')
    ylabel('simulated model')
    
    
    drawnow

   mdl_recovery_tbl=table(CM(:,1),CM(:,2),CM(:,3),...
    'VariableNames',["WSLS","RW","sRW"],'RowNames',["rec_WSLS","rec_RW","rec_sRW"]);

    writetable( mdl_recovery_tbl,fullfile(path_export,"model_recovery_120824.csv"))

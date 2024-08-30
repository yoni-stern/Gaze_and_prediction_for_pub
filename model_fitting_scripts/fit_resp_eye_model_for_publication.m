%% Script for comapring explicit and eye Response
% This is posthoc script that attempts to recreate the results previously
% obtained using the final processed csv (for publication)
% "all_exp_mean_gz_tbt_all_sub_210923.csv"


%%  sourcing functions

% adding function path
% Determine where your m-file's folder is.
folder = fileparts(which(matlab.desktop.editor.getActiveFilename));
% Add that folder plus all subfolders to the path.
addpath(genpath(pwd()));

%add Colin & Wilson's function (functions with ending YS are adapted by me)
% addpath(genpath("../TenSimpleRulesModeling-master"))
addpath(genpath("model_fitting_functions"))
%add HGF functions
% addpath(genpath("../../my_HGF_scripts"))
% load parameter file

addpath("preprocessing_functions")

%% load files
%currently using root file location. Modify according to location

path_tbt_input="/Users/yonistern/Documents/GitHub/WTB_for_publication/WTB_for_pub/processed_csv/exp_combined";

% path_tbt_input="/Users/yonistern/Documents/YONI_BACKUP/WTB_article/data_for_publication/processed_csv/exp_combined";
path_pp_functions="preprocessing_functions";
%loading file that contains all data
fname_wtb_tbt_csv="all_exp_mean_gz_tbt_all_sub_290824.csv";

%loading trial by trial table- Explicit responses (this should have all
%trials for all subjects) & Eye response
tbt_wtb_csv_all_exp=readtable(fullfile(path_tbt_input,fname_wtb_tbt_csv));



%% some clean up for files

%filter out trial 160
tbt_wtb_csv_all_exp(tbt_wtb_csv_all_exp.TrialNumber==160,:)=[];

% %select relevant experiments
% tbt_wtb_csv=tbt_wtb_csv_all_exp(tbt_wtb_csv_all_exp.exp_name=="exploration"|tbt_wtb_csv_all_exp.exp_name=="replication",:);

%currently analyzng all experiments
tbt_wtb_csv=tbt_wtb_csv_all_exp;
% Figure out how to extract only relevant subjects!!!!



%%This is SUPER IMPORTANT!!! ALL OF SUBJECTS ORDER IS BASED ON THIS!!!
%%(Shitty matlab :(  )

sub_name_vec=unique(tbt_wtb_csv.sub_name,'stable'); %make sure that extraction of subject names maintains order that subjects appear in csv
% get # of subjects
n_sub=length(sub_name_vec);


n_trials=159;

%% Replacing missig eye data
%%% In cases where there was no eye data we replace the eye "response" with
%%% the explicit response. This is also done for accuracy and contingcncy
%%% coding
filled_eye_tbt=table();

% filling in missing eye resp with explicit response
for sub_num=1:length(sub_name_vec)
    % get subject's table
    sub_name=sub_name_vec{sub_num};

    %     sub_tbt_eyes=tbt_eyes_wtb_csv(strcmp(tbt_eyes_wtb_csv.sub_name,sub_name),:);

    sub_tbt=tbt_wtb_csv(strcmp(tbt_wtb_csv.sub_name,sub_name),:);

    sub_fill_eye_tbt=fill_eye_resp(sub_tbt);

    %     sub_fill_eye_tbt=join_eye_resp2tbt_tbl(sub_tbt,sub_tbt_eyes);

    filled_eye_tbt=[filled_eye_tbt;sub_fill_eye_tbt];

end

%% Modeling explicit response & eye response
n_fit_rep=10;
%Creating collector variables

%this stores each subject parameters
all_sub_param_tbl=table();
%trial by trial trajectory
all_sub_RW_traj_tbl=table();

for sub_num=1:length(sub_name_vec)
    
    %Step 1: get subject's table
    sub_name=sub_name_vec{sub_num};
    sub_tbt=filled_eye_tbt(strcmp(filled_eye_tbt.sub_name,sub_name),:);
    
    %making sure that trials are in correct order
    sub_tbt=sortrows(sub_tbt,"TrialNumber");

    %Step 2: fitting explicit responses
    [sub_expl_param_tbl,sub_expl_RW_traj_tbl]=model_fit_wrapper(sub_tbt.stim_cntgncy,sub_tbt.resp_cntgncy,n_fit_rep,"expl");
    
    %Step 3: fitting eye_responses
    [sub_eye_param_tbl,sub_eye_RW_traj_tbl]=model_fit_wrapper(sub_tbt.stim_cntgncy,sub_tbt.eye_resp_cntgncy,n_fit_rep,"eye");

    %Step 4: joining together: sub_name,explicit and 
sub_param_tbl=[table({sub_name},'VariableNames',"sub_name"),sub_expl_param_tbl,sub_eye_param_tbl];

sub_traj_tbl=[table(repelem({sub_name},height(sub_eye_RW_traj_tbl),1),sub_tbt.stim_cntgncy,'VariableNames',["sub_name","stim_cntgncy"]),sub_expl_RW_traj_tbl,sub_eye_RW_traj_tbl];
  
%Step 5: Concating
all_sub_param_tbl=[all_sub_param_tbl;sub_param_tbl];

all_sub_RW_traj_tbl=[all_sub_RW_traj_tbl;sub_traj_tbl];

end

%% Exporting
writetable(all_sub_param_tbl,"all_exp_n_sub_param_tbl_240124.csv")

writetable(all_sub_RW_traj_tbl,"all_exp_n_sub_RW_traj_tbl_240124.csv")


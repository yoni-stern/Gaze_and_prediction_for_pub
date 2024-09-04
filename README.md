# Gaze_and_prediction_for_pub
 Repository for ‘Eye Know’: Gaze reflects confidence in explicit predictions while relying on a distinct computational mechanism  paper

Read Me for Data & Analysis Scripts 
‘Eye Know’: Gaze reflects confidence in explicit predictions while relying on a distinct computational mechanism  

Yonatan Stern, Ophir Netzer, Danny Koren, Yair Zvilichovsky, Uri Hertz, Roy Salomon

**Data**

All data csvs needed for scripts can be downloaded from OSF. 
To run scripts as are, they need to be placed in sub_folder “processed_csv” (or modify parameter ‘path_processed_csv” in parameter file. 

*Data files description*

“Exp_combined” folder contains main data files
-	“all_exp_mean_gz_tbt_only_prereg_ss_trials_290824.csv”: contains only subjects and trials that pass pre-reg criteria. Main data file
-	“all_exp_mean_gz_tbt_all_sub_290824.csv”: contains all subjects and trials (used primarily for fig S1 & S2 & for model fitting where consecutive trials are needed)
-	“all_exp_slim_trkr_only_prereg_ss_trials_290824.csv”: contains time course (from 0-300 msec) data with gaze direction. This is primarily used for fig 2A left. 
“parameter_recovery” folder has csvs that are BADS output for parameter & model recovery

*Column names description (important cols.)*

•	m_gz: Trial’s mean normalized gaze in 300 msec interval. Normalization was done across 300 msec interval across all trials per Ss
•	m_pred_gz: Trial’s Gaze Prediction
•	eye_resp: Ocular “response”. 
•	QuestionResult: explicit prediction
•	Stim/resp_cntgncy: stimulus/response coded in continency space. 
•	Following col “is_trial_valid” are model columns. Their format is “source.ModelName.parametr/trajectory. For example “expl.RW.prev_delta” is the trial’s explicit response’s RW model’s previous delta. 

**Analysis scripts**

•	“figs_and_stats_for_publication_final.Rmd”: is main markdown that contains all analysis. It’s organized according to figures. See it’s html output. (Note written on mac)
•	Function folder contains in-house functions and parameter file. 
Model Fitting
•	“fit_resp_eye_model_for_publication.m”: is main script for fitting. Fitting logic is inspired and adapted from (Wilson & Collins, 2019) utilizing BADS (Acerbi & Ji, 2017) for the parameter estimation. 


![image](https://github.com/user-attachments/assets/25468879-3d44-4fbb-a1e1-9c48c94c1fea)

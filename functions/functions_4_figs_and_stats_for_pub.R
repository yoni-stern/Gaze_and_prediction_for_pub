## Functions for figs & stats for publication
#written by YS 01/10/23

one_sample_ttest_cohen_d<-function(value_vec){
  as.vector(value_vec)
  Mean = mean(value_vec,na.rm=TRUE)
  Mu   = 0
  Sd   = sd(value_vec,na.rm=TRUE)
  Diff = Mean - Mu
  CohenD = (Mean - Mu) / Sd
  
  return(CohenD)
}

## Function for scaling. There is some wierd problem using base R's "scale" function inside dplyr's "mutate"
scale_this <- function(x){
  (x - mean(x, na.rm=TRUE)) / sd(x, na.rm=TRUE)
}




### Function for merging model output with final pre_reg. Previous fitting had some problems
# This is a patch-y function patching up some problems that should hav been done upstream




## updated 16/2/24
merge_tbt_with_model_traj<-function(mean_gz_csv,RW_traj_csv,model_param_csv){
  cols2remove_gz<-c("delta_CW","prev_delta_CW","P_CW","PC_CW","v_CW","explicit_alpha","explicit_beta")
  
  # Patch 1: add trial number to RW traj. Previously had bug that trials are not in order. Now they are!
  RW_traj_csv<-RW_traj_csv%>%
    dplyr::group_by(sub_name)%>%
    dplyr::mutate(TrialNumber=row_number())%>%
    dplyr::relocate(TrialNumber,.after=sub_name)
  
  # Patch 2: remove old model columns from Gz csv
  mean_gz_csv<-mean_gz_csv%>%
    dplyr::select(-all_of(cols2remove_gz))
  # Patch 3: 15/2/24 rename columns
  RW_traj_csv<-RW_traj_csv%>%
    dplyr::rename("expl.resp_vec"="expl.RW.resp_vec",
                  "expl.reward_vec"="expl.RW.reward_vec",
                  "eye.resp_vec"="eye.RW.resp_vec",
                  "eye.reward_vec"="eye.RW.reward_vec")%>%
    dplyr::select(-all_of(c("expl.RWS.reward_vec","expl.RWS.resp_vec",
                            "eye.RWS.reward_vec","eye.RWS.resp_vec")))
  
  #Step 1: joining trial by trial
  ##further confirming that Patch 1 is ok, we see that acc, cntngncy are the same across the trials
  mean_gz_RW_csv<-left_join(mean_gz_csv,RW_traj_csv,
                            by=c("sub_name","TrialNumber",
                                 "resp_cntgncy"="expl.resp_vec",
                                 "eye_resp_cntgncy"="eye.resp_vec",
                                 "eye_acc"="eye.reward_vec",
                                 "is_acc"="expl.reward_vec"))
  
  
  # Step 2: calculate some additional variables to 
  #A. adding distance of v from .5
  mean_gz_RW_csv<-mean_gz_RW_csv%>%
    group_by(sub_name)%>%
    mutate(expl.RW.dist_v_5=abs(expl.RW.q-.5))%>% # for RW
    dplyr::relocate(expl.RW.dist_v_5,.after = expl.RW.q)%>%
    mutate(expl.RWS.dist_v_5=abs(expl.RWS.q-.5))%>% # for RWS
    dplyr::relocate(expl.RWS.dist_v_5,.after = expl.RWS.q)
  
  # ## Replacing pchoice with RW
  # mean_gz_RW_csv<-mean_gz_RW_csv%>%
  #   dplyr::select(-expl.p_choice)%>%
  #   dplyr::rename("expl.p_choice"="expl.RWS.p_choice")
  
  #B. add eye-resp match
  mean_gz_RW_csv<-mean_gz_RW_csv%>%
    dplyr::rowwise()%>%
    dplyr::mutate(eye_resp_match=if_else(eye_resp==QuestionResult,"same","diff"))
  
  #C. add variable of eye_resp_category
  mean_gz_RW_csv<-mean_gz_RW_csv%>%
    dplyr::rowwise()%>%
    dplyr::mutate(
      eye_resp_cat=if_else(eye_resp==QuestionResult & resp_rule_acc==1,"match_corr",
                           if_else(eye_resp==QuestionResult & resp_rule_acc==0,"match_incorr",
                                   if_else(eye_resp!=QuestionResult & resp_rule_acc==1,"mismatch_resp_corr","mismatch_eye_corr")
                           )
      )
    )
  
  # Step 3: add in model parameters
  mean_gz_RW_param_csv<-left_join(mean_gz_RW_csv,model_param_csv,
                                  by="sub_name")
  
  return(mean_gz_RW_param_csv)
  
}



# merge_tbt_with_model_traj<-function(mean_gz_csv,RW_traj_csv,model_param_csv){
#   cols2remove_gz<-c("delta_CW","prev_delta_CW","P_CW","PC_CW","v_CW","explicit_alpha","explicit_beta")
#   
#   # Patch 1: add trial number to RW traj. Previously had bug that trials are not in order. Now they are!
#   RW_traj_csv<-RW_traj_csv%>%
#     dplyr::group_by(sub_name)%>%
#     dplyr::mutate(TrialNumber=row_number())%>%
#     dplyr::relocate(TrialNumber,.after=sub_name)
#   
#   # # Patch 2: remove old model columns from Gz csv
#   # mean_gz_csv<-mean_gz_csv%>%
#   #   dplyr::select(-all_of(cols2remove_gz))
#   # Patch 3: 15/2/24
#   RW_traj_csv2<-RW_traj_csv%>%
#     dplyr::rename("expl.resp_vec"="expl.RW.resp_vec",
#                   "eye.resp_vec"="eyeRW.resp_vec")
#   
#   #Step 1: joining trial by trial
#   ##further confirming that Patch 1 is ok, we see that acc, cntngncy are the same across the trials
#   mean_gz_RW_csv<-left_join(mean_gz_csv,RW_traj_csv,
#                             by=c("sub_name","TrialNumber","stim_cntgncy",
#                                  "resp_cntgncy"="expl.resp_vec",
#                                  "eye_resp_cntgncy"="eye.resp_vec",
#                                  "eye_acc"="eye.reward_vec",
#                                  "is_acc"="expl.reward_vec"))
#   
#   
#   # Step 2: calculate some additional variables
#   #A. adding distance of v from .5
#   mean_gz_RW_csv<-mean_gz_RW_csv%>%
#     group_by(sub_name)%>%
#     mutate(expl.dist_v_5=abs(expl.q-.5))%>%
#     dplyr::relocate(expl.dist_v_5,.after = expl.q)
#   
#   #B. add eye-resp match
#   mean_gz_RW_csv<-mean_gz_RW_csv%>%
#     dplyr::rowwise()%>%
#     dplyr::mutate(eye_resp_match=if_else(eye_resp==QuestionResult,"same","diff"))
#   
#   #C. add variable of eye_resp_category
#   mean_gz_RW_csv<-mean_gz_RW_csv%>%
#     dplyr::rowwise()%>%
#     dplyr::mutate(
#       eye_resp_cat=if_else(eye_resp==QuestionResult & resp_rule_acc==1,"match_corr",
#                            if_else(eye_resp==QuestionResult & resp_rule_acc==0,"match_incorr",
#                                    if_else(eye_resp!=QuestionResult & resp_rule_acc==1,"mismatch_resp_corr","mismatch_eye_corr")
#                            )
#       )
#     )
#   
#   # Step 3: add in model parameters
#   mean_gz_RW_param_csv<-left_join(mean_gz_RW_csv,model_param_csv,
#                                   by="sub_name")
#   
#   return(mean_gz_RW_param_csv)
#   
# }


## Rudimentary function for bootstrapping of difference of beta 
#Input RWS_beta_wide: has colum eye & column expl
bootstrap_beta_diff_fun<-function(RWS_beta_wide){
library(boot)


# Function to calculate difference of means
diff_means <- function(data, indices) {
  d <- data[indices, ]  # Resample with the given indices
  mean_diff <- mean(d$expl - d$eye)  # Calculate mean difference
  return(mean_diff)
}

# Running the bootstrap
results <- boot(RWS_beta_wide, statistic = diff_means, R = 5000)
#get CI
bs_ci<-boot.ci(results, type = "bca")

#calculate p value
observed_diff <- mean(RWS_beta_wide$expl - RWS_beta_wide$eye)

# Calculate the proportion of bootstrap differences as or more extreme than the observed
extreme_diffs <- abs(results$t) >= abs(observed_diff)
p_value <- sum(extreme_diffs) / length(results$t)


res_df<-tibble(statistic=str_glue(round(bs_ci$bca[4],3),',',round(bs_ci$bca[5],3)),
       p.value=p_value,
       method="Bootstrap (bca)")

return(res_df)

}

## Function for rescaling range
rescale_range<-function(x){
  (x-min(x))/(max(x)-min(x))
}
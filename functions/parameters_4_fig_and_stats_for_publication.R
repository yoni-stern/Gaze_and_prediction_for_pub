## Parameters for figs & stats for publication
# written by YS 28/9/23

path_processed_csv<-file.path("processed_csv","exp_combined")

path_export_sm_pics<-file.path("SM_pics","14.4.24")

path_export_main_pics<-file.path("pics_for_netta","21.06.24")


#vales for vizualiztion of gaze  time course
tmcrs_bin_val_shrt<-c(0,seq(25,300,by=25))

tmcrs_bin_val_shrt_labels<-c("","","","","100","","","","200","","","","300")


## Parameters for benchmarks of confidence analysis
n_ptiles_gz2pred<-6
min_trials_per_gz_2_pred_bin<-10

n_ptiles_dist_v<-6

## Viz parameters

#color for actual acc vs. rule
color_vec_acc_type=c("darkseagreen","palegreen")

color_vec_benchmark2_acc<-c("firebrick1","forestgreen")

#color vec of source
color_vec_eye_expl_source=c("burlywood2", "paleturquoise2")



#for confidnce benchmark 3
cvec_pred_strength<-c("black","azure3")






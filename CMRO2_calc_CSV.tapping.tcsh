#!/bin/tcsh -xef

# to execute via bash: 
#   tcsh -xef CMRO2_plots_and_calc.tapping.tcsh 2>&1 | tee output.CMRO2_plots_and_calc_calc.tapping.08_10
set Home = $PWD



set githubAdress = "/home/mococo/Documents/Simon_Boylan2/hick_entropy_analysis/results"
set results_dir = 'tapping_task_versus_rest_clusterization_analysis'
set dataFolder  = '/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data'
set input_directory = "Analysis/CMRO2calc_classic"
set underlayMNI = "/home/mococo/abin/MNI152_2009_template_SSW.nii.gz"
set ModelresultFolder = "Model_results"
set inputRegressDir = "Analysis/regression_factorization"

set atlas = "Schaefer_Yeo_17n_400 -atlas MNI_Glasser_HCP_v1.0 -atlas Brainnetome_1.0"
if ( `whoami` == mococo ) then
   setenv AFNI_SUPP_ATLAS "/home/mococo/abin/AFNI_atlas_spaces.niml"
endif

set mask =  "$Home/mask_group+tlrc"
set GMmask = "$githubAdress/meanGMmask+tlrc"
set atlasMask = "$githubAdress/$results_dir/$ModelresultFolder/atlas_inter+tlrc"



cd $githubAdress/$results_dir


## WARNING, TWO SUBJECTS HAVE BEEN WITHDRAWN FROM THE STUDY AS THEY ARE WERE LOW IN tSNR
# These subjects are HiCh MiAn

# ================================ Time plots ======================================
## RRF plotting
# The goal is to compute the mean CMRO2(t) for HRF and RRF, along with the BOLD
# time course and the PW time course and to plot them in graphs and save the values in 1D files
# shortest run is 94 TRs

if (! -e "mean_subj_CMRO2_t_tapping_rrf+tlrc.HEAD" ) then
       set fileName = "CMRO2_time_serie_tapping_rrf+tlrc[0..93]"

       3dMean -overwrite -prefix "mean_subj_CMRO2_t_tapping_rrf" \
              "$dataFolder/AlPu/${input_directory}/$fileName" \
              "$dataFolder/AnCD/${input_directory}/$fileName" \
              "$dataFolder/ArDC/${input_directory}/$fileName" \
              "$dataFolder/BeMa/${input_directory}/$fileName" \
              "$dataFolder/CeHa/${input_directory}/$fileName" \
              "$dataFolder/ClBo/${input_directory}/$fileName" \
              "$dataFolder/CoVB/${input_directory}/$fileName" \
              "$dataFolder/DoBi/${input_directory}/$fileName" \
              "$dataFolder/ElBe/${input_directory}/$fileName" \
              "$dataFolder/ElCo/${input_directory}/$fileName" \
              "$dataFolder/JoDM/${input_directory}/$fileName" \
              "$dataFolder/JoDP/${input_directory}/$fileName" \
              "$dataFolder/LeGa/${input_directory}/$fileName" \
              "$dataFolder/MaCh/${input_directory}/$fileName" \
              "$dataFolder/MaKi/${input_directory}/$fileName" \
              "$dataFolder/MaKM/${input_directory}/$fileName" \
              "$dataFolder/NaCa/${input_directory}/$fileName" \
              "$dataFolder/NiDe/${input_directory}/$fileName" \
              "$dataFolder/RaEM/${input_directory}/$fileName" \
              "$dataFolder/RaZi/${input_directory}/$fileName" \
              "$dataFolder/SaGa/${input_directory}/$fileName" \
              "$dataFolder/SoSe/${input_directory}/$fileName"
endif
# intersect mask plotting
echo `3dmaskave -q -mask $atlasMask "mean_subj_CMRO2_t_tapping_rrf+tlrc"`   >  "mean_subj_CMRO2_t_rrf.tapping.1D"
1dplot -ps -one -xlabel 'scan number' -ylabel 'Tapping task CMRO2 (RRF) in ROIs' "$dataFolder/AlPu/$inputRegressDir/ideal_tapping.MEC.1D" "mean_subj_CMRO2_t_rrf.tapping.1D" | gs -r100 -sOutputFile="images/RRF_mean_subj_CMRO2_t_intersect_tapping.bmp" -sDEVICE=bmp256


### HRF plotting
if (! -e "mean_subj_CMRO2_t_tapping_hrf+tlrc.HEAD" ) then
       set fileName = "CMRO2_time_serie_tapping_hrf+tlrc[0..93]"

       3dMean -overwrite -prefix "mean_subj_CMRO2_t_tapping_hrf" \
              "$dataFolder/AlPu/${input_directory}/$fileName" \
              "$dataFolder/AnCD/${input_directory}/$fileName" \
              "$dataFolder/ArDC/${input_directory}/$fileName" \
              "$dataFolder/BeMa/${input_directory}/$fileName" \
              "$dataFolder/CeHa/${input_directory}/$fileName" \
              "$dataFolder/ClBo/${input_directory}/$fileName" \
              "$dataFolder/CoVB/${input_directory}/$fileName" \
              "$dataFolder/DoBi/${input_directory}/$fileName" \
              "$dataFolder/ElBe/${input_directory}/$fileName" \
              "$dataFolder/ElCo/${input_directory}/$fileName" \
              "$dataFolder/JoDM/${input_directory}/$fileName" \
              "$dataFolder/JoDP/${input_directory}/$fileName" \
              "$dataFolder/LeGa/${input_directory}/$fileName" \
              "$dataFolder/MaCh/${input_directory}/$fileName" \
              "$dataFolder/MaKi/${input_directory}/$fileName" \
              "$dataFolder/MaKM/${input_directory}/$fileName" \
              "$dataFolder/NaCa/${input_directory}/$fileName" \
              "$dataFolder/NiDe/${input_directory}/$fileName" \
              "$dataFolder/RaEM/${input_directory}/$fileName" \
              "$dataFolder/RaZi/${input_directory}/$fileName" \
              "$dataFolder/SaGa/${input_directory}/$fileName" \
              "$dataFolder/SoSe/${input_directory}/$fileName"
endif
# intersect mask plotting
echo `3dmaskave -q -mask $atlasMask "mean_subj_CMRO2_t_tapping_hrf+tlrc"`   >  "mean_subj_CMRO2_t_hrf.tapping.1D"
1dplot -ps -one -xlabel 'scan number' -ylabel 'Tapping task CMRO2 (HRF) in ROI' "$dataFolder/AlPu/$inputRegressDir/ideal_tapping.MEC.1D" "mean_subj_CMRO2_t_hrf.tapping.1D" | gs -r100 -sOutputFile="images/HRF_mean_subj_CMRO2_t_intersect_tapping.bmp" -sDEVICE=bmp256


## plotting BOLD signal
if (! -e "mean_subj_MEC_t_tapping+tlrc.HEAD" ) then
       set fileName = "dataset.MEC.r03+tlrc[0..93]"

       3dMean -overwrite -prefix "mean_subj_MEC_t_tapping" \
              "$dataFolder/AlPu/${inputRegressDir}/$fileName" \
              "$dataFolder/AnCD/${inputRegressDir}/$fileName" \
              "$dataFolder/ArDC/${inputRegressDir}/$fileName" \
              "$dataFolder/BeMa/${inputRegressDir}/$fileName" \
              "$dataFolder/CeHa/${inputRegressDir}/$fileName" \
              "$dataFolder/ClBo/${inputRegressDir}/$fileName" \
              "$dataFolder/CoVB/${inputRegressDir}/$fileName" \
              "$dataFolder/DoBi/${inputRegressDir}/$fileName" \
              "$dataFolder/ElBe/${inputRegressDir}/$fileName" \
              "$dataFolder/ElCo/${inputRegressDir}/$fileName" \
              "$dataFolder/JoDM/${inputRegressDir}/$fileName" \
              "$dataFolder/JoDP/${inputRegressDir}/$fileName" \
              "$dataFolder/LeGa/${inputRegressDir}/$fileName" \
              "$dataFolder/MaCh/${inputRegressDir}/$fileName" \
              "$dataFolder/MaKi/${inputRegressDir}/$fileName" \
              "$dataFolder/MaKM/${inputRegressDir}/$fileName" \
              "$dataFolder/NaCa/${inputRegressDir}/$fileName" \
              "$dataFolder/NiDe/${inputRegressDir}/$fileName" \
              "$dataFolder/RaEM/${inputRegressDir}/$fileName" \
              "$dataFolder/RaZi/${inputRegressDir}/$fileName" \
              "$dataFolder/SaGa/${inputRegressDir}/$fileName" \
              "$dataFolder/SoSe/${inputRegressDir}/$fileName"
endif
echo `3dmaskave -q -mask $atlasMask "mean_subj_MEC_t_tapping+tlrc"`   >  "mean_subj_MEC_t.tapping.1D"

1dplot -ps -demean -normx -one -xlabel 'scan number' -ylabel 'Tapping task mean BOLD signal in ROI' "$dataFolder/AlPu/$inputRegressDir/ideal_tapping.MEC.1D" "mean_subj_MEC_t.tapping.1D" | gs -r100 -sOutputFile="images/mean_subj_MEC_t_intersect_tapping.bmp" -sDEVICE=bmp256


## plotting PW signal
if (! -e "mean_subj_PW_t_tapping+tlrc.HEAD" ) then

       set fileName = "dataset.PW.r03+tlrc[0..93]"
       3dMean -overwrite -prefix "mean_subj_PW_t_tapping" \
              "$dataFolder/AlPu/${inputRegressDir}/$fileName" \
              "$dataFolder/AnCD/${inputRegressDir}/$fileName" \
              "$dataFolder/ArDC/${inputRegressDir}/$fileName" \
              "$dataFolder/BeMa/${inputRegressDir}/$fileName" \
              "$dataFolder/CeHa/${inputRegressDir}/$fileName" \
              "$dataFolder/ClBo/${inputRegressDir}/$fileName" \
              "$dataFolder/CoVB/${inputRegressDir}/$fileName" \
              "$dataFolder/DoBi/${inputRegressDir}/$fileName" \
              "$dataFolder/ElBe/${inputRegressDir}/$fileName" \
              "$dataFolder/ElCo/${inputRegressDir}/$fileName" \
              "$dataFolder/JoDM/${inputRegressDir}/$fileName" \
              "$dataFolder/JoDP/${inputRegressDir}/$fileName" \
              "$dataFolder/LeGa/${inputRegressDir}/$fileName" \
              "$dataFolder/MaCh/${inputRegressDir}/$fileName" \
              "$dataFolder/MaKi/${inputRegressDir}/$fileName" \
              "$dataFolder/MaKM/${inputRegressDir}/$fileName" \
              "$dataFolder/NaCa/${inputRegressDir}/$fileName" \
              "$dataFolder/NiDe/${inputRegressDir}/$fileName" \
              "$dataFolder/RaEM/${inputRegressDir}/$fileName" \
              "$dataFolder/RaZi/${inputRegressDir}/$fileName" \
              "$dataFolder/SaGa/${inputRegressDir}/$fileName" \
              "$dataFolder/SoSe/${inputRegressDir}/$fileName"
endif
echo `3dmaskave -q -mask $atlasMask "mean_subj_PW_t_tapping+tlrc"`   >  "mean_subj_PW_t.tapping.1D"

1dplot -ps -demean -normx -one -xlabel 'scan number' -ylabel 'Tapping task mean ASL signal in ROI' "$dataFolder/AlPu/$inputRegressDir/ideal_tapping.MEC.1D" "mean_subj_PW_t.tapping.1D" | gs -r100 -sOutputFile="images/mean_subj_PW_t_intersect_tapping.bmp" -sDEVICE=bmp256


## CMRO2(t), BOLD and PW on the same plot
1dplot -ps -demean -normx -one -xlabel 'scan number' -ylabel 'Tapping task mean ASL, BOLD and CMRO2 signals in ROI' "$dataFolder/AlPu/$inputRegressDir/ideal_tapping.MEC.1D" "mean_subj_PW_t.tapping.1D" "mean_subj_MEC_t.tapping.1D" "mean_subj_CMRO2_t_hrf.tapping.1D"| gs -r100 -sOutputFile="images/mean_subj_BOLD_PW_CMRO2_hrf_t_intersect_tapping.bmp" -sDEVICE=bmp256

# ================================ histograms ======================================
## histogram of M values
# HRF 
if (! -e "mean_subj_M_tapping_hrf+tlrc.HEAD" ) then

       set fileName = "M_hrf+tlrc.BRIK"
       3dMean -overwrite -prefix "mean_subj_M_tapping_hrf" \
              "$dataFolder/AlPu/${input_directory}/$fileName" \
              "$dataFolder/AnCD/${input_directory}/$fileName" \
              "$dataFolder/ArDC/${input_directory}/$fileName" \
              "$dataFolder/BeMa/${input_directory}/$fileName" \
              "$dataFolder/CeHa/${input_directory}/$fileName" \
              "$dataFolder/ClBo/${input_directory}/$fileName" \
              "$dataFolder/CoVB/${input_directory}/$fileName" \
              "$dataFolder/DoBi/${input_directory}/$fileName" \
              "$dataFolder/ElBe/${input_directory}/$fileName" \
              "$dataFolder/ElCo/${input_directory}/$fileName" \
              "$dataFolder/JoDM/${input_directory}/$fileName" \
              "$dataFolder/JoDP/${input_directory}/$fileName" \
              "$dataFolder/LeGa/${input_directory}/$fileName" \
              "$dataFolder/MaCh/${input_directory}/$fileName" \
              "$dataFolder/MaKi/${input_directory}/$fileName" \
              "$dataFolder/MaKM/${input_directory}/$fileName" \
              "$dataFolder/NaCa/${input_directory}/$fileName" \
              "$dataFolder/NiDe/${input_directory}/$fileName" \
              "$dataFolder/RaEM/${input_directory}/$fileName" \
              "$dataFolder/RaZi/${input_directory}/$fileName" \
              "$dataFolder/SaGa/${input_directory}/$fileName" \
              "$dataFolder/SoSe/${input_directory}/$fileName"
endif 
3dhistog -mask $atlasMask -nbin 500 -notitle -min -0.25 -max 0.25 "mean_subj_M_tapping_hrf+tlrc" > "hist.1D"
1dplot -ps -hist -x "hist.1D[0]" -xlabel 'M values HRF' -ylabel 'count' "hist.1D[1]" | gs -r100 -sOutputFile="images/M_HRF_histogram.bmp" -sDEVICE=bmp256
       
#RRF
if (! -e "mean_subj_M_tapping_rrf+tlrc.HEAD" ) then
       set fileName = "M_rrf+tlrc.BRIK"
       3dMean -overwrite -prefix "mean_subj_M_tapping_rrf" \
              "$dataFolder/AlPu/${input_directory}/$fileName" \
              "$dataFolder/AnCD/${input_directory}/$fileName" \
              "$dataFolder/ArDC/${input_directory}/$fileName" \
              "$dataFolder/BeMa/${input_directory}/$fileName" \
              "$dataFolder/CeHa/${input_directory}/$fileName" \
              "$dataFolder/ClBo/${input_directory}/$fileName" \
              "$dataFolder/CoVB/${input_directory}/$fileName" \
              "$dataFolder/DoBi/${input_directory}/$fileName" \
              "$dataFolder/ElBe/${input_directory}/$fileName" \
              "$dataFolder/ElCo/${input_directory}/$fileName" \
              "$dataFolder/JoDM/${input_directory}/$fileName" \
              "$dataFolder/JoDP/${input_directory}/$fileName" \
              "$dataFolder/LeGa/${input_directory}/$fileName" \
              "$dataFolder/MaCh/${input_directory}/$fileName" \
              "$dataFolder/MaKi/${input_directory}/$fileName" \
              "$dataFolder/MaKM/${input_directory}/$fileName" \
              "$dataFolder/NaCa/${input_directory}/$fileName" \
              "$dataFolder/NiDe/${input_directory}/$fileName" \
              "$dataFolder/RaEM/${input_directory}/$fileName" \
              "$dataFolder/RaZi/${input_directory}/$fileName" \
              "$dataFolder/SaGa/${input_directory}/$fileName" \
              "$dataFolder/SoSe/${input_directory}/$fileName"

endif
3dhistog -mask $atlasMask -nbin 500 -notitle -min -0.25 -max 0.25 "mean_subj_M_tapping_rrf+tlrc" > "hist.1D"
1dplot -ps -hist -x "hist.1D[0]" -xlabel 'M values RRF' -ylabel 'count' "hist.1D[1]" | gs -r100 -sOutputFile="images/M_RRF_histogram.bmp" -sDEVICE=bmp256

# CMRO2 histogram plotting within the intersection atlas.
# A plot already exist, but it is in the Motor cortex, and if we want to identify why we get these CMRO2 results, we need to see CMRO2 histogram 
# on the same ROIS that it has been meaned and observed

# HRF 
if (! -e "mean_subj_CMRO2_tapping_hrf+tlrc.HEAD" ) then
    set fileName = "CMRO2_tapping_hrf+tlrc"
    3dMean -overwrite -prefix "mean_subj_CMRO2_tapping_hrf" \
           "$dataFolder/AlPu/${input_directory}/$fileName" \
           "$dataFolder/AnCD/${input_directory}/$fileName" \
           "$dataFolder/ArDC/${input_directory}/$fileName" \
           "$dataFolder/BeMa/${input_directory}/$fileName" \
           "$dataFolder/CeHa/${input_directory}/$fileName" \
           "$dataFolder/ClBo/${input_directory}/$fileName" \
           "$dataFolder/CoVB/${input_directory}/$fileName" \
           "$dataFolder/DoBi/${input_directory}/$fileName" \
           "$dataFolder/ElBe/${input_directory}/$fileName" \
           "$dataFolder/ElCo/${input_directory}/$fileName" \
           "$dataFolder/JoDM/${input_directory}/$fileName" \
           "$dataFolder/JoDP/${input_directory}/$fileName" \
           "$dataFolder/LeGa/${input_directory}/$fileName" \
           "$dataFolder/MaCh/${input_directory}/$fileName" \
           "$dataFolder/MaKi/${input_directory}/$fileName" \
           "$dataFolder/MaKM/${input_directory}/$fileName" \
           "$dataFolder/NaCa/${input_directory}/$fileName" \
           "$dataFolder/NiDe/${input_directory}/$fileName" \
           "$dataFolder/RaEM/${input_directory}/$fileName" \
           "$dataFolder/RaZi/${input_directory}/$fileName" \
           "$dataFolder/SaGa/${input_directory}/$fileName" \
           "$dataFolder/SoSe/${input_directory}/$fileName"
endif

3dhistog -omit 0 -mask $GMmask -nbin 100 -notitle -min -2 -max 3 "mean_subj_CMRO2_tapping_hrf+tlrc.HEAD"    > "hist_GM.1D"
3dhistog -omit 0 -mask $atlasMask -nbin 100 -notitle -min -2 -max 3 "mean_subj_CMRO2_tapping_hrf+tlrc.HEAD" > "hist_atlas.1D"
1dplot -ps -dashed 1:2:2 -one -norm2 -hist -x "hist_GM.1D[0]" -xlabel 'CMRO2 tapping' -ylabel 'histo' "hist_GM.1D[1]" "hist_atlas.1D[1]" | gs -r100 -sOutputFile="images/CMRO2_tap_HRF_GM_atlas_intersect.bmp" -sDEVICE=bmp256

# RRF 

if (! -e "mean_subj_CMRO2_tapping_rrf+tlrc.HEAD" ) then
    set fileName = "CMRO2_tapping_rrf+tlrc"
    3dMean -overwrite -prefix "mean_subj_CMRO2_tapping_rrf" \
           "$dataFolder/AlPu/${input_directory}/$fileName" \
           "$dataFolder/AnCD/${input_directory}/$fileName" \
           "$dataFolder/ArDC/${input_directory}/$fileName" \
           "$dataFolder/BeMa/${input_directory}/$fileName" \
           "$dataFolder/CeHa/${input_directory}/$fileName" \
           "$dataFolder/ClBo/${input_directory}/$fileName" \
           "$dataFolder/CoVB/${input_directory}/$fileName" \
           "$dataFolder/DoBi/${input_directory}/$fileName" \
           "$dataFolder/ElBe/${input_directory}/$fileName" \
           "$dataFolder/ElCo/${input_directory}/$fileName" \
           "$dataFolder/JoDM/${input_directory}/$fileName" \
           "$dataFolder/JoDP/${input_directory}/$fileName" \
           "$dataFolder/LeGa/${input_directory}/$fileName" \
           "$dataFolder/MaCh/${input_directory}/$fileName" \
           "$dataFolder/MaKi/${input_directory}/$fileName" \
           "$dataFolder/MaKM/${input_directory}/$fileName" \
           "$dataFolder/NaCa/${input_directory}/$fileName" \
           "$dataFolder/NiDe/${input_directory}/$fileName" \
           "$dataFolder/RaEM/${input_directory}/$fileName" \
           "$dataFolder/RaZi/${input_directory}/$fileName" \
           "$dataFolder/SaGa/${input_directory}/$fileName" \
           "$dataFolder/SoSe/${input_directory}/$fileName"
endif

3dhistog -omit 0 -mask $GMmask -nbin 100 -notitle -min -2 -max 3 "mean_subj_CMRO2_tapping_rrf+tlrc.HEAD"    > "hist_GM.1D"
3dhistog -omit 0 -mask $atlasMask -nbin 100 -notitle -min -2 -max 3 "mean_subj_CMRO2_tapping_rrf+tlrc.HEAD" > "hist_atlas.1D"
1dplot -ps -dashed 1:2:2 -one -norm2 -hist -x "hist_GM.1D[0]" -xlabel 'CMRO2 tapping' -ylabel 'histo' "hist_GM.1D[1]" "hist_atlas.1D[1]" | gs -r100 -sOutputFile="images/CMRO2_tap_RRF_GM_atlas_intersect.bmp" -sDEVICE=bmp256



# ========================== COmputing CMRO2(t) from mean BOLD, PW and M ===============================
## calculating CMRO2 from mean signal
# here we recalculate CMRO2(t) using the equation, but using mean MEC, mean M and mean PW
# previous analysis was averaging the CMRO2 that has been calculated for each subjects
if (! -e "mean_mean_PW+tlrc.HEAD" ) then
       3dMean -overwrite -prefix "mean_mean_PW" \
              "$dataFolder/AlPu/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/AnCD/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/ArDC/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/BeMa/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/CeHa/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/ClBo/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/CoVB/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/DoBi/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/ElBe/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/ElCo/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/JoDM/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/JoDP/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/LeGa/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/MaCh/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/MaKi/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/MaKM/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/NaCa/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/NiDe/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/RaEM/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/RaZi/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/SaGa/${input_directory}/stats.PW3.*+tlrc.HEAD[2]" \
              "$dataFolder/SoSe/${input_directory}/stats.PW3.*+tlrc.HEAD[2]"
endif

if (! -e "mean_mean_MEC+tlrc.HEAD" ) then
       3dMean -overwrite -prefix "mean_mean_MEC" \
              "$dataFolder/AlPu/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/AnCD/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/ArDC/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/BeMa/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/CeHa/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/ClBo/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/CoVB/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/DoBi/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/ElBe/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/ElCo/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/JoDM/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/JoDP/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/LeGa/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/MaCh/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/MaKi/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/MaKM/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/NaCa/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/NiDe/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/RaEM/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/RaZi/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/SaGa/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]" \
              "$dataFolder/SoSe/${input_directory}/stats.MEC3.*+tlrc.HEAD[2]"
endif

3dcalc -overwrite -prefix "CMRO2_tap_recomputed_from_mean_signals_hrf" \
               -a "mean_subj_PW_t_tapping+tlrc" \
               -b "mean_mean_PW+tlrc" \
               -c "mean_subj_MEC_t_tapping+tlrc"\
               -d "mean_mean_MEC+tlrc"\
               -e "mean_subj_M_tapping_hrf+tlrc" \
               -expr '(1 - ((c-d)/d)/e)*(((a)/b)^(8/10))'

echo `3dmaskave -q -mask $atlasMask "CMRO2_tap_recomputed_from_mean_signals_hrf+tlrc"`   >  "CMRO2_recomputed_from_mean_signals_hrf.tapping.1D"
1dplot -ps -one -xlabel 'scan number' -ylabel 'Tapping task mean CMRO2 signal in ROI' "$dataFolder/AlPu/$inputRegressDir/ideal_tapping.MEC.1D" "CMRO2_recomputed_from_mean_signals_hrf.tapping.1D" | gs -r100 -sOutputFile="images/mean_CMRO2_t_intersect_tapping_from_mean_signal.bmp" -sDEVICE=bmp256


   ## ============= ROI values (for specific analysis)  =============================
      # --------------------------------  Schaefer & Yeo  -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/Schaefer_Yeo_ROIs_tapping_intersection_mask.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  "$githubAdress/resampleSchaefer_17N_400.nii.gz"

      set hereDir = "$PWD"
      set csvFileName = "Schaefer_Yeo_ROIs_tapping_intersection_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'
                  
   ## ============= M HRF and rrf values (for threshold)  =============================
      # --------------------------------  M_HRF  -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_HRF_tapping_intersection_mask.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_HRF_tapping_intersect_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'

      # --------------------------------  M_RRF  -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_RRF_tapping_intersection_mask.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_rrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_RRF_tapping_intersect_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'


   ## ============= CMRO2  =============================
     # -------------- HRF ------------------------
       set outFileName = CMRO2_HRF_intersect_clust_mask_voxel_data.txt
       rm -f $outFileName
       3dmaskdump -mask $atlasMask \
                   -noijk -o $outFileName \
                   $dataFolder/*/${input_directory}/CMRO2_tapping_hrf+tlrc.HEAD
                   
       set hereDir = "$PWD"
       set csvFileName = 'CMRO2_HRF_intersect_clust_mask_voxel_data.csv'
       matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName"'");exit;'

     # -------------- RRF ------------------------
       set outFileName = CMRO2_RRF_intersect_clust_mask_voxel_data.txt
       rm -f $outFileName
       3dmaskdump -mask $atlasMask \
                   -noijk -o $outFileName \
                   $dataFolder/*/${input_directory}/CMRO2_tapping_rrf+tlrc.HEAD
                   
       set hereDir = "$PWD"
       set csvFileName = 'CMRO2_RRF_intersect_clust_mask_voxel_data.csv'
       matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName"'");exit;'


   ## ============= BOLD  =============================
       set outFileName = MEC_pos_intersection_voxels_tapping.txt
       rm -f $outFileName
       3dmaskdump -cmask "-a $githubAdress/$results_dir/$ModelresultFolder/clustMapTapping_BOLDPos+tlrc.HEAD -b $githubAdress/$results_dir/$ModelresultFolder/clustMapTapping_PWPos+tlrc.HEAD -expr a*b" \
                   -noijk -o $outFileName \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC3.AlPu_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC3.AnCD_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC3.ArDC_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC3.BeMa_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2calc_classic/stats.MEC3.CeHa_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC3.ClBo_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC3.CoVB_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC3.DoBi_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC3.ElBe_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC3.ElCo_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC3.HiCh_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC3.JoDM_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC3.JoDP_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC3.LeGa_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC3.MaCh_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC3.MaKi_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC3.MaKM_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2calc_classic/stats.MEC3.MiAn_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC3.NaCa_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC3.NiDe_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC3.RaEM_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC3.RaZi_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC3.SaGa_REML+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC3.SoSe_REML+tlrc.HEAD'[6]'
                 
       set hereDir = "$PWD"
       set csvFileName = 'BOLD_intersect_clust_mask_voxel_data.csv'
       matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName"'");exit;'

   ## ============= ASL  =============================
       set outFileName = PW_pos_intersection_voxels_tapping.txt
       rm -f $outFileName
       3dmaskdump -cmask "-a $githubAdress/$results_dir/$ModelresultFolder/clustMapTapping_BOLDPos+tlrc.HEAD -b $githubAdress/$results_dir/$ModelresultFolder/clustMapTapping_PWPos+tlrc.HEAD -expr a*b" \
                   -noijk -o $outFileName \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.PW3.AlPu+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.PW3.AnCD+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.PW3.ArDC+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.PW3.BeMa+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2calc_classic/stats.PW3.CeHa+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.PW3.ClBo+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.PW3.CoVB+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.PW3.DoBi+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.PW3.ElBe+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.PW3.ElCo+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.PW3.HiCh+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.PW3.JoDM+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.PW3.JoDP+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.PW3.LeGa+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.PW3.MaCh+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.PW3.MaKi+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.PW3.MaKM+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2calc_classic/stats.PW3.MiAn+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.PW3.NaCa+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.PW3.NiDe+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.PW3.RaEM+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.PW3.RaZi+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.PW3.SaGa+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.PW3.SoSe+tlrc.HEAD'[6]'
            
       set hereDir = "$PWD"
       set csvFileName = 'PW_intersect_clust_mask_voxel_data.csv'
       matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName"'");exit;'



echo "job finished"
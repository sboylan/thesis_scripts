#!/bin/tcsh -xef

# to execute via bash: 
#   tcsh -xef CMRO2_plots_and_calc.hick.tcsh 2>&1 | tee output.CMRO2_plots_and_calc_calc.hick.10_10


### In this script, we will clean and order CMRO2 data from Hick experiment.
### This will results in at least 3*4 analysis as we will do task versus rest analysis and plots, but also for all 3 conditions;
### for BOLD, ASL and CMRO2. CMRO2 HRF and RRF will be calculated. Concerning entropy conditions, they were calculated via davis equation using
### the three beta coefficient of each BOLD and ASL. ANother methode would be to use the coefficients from the regression of CMRO2(t) that has
### calculated before. THe masks used here were computed in Hick_cluster_analysis.mococo.tcsh
### This script necessicates a mask within which voxels will be studied. 
### This mask is calculated in a previous script Hick_cluster_analysis.mococo.tcsh
### We do not create an output folder, the result folder has to be the same as the one with the intersectional atlas.
### This previous step obviously need pre-processing, fisrst and second level analysis to have been done on each subject.
### We will use the intersectional atlas for all our analysis, to compare the results between BOLD, ASL and CMRO2
### 226 is the minimal length for the Hick task, when considering all subjects.
### intersct mask has 205 voxels
###
### All together, 26 csv are computed (if cluster maps are present) : 
###         10 csv with CMRO2 data that are from BOLD and ASL beta values from regression name starts with CMRO2_calculated_XRF...
###         10 csv with CMRO2 data that has been regressed from CMRO2(t). Name start with CMRO2_regression_XRF 
###         The 10 csv for each CMRO2 calculations are :
###                        HRF and RRF with intersection mask (CMRO2_XRF_intersect_clust_mask_)
###                        HRF and RRF with full t-test mask from CMRO2_regression data (...XRF_regression_pos_mask.csv or ...XRF_regression_neg_mask.csv)
###                        HRF and RRF with full t-test mask from CMRO2 calculated from BOLD and ASL beta coeffs (...XRF_calculated_pos_mask.csv or ...XRF_calculated_neg_mask.csv)    
###         The 4 BOLD datasets are :
###                        1 BOLD csv in intersection mask  
###                        1 BOLD csv in full positive clustered BOLD mask from t-test
###                        1 BOLD csv in full negative clustered BOLD mask from t-test
###                        1 BOLD csv in same postive clustered BOLD but without the ASL voxels mask
###         The 2 ASL datasets are :
###                        1 ASL csv in intersection mask  
###                        1 ASL csv in full positive clustered BOLD mask from t-test


set Home = $PWD
set githubAdress = "/home/mococo/Documents/Simon_Boylan2/hick_entropy_analysis/results"
set results_dir = 'task_versus_rest_clusterization_analysis'
set dataFolder  = '/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data'
set input_directory = "Analysis/CMRO2calc_classic"
set input_dir_CMRO2_reg = "Analysis/CMRO2_regression"
set underlayMNI = "/home/mococo/abin/MNI152_2009_template_SSW.nii.gz"
set ModelresultFolder = "Model_results"
set inputRegressDir = "Analysis/regression_factorization"
set minNbrTR = 226
set atlas = "Schaefer_Yeo_17n_400 -atlas MNI_Glasser_HCP_v1.0 -atlas Brainnetome_1.0"

set networkFolderName = "network_analysis"


if ( `whoami` == mococo ) then
   setenv AFNI_SUPP_ATLAS "/home/mococo/abin/AFNI_atlas_spaces.niml"
endif

set mask =  "$Home/mask_group+tlrc"
set GMmask = ".$githubAdress/meanGMmask+tlrc"


set suffix = "_0.01_0.007"
set atlasMask = "$githubAdress/$results_dir/$ModelresultFolder/atlas_inter+tlrc"


cd $githubAdress/$results_dir
mkdir -p $networkFolderName
if (1) then

##                 ==================================================                
## =======================================  CMRO2 ==================================
   ## =========  Plotting mean task versus rest CMRO2(t) for HRF regressor  ========

      if (! -f "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_hrf+tlrc.HEAD" ) then
         3dMean -overwrite -prefix "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_hrf" \
                "$dataFolder/AlPu/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/AnCD/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ArDC/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/BeMa/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ClBo/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/CoVB/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/DoBi/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ElBe/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ElCo/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/HiCh/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/JoDM/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/JoDP/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/LeGa/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/MaCh/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/MaKi/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/MaKM/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/NaCa/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/NiDe/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/RaEM/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/RaZi/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/SaGa/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/SoSe/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/BrMa/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ElAc/${input_directory}/rm.CMRO2_time_serie_Hick_TvsR_hrf+tlrc[0..$minNbrTR]"
      endif


      echo `3dmaskave -q -mask $atlasMask "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_hrf+tlrc"`   >  "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_hrf.hick.1D"
      1dplot -ps -one -xlabel 'CMRO2 Hick' -ylabel 'CMRO2 in areas activated through BOLD and ASL' "$dataFolder/AlPu/$inputRegressDir/ideal_TaskVsRest.E2.1D" "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_hrf.hick.1D" | gs -r100 -sOutputFile="images/mean_CMRO2_t_interMask_TvsR_hick_HRF.bmp" -sDEVICE=bmp256

      ## =====  Plotting mean task versus rest CMRO2(t) for RRF regressor
      if (! -f "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_rrf+tlrc.HEAD" ) then
         3dMean -overwrite -prefix "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_rrf" \
                "$dataFolder/AlPu/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/AnCD/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ArDC/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/BeMa/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ClBo/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/CoVB/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/DoBi/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ElBe/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ElCo/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/HiCh/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/JoDM/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/JoDP/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/LeGa/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/MaCh/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/MaKi/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/MaKM/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/NaCa/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/NiDe/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/RaEM/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/RaZi/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/SaGa/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/SoSe/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/BrMa/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]" \
                "$dataFolder/ElAc/${input_directory}/CMRO2_time_serie_Hick_TvsR_rrf+tlrc[0..$minNbrTR]"
      endif

      echo `3dmaskave -q -mask $atlasMask "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_rrf+tlrc"`   >  "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_rrf.hick.1D"
      1dplot -ps -one -xlabel 'scan number' -ylabel 'CMRO2 in areas activated through BOLD and ASL (RRF)' "$dataFolder/AlPu/$inputRegressDir/ideal_TaskVsRest.E2.1D" "$ModelresultFolder/mean_subj_CMRO2_t_TvsR_rrf.hick.1D" | gs -r100 -sOutputFile="images/mean_CMRO2_t_interMask_TvsR_hick_RRF.bmp" -sDEVICE=bmp256

   ## ============= ROI values (for specific analysis)  =============================
      # --------------------------------  Schaefer & Yeo  -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/Schaefer_Yeo_ROIs_hick_intersection_mask.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  "$githubAdress/resampleSchaefer_17N_400.nii.gz"

      set hereDir = "$PWD"
      set csvFileName = "Schaefer_Yeo_ROIs_hick_intersection_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'
                  
   ## ============= M HRF and rrf values (for threshold)  =============================
      # --------------------------------  M_HRF  -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_HRF_hick_intersection_mask.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_HRF_hick_intersect_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'

      # --------------------------------  M_RRF  -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_RRF_intersection_mask.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_rrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_RRF_hick_intersect_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'


   ## ============= network analysis  =============================
     # dumping voxels from whole networks rather than just ROIs
      3dcalc -overwrite -a ../resampleSchaefer_17N_400.nii.gz'<358..390>' \
       -b ../resampleSchaefer_17N_400.nii.gz'<149..194>'  -expr 'step(a+b)' \
       -prefix $networkFolderName/Default_network.nii.gz

      3dcalc -overwrite -a ../resampleSchaefer_17N_400.nii.gz'<325..357>' \
       -b ../resampleSchaefer_17N_400.nii.gz'<121..148>'  -expr 'step(a+b)' \
       -prefix $networkFolderName/Control_network.nii.gz

      3dcalc -overwrite -a ../resampleSchaefer_17N_400.nii.gz'<224..258>' \
       -b ../resampleSchaefer_17N_400.nii.gz'<25..59>'  -expr 'step(a+b)' \
       -prefix $networkFolderName/SomMot_network.nii.gz

    # --------------------------- Default mode network  ------------------------------
     ## HRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set networkMask = $networkFolderName/Default_network.nii.gz
      set outFileName1 = $networkFolderName/CMRO2_calculated_HRF_Default_network_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

      set outFileName2 = $networkFolderName/CMRO2_calculated_HRF_Default_network_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

      set outFileName4 = $networkFolderName/CMRO2_calculated_HRF_Default_network_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "$networkFolderName/CMRO2_calculated_HRF_Default_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

     ## RRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/CMRO2_calculated_RRF_Default_network_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

      set outFileName2 = $ModelresultFolder/CMRO2_calculated_RRF_Default_network_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

      set outFileName4 = $ModelresultFolder/CMRO2_calculated_RRF_Default_network_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_calculated_RRF_Default_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

     ## ROIs
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/Schaefer_Yeo_ROIs_hick_Default_network.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  "$githubAdress/resampleSchaefer_17N_400.nii.gz"

      set hereDir = "$PWD"
      set csvFileName = "Schaefer_Yeo_ROIs_hick_Default_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'

     ## M HRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_HRF_hick_Default_network.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_HRF_hick_Default_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'

     ## M RRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_RRF_Default_network.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_rrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_RRF_hick_Default_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'
              
      # --------------------------- Control network  ------------------------------
      ##   HRF  
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set networkMask = $networkFolderName/Control_network.nii.gz
      set outFileName1 = $networkFolderName/CMRO2_calculated_HRF_Control_network_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

      set outFileName2 = $networkFolderName/CMRO2_calculated_HRF_Control_network_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

      set outFileName4 = $networkFolderName/CMRO2_calculated_HRF_Control_network_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "$networkFolderName/CMRO2_calculated_HRF_Control_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      ## RRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/CMRO2_calculated_RRF_Control_network_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

      set outFileName2 = $ModelresultFolder/CMRO2_calculated_RRF_Control_network_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

      set outFileName4 = $ModelresultFolder/CMRO2_calculated_RRF_Control_network_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_calculated_RRF_Control_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

     ## ROIs
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/Schaefer_Yeo_ROIs_hick_Control_network.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  "$githubAdress/resampleSchaefer_17N_400.nii.gz"

      set hereDir = "$PWD"
      set csvFileName = "Schaefer_Yeo_ROIs_hick_Control_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'

     ## M HRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_HRF_hick_Control_network.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_HRF_hick_Control_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'

     ## M RRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_RRF_Control_network.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_rrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_RRF_hick_Control_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'
              
      # --------------------------- Somato-motor network  ------------------------------
      ##  HRF  
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set networkMask = $networkFolderName/SomMot_network.nii.gz
      set outFileName1 = $networkFolderName/CMRO2_calculated_HRF_SomMot_network_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

      set outFileName2 = $networkFolderName/CMRO2_calculated_HRF_SomMot_network_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

      set outFileName4 = $networkFolderName/CMRO2_calculated_HRF_SomMot_network_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "$networkFolderName/CMRO2_calculated_HRF_SomMot_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      ## RRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/CMRO2_calculated_RRF_SomMot_network_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

      set outFileName2 = $ModelresultFolder/CMRO2_calculated_RRF_SomMot_network_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

      set outFileName4 = $ModelresultFolder/CMRO2_calculated_RRF_SomMot_network_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_calculated_RRF_SomMot_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

     ## ROIs
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/Schaefer_Yeo_ROIs_hick_SomMot_network.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  "$githubAdress/resampleSchaefer_17N_400.nii.gz"

      set hereDir = "$PWD"
      set csvFileName = "Schaefer_Yeo_ROIs_hick_SomMot_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'

     ## M HRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_HRF_hick_SomMot_network.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_HRF_hick_SomMot_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'

     ## M RRF
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/M_RRF_SomMot_network.txt
      rm -f $outFileName1
      3dmaskdump  -mask $networkMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/M_rrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "M_RRF_hick_SomMot_network.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'","'"$outFileName1"'","'"$outFileName1"'");exit;'
              
   ## ============= CMRO2 from beta BOLD and beta ASL  =============================
      # --------------------------------  HRF  -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/CMRO2_HRF_pos_intersection_voxels_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

      set outFileName2 = $ModelresultFolder/CMRO2_HRF_pos_intersection_voxels_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

      set outFileName4 = $ModelresultFolder/CMRO2_HRF_pos_intersection_voxels_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_calculated_HRF_intersect_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  HRF full mask pos -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set CMRO2posMask = $ModelresultFolder/clustMapTvsR_CMRO2Pos+tlrc.HEAD

      set outFileName1 = $ModelresultFolder/CMRO2_HRF_pos_full_mask_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

      set outFileName2 = $ModelresultFolder/CMRO2_HRF_pos_full_mask_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

      set outFileName4 = $ModelresultFolder/CMRO2_HRF_pos_full_mask_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_calculated_HRF_regression_pos_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  HRF full mask neg -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2Neg+tlrc.HEAD) then
         set CMRO2negMask = $ModelresultFolder/clustMapTvsR_CMRO2Neg+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_HRF_neg_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName1 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

         set outFileName2 = $ModelresultFolder/CMRO2_HRF_neg_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName2 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

         set outFileName4 = $ModelresultFolder/CMRO2_HRF_neg_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName4 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_HRF_full_mask_neg_voxel_data.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif

      # --------------------------------  HRF full mask pos from BOLD and ASL beta coefs -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the cluster outputted 
      # from the positive t-test results on CMRO2 values calculated from BOLD and ASL beta coeffs.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc.HEAD) then
         set CMRO2posMask = $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_calculated_HRF_pos_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2posMask \
                     -noijk -o $outFileName1 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

         set outFileName2 = $ModelresultFolder/CMRO2_calculated_HRF_pos_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2posMask \
                     -noijk -o $outFileName2 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

         set outFileName4 = $ModelresultFolder/CMRO2_calculated_HRF_pos_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2posMask \
                     -noijk -o $outFileName4 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_calculated_HRF_calculated_pos_mask.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif
      # --------------------------------  HRF full mask pos from BOLD and ASL beta coefs -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the cluster outputted 
      # from the negative t-test results on CMRO2 values calculated from BOLD and ASL beta coeffs.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFNeg+tlrc.HEAD) then
         set CMRO2negMask = $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFNeg+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_calculated_HRF_neg_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName1 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

         set outFileName2 = $ModelresultFolder/CMRO2_calculated_HRF_neg_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName2 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

         set outFileName4 = $ModelresultFolder/CMRO2_calculated_HRF_neg_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName4 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_calculated_HRF_calculated_neg_mask.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif

      # --------------------------------  RRF  -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/CMRO2_RRF_pos_intersection_voxels_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_rrf+tlrc.HEAD

      set outFileName2 = $ModelresultFolder/CMRO2_RRF_pos_intersection_voxels_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_rrf+tlrc.HEAD

      set outFileName4 = $ModelresultFolder/CMRO2_RRF_pos_intersection_voxels_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_rrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_calculated_RRF_intersect_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  RRF full mask pos -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the intersectional mask.
      set CMRO2posMask = $ModelresultFolder/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD

      set outFileName1 = $ModelresultFolder/CMRO2_RRF_pos_full_mask_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_rrf+tlrc.HEAD

      set outFileName2 = $ModelresultFolder/CMRO2_RRF_pos_full_mask_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_rrf+tlrc.HEAD

      set outFileName4 = $ModelresultFolder/CMRO2_RRF_pos_full_mask_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_rrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_calculated_RRF_regression_pos_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  RRF full mask neg -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the intersectional mask.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg+tlrc.HEAD) then
         set CMRO2negMask = $ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_RRF_neg_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName1 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond1_rrf+tlrc.HEAD

         set outFileName2 = $ModelresultFolder/CMRO2_RRF_neg_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName2 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond2_rrf+tlrc.HEAD

         set outFileName4 = $ModelresultFolder/CMRO2_RRF_neg_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName4 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond4_rrf+tlrc.HEAD
                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_RRF_full_mask_neg_voxel_data.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif

      # --------------------------------  RRF full mask pos from BOLD and ASL beta coefs -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the cluster outputted 
      # from the positive t-test results on CMRO2 values calculated from BOLD and ASL beta coeffs.
      set CMRO2posMask = $ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc.HEAD

      set outFileName1 = $ModelresultFolder/CMRO2_calculated_RRF_pos_full_mask_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName1 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

      set outFileName2 = $ModelresultFolder/CMRO2_calculated_RRF_pos_full_mask_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName2 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

      set outFileName4 = $ModelresultFolder/CMRO2_calculated_RRF_pos_full_mask_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName4 \
                  $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_calculated_RRF_calculated_pos_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  RRF full mask pos from BOLD and ASL beta coefs -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the cluster outputted 
      # from the negative t-test results on CMRO2 values calculated from BOLD and ASL beta coeffs.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc.HEAD) then
         set CMRO2negMask = $ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_calculated_RRF_neg_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName1 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond1_hrf+tlrc.HEAD

         set outFileName2 = $ModelresultFolder/CMRO2_calculated_RRF_neg_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName2 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond2_hrf+tlrc.HEAD

         set outFileName4 = $ModelresultFolder/CMRO2_calculated_RRF_neg_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName4 \
                     $dataFolder/*/${input_directory}/CMRO2_hick_cond4_hrf+tlrc.HEAD
                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_calculated_RRF_calculated_neg_mask.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif
endif

   ## ============ CMRO2 values from regression of CMRO2(t)  =======================
      # --------------------------------  HRF  -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      # Initialize an empty string to hold all the datasets
      # set datasetList1 = ""
      # set datasetList2 = ""
      # set datasetList4 = ""
      # # Loop through each folder matching the pattern
      # foreach file ($dataFolder/*/${input_dir_CMRO2_reg}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD)
      #    # Extract the base name (without the .HEAD extension) and select sub-brik [2]
      #    # set base = `echo $file | sed 's/.HEAD//'`
      #    set base = $file
      #    set subbrik = "${base}'[2]'"
      #    # Append the sub-brik to the datasetList
      #    set datasetList1 = "$datasetList1 $subbrik"
      #    set subbrik = "${base}'[6]'"
      #    set datasetList2 = "$datasetList2 $subbrik"
      #    set subbrik = "${base}'[10]'"
      #    set datasetList4 = "$datasetList4 $subbrik"
      # end

      set outFileName1 = $ModelresultFolder/CMRO2_HRF_pos_intersection_voxels_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'\
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'

      set outFileName2 = $ModelresultFolder/CMRO2_HRF_pos_intersection_voxels_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName2 \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'\
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'

      set outFileName4 = $ModelresultFolder/CMRO2_HRF_pos_intersection_voxels_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName4 \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'\
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_regression_HRF_intersect_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  HRF full mask pos -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      set CMRO2posMask = $ModelresultFolder/clustMapTvsR_CMRO2Pos+tlrc.HEAD

      set outFileName1 = $ModelresultFolder/CMRO2_HRF_pos_full_mask_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName1 \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'\
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'

      set outFileName2 = $ModelresultFolder/CMRO2_HRF_pos_full_mask_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName2 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'\
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'

      set outFileName4 = $ModelresultFolder/CMRO2_HRF_pos_full_mask_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName4 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'\
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                   /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'
                  
                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_regression_HRF_regression_pos_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  HRF full mask neg -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the intersectional mask.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2Neg+tlrc.HEAD) then
         set CMRO2negMask = $ModelresultFolder/clustMapTvsR_CMRO2Neg+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_HRF_neg_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName1 \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'\
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'

         set outFileName2 = $ModelresultFolder/CMRO2_HRF_neg_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName2 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'\
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'


         set outFileName4 = $ModelresultFolder/CMRO2_HRF_neg_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName4 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'\
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'
                  
                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_regression__HRF_full_mask_neg_voxel_data.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif

      # --------------------------------  HRF full mask pos from BOLD and ASL beta coefs -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the cluster outputted 
      # from the positive t-test results on CMRO2 values calculated from BOLD and ASL beta coeffs.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc.HEAD) then
         set CMRO2posMask = $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_calculated_HRF_pos_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2posMask \
                     -noijk -o $outFileName1 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'\
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'
                   

         set outFileName2 = $ModelresultFolder/CMRO2_calculated_HRF_pos_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2posMask \
                     -noijk -o $outFileName2 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'\
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'


         set outFileName4 = $ModelresultFolder/CMRO2_calculated_HRF_pos_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2posMask \
                     -noijk -o $outFileName4 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'\
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'
                  
                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_regression_HRF_calculated_pos_mask.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif
      # --------------------------------  HRF full mask pos from BOLD and ASL beta coefs -------------------------------------
      # We output a csv file of CMRO2 HRF in all the voxels within the cluster outputted 
      # from the negative t-test results on CMRO2 values calculated from BOLD and ASL beta coeffs.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFNeg+tlrc.HEAD) then
         set CMRO2negMask = $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFNeg+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_calculated_HRF_neg_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName1 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'\
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[2]'
                   

         set outFileName2 = $ModelresultFolder/CMRO2_calculated_HRF_neg_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName2 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'\
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'


         set outFileName4 = $ModelresultFolder/CMRO2_calculated_HRF_neg_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName4 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'\
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]' \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'
                  
                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_regression_HRF_calculated_neg_mask.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif

      # --------------------------------  RRF  -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the intersectional mask.

      # set datasetList1 = ""
      # set datasetList2 = ""
      # set datasetList4 = ""
      # # Loop through each folder matching the pattern
      # foreach file ($dataFolder/*/${input_dir_CMRO2_reg}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD)
      #    # Extract the base name (without the .HEAD extension) and select sub-brik [2]
      #    # set base = `echo $file | sed 's/.HEAD//'`
      #    set base = $file
      #    set subbrik = "${base}'[2]'"
      #    # Append the sub-brik to the datasetList
      #    set datasetList1 = $datasetList1 $subbrik
      #    set subbrik = "${base}'[6]'"
      #    set datasetList2 = $datasetList2 $subbrik
      #    set subbrik = "${base}'[10]'"
      #    set datasetList4 = $datasetList4 $subbrik
      # end

      set outFileName1 = $ModelresultFolder/CMRO2_RRF_pos_intersection_voxels_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'


      set outFileName2 = $ModelresultFolder/CMRO2_RRF_pos_intersection_voxels_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName2 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'


      set outFileName4 = $ModelresultFolder/CMRO2_RRF_pos_intersection_voxels_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName4 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'

                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_regression_RRF_intersect_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  RRF full mask pos -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the intersectional mask.
      set CMRO2posMask = $ModelresultFolder/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD

      set outFileName1 = $ModelresultFolder/CMRO2_RRF_pos_full_mask_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName1 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'


      set outFileName2 = $ModelresultFolder/CMRO2_RRF_pos_full_mask_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName2 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'


      set outFileName4 = $ModelresultFolder/CMRO2_RRF_pos_full_mask_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName4 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'

                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_regression_RRF_regression_pos_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  RRF full mask neg -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the intersectional mask.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg+tlrc.HEAD) then
         set CMRO2negMask = $ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_RRF_neg_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName1 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'


         set outFileName2 = $ModelresultFolder/CMRO2_RRF_neg_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName2 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'


         set outFileName4 = $ModelresultFolder/CMRO2_RRF_neg_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName4 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'

                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_regression__RRF_full_mask_neg_voxel_data.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif

      # --------------------------------  RRF full mask pos from BOLD and ASL beta coefs -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the cluster outputted 
      # from the positive t-test results on CMRO2 values calculated from BOLD and ASL beta coeffs.
      set CMRO2posMask = $ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc.HEAD

      set outFileName1 = $ModelresultFolder/CMRO2_calculated_RRF_pos_full_mask_cond1.txt
      rm -f $outFileName1
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName1 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'


      set outFileName2 = $ModelresultFolder/CMRO2_calculated_RRF_pos_full_mask_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName2 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'


      set outFileName4 = $ModelresultFolder/CMRO2_calculated_RRF_pos_full_mask_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $CMRO2posMask \
                  -noijk -o $outFileName4 \
                  /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'

                  
      set hereDir = "$PWD"
      set csvFileName = "CMRO2_regression_RRF_calculated_pos_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      # --------------------------------  RRF full mask pos from BOLD and ASL beta coefs -------------------------------------
      # We output a csv file of CMRO2 RRF in all the voxels within the cluster outputted 
      # from the negative t-test results on CMRO2 values calculated from BOLD and ASL beta coeffs.
      if (-e $ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc.HEAD) then
         set CMRO2negMask = $ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc.HEAD

         set outFileName1 = $ModelresultFolder/CMRO2_calculated_RRF_neg_full_mask_cond1.txt
         rm -f $outFileName1
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName1 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'\
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[2]'


         set outFileName2 = $ModelresultFolder/CMRO2_calculated_RRF_neg_full_mask_cond2.txt
         rm -f $outFileName2
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName2 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'\
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]' \
                      /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'


         set outFileName4 = $ModelresultFolder/CMRO2_calculated_RRF_neg_full_mask_cond4.txt
         rm -f $outFileName4
         3dmaskdump  -mask $CMRO2negMask \
                     -noijk -o $outFileName4 \
                     /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'\
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CeHa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MiAn/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]' \
                         /home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2_regression/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'

                     
         set hereDir = "$PWD"
         set csvFileName = "CMRO2_regression_RRF_calculated_neg_mask.csv"
         matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
      endif

##                 ==================================================                
## ================================  ASL Analysis ==================================
      ## -------------  Plotting mean task versus rest ASL time course  ------------
      if (! -f "$ModelresultFolder/mean_subj_PW_t_Hick+tlrc.HEAD" ) then
             set fileName = "dataset.PW.r02+tlrc[0..$minNbrTR]"
             3dMean -overwrite -prefix "$ModelresultFolder/mean_subj_PW_t_Hick" \
                    "$dataFolder/AlPu/${inputRegressDir}/$fileName" \
                    "$dataFolder/AnCD/${inputRegressDir}/$fileName" \
                    "$dataFolder/ArDC/${inputRegressDir}/$fileName" \
                    "$dataFolder/BeMa/${inputRegressDir}/$fileName" \
                    "$dataFolder/BrMa/${inputRegressDir}/$fileName" \
                    "$dataFolder/HiCh/${inputRegressDir}/$fileName" \
                    "$dataFolder/ClBo/${inputRegressDir}/$fileName" \
                    "$dataFolder/CoVB/${inputRegressDir}/$fileName" \
                    "$dataFolder/DoBi/${inputRegressDir}/$fileName" \
                    "$dataFolder/ElAc/${inputRegressDir}/$fileName" \
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

      echo `3dmaskave -q -mask $atlasMask "$ModelresultFolder/mean_subj_PW_t_Hick+tlrc"`   >  "$ModelresultFolder/mean_subj_PW_t_TvsR.hick.1D"
      1dplot -ps -one -xlabel 'scan number' -ylabel 'CMRO2 in areas activated through BOLD and ASL (RRF)' "$dataFolder/AlPu/$inputRegressDir/ideal_TaskVsRest.E2.1D" "$ModelresultFolder/mean_subj_PW_t_TvsR.hick.1D" | gs -r100 -sOutputFile="images/mean_PW_t_interMask_TvsR_hick.bmp" -sDEVICE=bmp256


      ## ---------------------------------------------------------------------------
      # We output a csv file of ASL in all the voxels within the intersectional mask.
      set outFileName1 = $ModelresultFolder/ASL_pos_intersection_voxels_cond1.txt
      rm -f $outFileName1

      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName1 \
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.PW2.AlPu+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.PW2.AnCD+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.PW2.ArDC+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.PW2.BeMa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.PW2.BrMa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.PW2.ClBo+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.PW2.CoVB+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.PW2.DoBi+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.PW2.ElAc+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.PW2.ElBe+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.PW2.ElCo+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.PW2.HiCh+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.PW2.JoDM+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.PW2.JoDP+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.PW2.LeGa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.PW2.MaCh+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.PW2.MaKi+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.PW2.MaKM+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.PW2.NaCa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.PW2.NiDe+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.PW2.RaEM+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.PW2.RaZi+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.PW2.SaGa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.PW2.SoSe+tlrc.HEAD[6]"


      set outFileName2 = $ModelresultFolder/ASL_pos_intersection_voxels_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName2 \
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.PW2.AlPu+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.PW2.AnCD+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.PW2.ArDC+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.PW2.BeMa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.PW2.BrMa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.PW2.ClBo+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.PW2.CoVB+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.PW2.DoBi+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.PW2.ElAc+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.PW2.ElBe+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.PW2.ElCo+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.PW2.HiCh+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.PW2.JoDM+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.PW2.JoDP+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.PW2.LeGa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.PW2.MaCh+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.PW2.MaKi+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.PW2.MaKM+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.PW2.NaCa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.PW2.NiDe+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.PW2.RaEM+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.PW2.RaZi+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.PW2.SaGa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.PW2.SoSe+tlrc.HEAD[10]"

      set outFileName4 = $ModelresultFolder/ASL_pos_intersection_voxels_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $atlasMask \
                  -noijk -o $outFileName4 \
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.PW2.AlPu+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.PW2.AnCD+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.PW2.ArDC+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.PW2.BeMa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.PW2.BrMa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.PW2.ClBo+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.PW2.CoVB+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.PW2.DoBi+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.PW2.ElAc+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.PW2.ElBe+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.PW2.ElCo+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.PW2.HiCh+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.PW2.JoDM+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.PW2.JoDP+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.PW2.LeGa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.PW2.MaCh+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.PW2.MaKi+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.PW2.MaKM+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.PW2.NaCa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.PW2.NiDe+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.PW2.RaEM+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.PW2.RaZi+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.PW2.SaGa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.PW2.SoSe+tlrc.HEAD[14]" 

      set hereDir = "$PWD"
      set csvFileName = "ASL_intersect_clust_mask_voxel_data.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

      ## ----------------------  ASL Full mask  ----------------------------------------------
                 
      set maskASL = $ModelresultFolder/clustDataTvsR_PWPos_0.01_0.007+tlrc.BRIK.gz

      set outFileName1 = $ModelresultFolder/ASL_full_mask_cond1.txt
      rm -f $outFileName1

      3dmaskdump  -mask $maskASL \
                  -noijk -o $outFileName1 \
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.PW2.AlPu+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.PW2.AnCD+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.PW2.ArDC+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.PW2.BeMa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.PW2.BrMa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.PW2.ClBo+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.PW2.CoVB+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.PW2.DoBi+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.PW2.ElAc+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.PW2.ElBe+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.PW2.ElCo+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.PW2.HiCh+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.PW2.JoDM+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.PW2.JoDP+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.PW2.LeGa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.PW2.MaCh+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.PW2.MaKi+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.PW2.MaKM+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.PW2.NaCa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.PW2.NiDe+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.PW2.RaEM+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.PW2.RaZi+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.PW2.SaGa+tlrc.HEAD[6]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.PW2.SoSe+tlrc.HEAD[6]"


      set outFileName2 = $ModelresultFolder/ASL_full_mask_cond2.txt
      rm -f $outFileName2
      3dmaskdump  -mask $maskASL \
                  -noijk -o $outFileName2 \
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.PW2.AlPu+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.PW2.AnCD+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.PW2.ArDC+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.PW2.BeMa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.PW2.BrMa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.PW2.ClBo+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.PW2.CoVB+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.PW2.DoBi+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.PW2.ElAc+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.PW2.ElBe+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.PW2.ElCo+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.PW2.HiCh+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.PW2.JoDM+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.PW2.JoDP+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.PW2.LeGa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.PW2.MaCh+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.PW2.MaKi+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.PW2.MaKM+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.PW2.NaCa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.PW2.NiDe+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.PW2.RaEM+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.PW2.RaZi+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.PW2.SaGa+tlrc.HEAD[10]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.PW2.SoSe+tlrc.HEAD[10]"

      set outFileName4 = $ModelresultFolder/ASL_full_mask_cond4.txt
      rm -f $outFileName4
      3dmaskdump  -mask $maskASL \
                  -noijk -o $outFileName4 \
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.PW2.AlPu+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.PW2.AnCD+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.PW2.ArDC+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.PW2.BeMa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.PW2.BrMa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.PW2.ClBo+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.PW2.CoVB+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.PW2.DoBi+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.PW2.ElAc+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.PW2.ElBe+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.PW2.ElCo+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.PW2.HiCh+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.PW2.JoDM+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.PW2.JoDP+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.PW2.LeGa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.PW2.MaCh+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.PW2.MaKi+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.PW2.MaKM+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.PW2.NaCa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.PW2.NiDe+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.PW2.RaEM+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.PW2.RaZi+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.PW2.SaGa+tlrc.HEAD[14]"\
                  "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.PW2.SoSe+tlrc.HEAD[14]" 

      set hereDir = "$PWD"
      set csvFileName = "ASL_full_mask.csv"
      matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'

                 

##                 ==================================================                
## ================================  BOLD Analysis =================================
   ## -------------  Plotting mean task versus rest ASL time course  ------------
   if (! -f "$ModelresultFolder/mean_subj_BOLD_t_Hick+tlrc.HEAD" ) then
          set fileName = "dataset.MEC.r02+tlrc[0..$minNbrTR]"
          3dMean -overwrite -prefix "$ModelresultFolder/mean_subj_BOLD_t_Hick" \
                 "$dataFolder/AlPu/${inputRegressDir}/$fileName" \
                 "$dataFolder/AnCD/${inputRegressDir}/$fileName" \
                 "$dataFolder/ArDC/${inputRegressDir}/$fileName" \
                 "$dataFolder/BeMa/${inputRegressDir}/$fileName" \
                 "$dataFolder/BrMa/${inputRegressDir}/$fileName" \
                 "$dataFolder/HiCh/${inputRegressDir}/$fileName" \
                 "$dataFolder/ClBo/${inputRegressDir}/$fileName" \
                 "$dataFolder/CoVB/${inputRegressDir}/$fileName" \
                 "$dataFolder/DoBi/${inputRegressDir}/$fileName" \
                 "$dataFolder/ElAc/${inputRegressDir}/$fileName" \
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

   echo `3dmaskave -q -mask $atlasMask "$ModelresultFolder/mean_subj_BOLD_t_Hick+tlrc"`   >  "$ModelresultFolder/mean_subj_BOLD_t_TvsR.hick.1D"
   1dplot -ps -one -xlabel 'scan number' -ylabel 'CMRO2 in areas activated through BOLD and ASL (RRF)' "$dataFolder/AlPu/$inputRegressDir/ideal_TaskVsRest.E2.1D" "$ModelresultFolder/mean_subj_BOLD_t_TvsR.hick.1D" | gs -r100 -sOutputFile="images/mean_BOLD_t_interMask_TvsR_hick.bmp" -sDEVICE=bmp256


   # We output a csv file of BOLD in all the voxels within the intersectional mask.
   set outFileName1 = $ModelresultFolder/BOLD_pos_intersection_voxels_cond1.txt
   rm -f $outFileName1

   3dmaskdump  -mask $atlasMask \
               -noijk -o $outFileName1 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[6]"


   set outFileName2 = $ModelresultFolder/BOLD_pos_intersection_voxels_cond2.txt
   rm -f $outFileName2
   3dmaskdump  -mask $atlasMask \
               -noijk -o $outFileName2 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[10]"

   set outFileName4 = $ModelresultFolder/BOLD_pos_intersection_voxels_cond4.txt
   rm -f $outFileName4
   3dmaskdump  -mask $atlasMask \
               -noijk -o $outFileName4 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[14]" 

   set hereDir = "$PWD"
   set csvFileName = "BOLD_intersect_clust_mask_voxel_data.csv"
   matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'


## ===============  ASL and BOLD full and negative mask Analysis ===================
   # creating mask without ASL
   3dcalc -a $ModelresultFolder/clustMapTvsR_BOLDPos_0.01_0.007+tlrc.BRIK.gz \
   -b $ModelresultFolder/clustMapTvsR_PWPos_0.01_0.007+tlrc.BRIK.gz\
   -expr 'a*(1-notzero(b))'\
   -prefix clustBOLD_without_ASL


   # --------------------- Positive BOLD without ASL ---------------------------------

   set BOLDmask = clustBOLD_without_ASL+tlrc

   set outFileName1 = $ModelresultFolder/BOLD_without_ASL_mask_test_cond0.txt
   rm -f $outFileName1
   3dmaskdump  -mask $BOLDmask \
               -noijk -o $outFileName1 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[6]"

   set outFileName2 = $ModelresultFolder/BOLD_without_ASL_mask_test_cond1.txt
   rm -f $outFileName2
   3dmaskdump  -mask $BOLDmask \
               -noijk -o $outFileName2 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[10]"

   set outFileName4 = $ModelresultFolder/BOLD_without_ASL_mask_test_cond2.txt
   rm -f $outFileName4
   3dmaskdump  -mask $BOLDmask \
               -noijk -o $outFileName4 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[14]" 

   set hereDir = "$PWD"     
   set Home = /home/mococo/Documents/Simon_Boylan2/hick_entropy_analysis/scripts
   set csvFileName = "BOLD_without_ASL_mask_test.csv"
   matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
              

   # --------------------- Positive BOLD clusters ---------------------------------
         

   set BOLDmask = $ModelresultFolder/clustDataTvsR_BOLDNeg_0.01_0.007+tlrc.BRIK.gz

   set outFileName1 = $ModelresultFolder/BOLD_full_mask_neg_cond0.txt
   rm -f $outFileName1
   3dmaskdump  -mask $BOLDmask \
               -noijk -o $outFileName1 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[6]"

   set outFileName2 = $ModelresultFolder/BOLD_full_mask_neg_cond1.txt
   rm -f $outFileName2
   3dmaskdump  -mask $BOLDmask \
               -noijk -o $outFileName2 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[10]"

   set outFileName4 = $ModelresultFolder/BOLD_full_mask_neg_cond2.txt
   rm -f $outFileName4
   3dmaskdump  -mask $BOLDmask \
               -noijk -o $outFileName4 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[14]" 

   set hereDir = "$PWD"     
   set Home = /home/mococo/Documents/Simon_Boylan2/hick_entropy_analysis/scripts
   set csvFileName = "BOLD_full_neg_mask_test.csv"
   matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
              
   # --------------------- Negative BOLD clusters ---------------------------------

   set BOLDmask = $ModelresultFolder/clustDataTvsR_BOLDPos_0.01_0.007+tlrc.BRIK.gz

   set outFileName1 = $ModelresultFolder/BOLD_full_mask_test_cond0.txt
   rm -f $outFileName1
   3dmaskdump  -mask $BOLDmask \
               -noijk -o $outFileName1 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[6]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[6]"

   set outFileName2 = $ModelresultFolder/BOLD_full_mask_test_cond1.txt
   rm -f $outFileName2
   3dmaskdump  -mask $BOLDmask \
               -noijk -o $outFileName2 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[10]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[10]"

   set outFileName4 = $ModelresultFolder/BOLD_full_mask_test_cond2.txt
   rm -f $outFileName4
   3dmaskdump  -mask $BOLDmask \
               -noijk -o $outFileName4 \
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AlPu/Analysis/CMRO2calc_classic/stats.MEC2.AlPu_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/AnCD/Analysis/CMRO2calc_classic/stats.MEC2.AnCD_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ArDC/Analysis/CMRO2calc_classic/stats.MEC2.ArDC_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BeMa/Analysis/CMRO2calc_classic/stats.MEC2.BeMa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/BrMa/Analysis/CMRO2calc_classic/stats.MEC2.BrMa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ClBo/Analysis/CMRO2calc_classic/stats.MEC2.ClBo_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/CoVB/Analysis/CMRO2calc_classic/stats.MEC2.CoVB_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/DoBi/Analysis/CMRO2calc_classic/stats.MEC2.DoBi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElAc/Analysis/CMRO2calc_classic/stats.MEC2.ElAc_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElBe/Analysis/CMRO2calc_classic/stats.MEC2.ElBe_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/ElCo/Analysis/CMRO2calc_classic/stats.MEC2.ElCo_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/HiCh/Analysis/CMRO2calc_classic/stats.MEC2.HiCh_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDM/Analysis/CMRO2calc_classic/stats.MEC2.JoDM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/JoDP/Analysis/CMRO2calc_classic/stats.MEC2.JoDP_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/LeGa/Analysis/CMRO2calc_classic/stats.MEC2.LeGa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaCh/Analysis/CMRO2calc_classic/stats.MEC2.MaCh_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKi/Analysis/CMRO2calc_classic/stats.MEC2.MaKi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/MaKM/Analysis/CMRO2calc_classic/stats.MEC2.MaKM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NaCa/Analysis/CMRO2calc_classic/stats.MEC2.NaCa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/NiDe/Analysis/CMRO2calc_classic/stats.MEC2.NiDe_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaEM/Analysis/CMRO2calc_classic/stats.MEC2.RaEM_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/RaZi/Analysis/CMRO2calc_classic/stats.MEC2.RaZi_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SaGa/Analysis/CMRO2calc_classic/stats.MEC2.SaGa_REML+tlrc.HEAD[14]"\
               "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data/SoSe/Analysis/CMRO2calc_classic/stats.MEC2.SoSe_REML+tlrc.HEAD[14]" 

   set hereDir = "$PWD"     
   set Home = /home/mococo/Documents/Simon_Boylan2/hick_entropy_analysis/scripts
   set csvFileName = "BOLD_full_mask_test.csv"
   matlab -nodisplay -nosplash -nodesktop -r 'addpath(char("'"$Home"'"));cd(char("'"$hereDir"'")) ; from1d2GLMcsv("'"$csvFileName"'","'"$outFileName1"'", "'"$outFileName2"'", "'"$outFileName4"'");exit;'
              
              

echo "job done"

#!/bin/tcsh -xef

# to execute via bash: 
#   tcsh -xef M_cluster_analysis.mococo.tcsh 2>&1 | tee output.M_cluster_analysis.mococo_04_10

### This program does t-tests for each thresholded M maps and compute overlap of intersection mask 
### (from BOLD and ASL t-tests and clusterization)
### This program comes after M_thresholding.allSubj.hick_tapping.tcsh that has thresholded the M maps.

set Home = $PWD
set githubFolder = "/home/mococo/Documents/Simon_Boylan2/hick_entropy_analysis"
set results_dir = "$githubFolder/results/M_clusterization_analysis"
set dataFolder  = "/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data"
set input_directory = "Analysis/CMRO2calc_classic"
set CMRO2_input_directory = "Analysis/CMRO2_regression"
set underlayMNI = "/home/mococo/abin/MNI152_2009_template_SSW.nii.gz"
set ImageFolder = "$results_dir/images"
set ModelresultFolderName = Model_results
set ModelresultFolder = "$results_dir/$ModelresultFolderName"
set atlas = "Schaefer_Yeo_17n_400 -atlas MNI_Glasser_HCP_v1.0 -atlas Brainnetome_1.0"
setenv AFNI_SUPP_ATLAS "/home/mococo/abin/AFNI_atlas_spaces.niml"

set NN = 2
set GMmask = "$githubFolder/results/meanGMmask+tlrc"

mkdir -p $results_dir
cd $results_dir
mkdir -p $ImageFolder
mkdir -p $ModelresultFolder/ClustSimdata



## The mean of every dataset has to be 0 because ttest tests against 0.
# because : * With 1 set ('-setA'), the mean across input datasets (usually subjects)
#    is tested against 0.


      ### ========== M analysis  ================= ###
set pValThresholdM = 0.005

set regressors = ('hrf' 'rrf')
foreach reg ( $regressors )
   set file_name = M_${reg}_thresholded_Hick+tlrc
   if (! -f "./$ModelresultFolderName/TtestM_${reg}_Hick+tlrc.HEAD" ) then
      ## running 3dttest on TaskVsRest for PW
      3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestM_${reg}_Hick         \
               -resid ./$ModelresultFolderName/errtsM_$reg -ACF -Clustsim \
               -prefix_clustsim ccM_$reg -tempdir ./$ModelresultFolderName/ClustSimdata \
               -mask $GMmask  -setA M                                            \
               01 "$dataFolder/AlPu/${input_directory}/$file_name" \
               02 "$dataFolder/AnCD/${input_directory}/$file_name" \
               03 "$dataFolder/ArDC/${input_directory}/$file_name" \
               04 "$dataFolder/BeMa/${input_directory}/$file_name" \
               06 "$dataFolder/ClBo/${input_directory}/$file_name" \
               07 "$dataFolder/CoVB/${input_directory}/$file_name" \
               08 "$dataFolder/DoBi/${input_directory}/$file_name" \
               09 "$dataFolder/ElBe/${input_directory}/$file_name" \
               10 "$dataFolder/ElCo/${input_directory}/$file_name" \
               11 "$dataFolder/HiCh/${input_directory}/$file_name" \
               12 "$dataFolder/JoDM/${input_directory}/$file_name" \
               13 "$dataFolder/JoDP/${input_directory}/$file_name" \
               14 "$dataFolder/LeGa/${input_directory}/$file_name" \
               15 "$dataFolder/MaCh/${input_directory}/$file_name" \
               16 "$dataFolder/MaKi/${input_directory}/$file_name" \
               17 "$dataFolder/MaKM/${input_directory}/$file_name" \
               19 "$dataFolder/NaCa/${input_directory}/$file_name" \
               20 "$dataFolder/NiDe/${input_directory}/$file_name" \
               21 "$dataFolder/RaEM/${input_directory}/$file_name" \
               22 "$dataFolder/RaZi/${input_directory}/$file_name" \
               23 "$dataFolder/BrMa/${input_directory}/$file_name" \
               24 "$dataFolder/ElAc/${input_directory}/$file_name" \
               25 "$dataFolder/CeHa/${input_directory}/$file_name" \
               26 "$dataFolder/MiAn/${input_directory}/$file_name" \
               18 "$dataFolder/SaGa/${input_directory}/$file_name" \
               5 "$dataFolder/SoSe/${input_directory}/$file_name"
   endif

 
   ### =======================     Clusterization     =========================================
   ### M analysis with pval = 0.005

   ## M analysis
   set boundary_M = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestM_${reg}_Hick+tlrc[1]" -1sided -pval $pValThresholdM`
   set ClustSize_M = `1d_tool.py -infile ccM_${reg}.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdM -csim_alpha 0.05 -verb 0`

   3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestM_${reg}_Hick+tlrc" -NN $NN -clust_nvox $ClustSize_M -pref_map "$ModelresultFolder/clustMap_M${reg}Pos_Hick" -pref_dat "$ModelresultFolder/clustData_M${reg}Pos_Hick" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundary_M > "$ModelresultFolder/clustResults_M${reg}pos_Hick.1D"

   set testPosM=`cat "$ModelresultFolder/clustResults_M${reg}pos_Hick.1D"`


   # identifying the ROIs of the clusters and printing the results in txt file
   if ("$testPosM" == "#** NO CLUSTERS FOUND ***" ) then
      echo "no clusters found for positively activated voxels in ASL data"
   else
      whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResults_M${reg}pos_Hick.1D'[1,2,3]' -bmask $ModelresultFolder/clustMap_M${reg}Pos_Hick+tlrc -tab > posROIs_M${reg}_Hick.1D

      set opref = "$ImageFolder/clustMap_M${reg}_Pos_Hick"

      @chauffeur_afni                                                      \
         -ulay              "${underlayMNI}"                               \
         -box_focus_slices  AMASK_FOCUS_ULAY                               \
         -olay              "$ModelresultFolder/clustMap_M${reg}Pos_Hick+tlrc"  \
         -set_subbricks     0 -1 -1                                        \
         -ulay_range        0% 130%                                        \
         -cbar              Reds_and_Blues_Inv                                        \
         -func_range        64                                             \
         -pbar_posonly                                                     \
         -opacity           6                                              \
         -prefix            ${opref}                                       \
         -set_xhairs        OFF                                            \
         -montx 3 -monty 3                                                 \
         -label_mode 1 -label_size 4

   endif


   set opref = "$ImageFolder/intersect_M_mask_${reg}_Hick"

   @chauffeur_afni                                                      \
      -ulay              "${underlayMNI}"                               \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/intersect_M_mask_${reg}_Hick+tlrc"  \
      -set_subbricks     0 -1 -1                                        \
      -ulay_range        0% 130%                                        \
      -cbar              Reds_and_Blues_Inv                                        \
      -func_range        64                                             \
      -pbar_posonly                                                     \
      -opacity           6                                              \
      -prefix            ${opref}                                       \
      -set_xhairs        OFF                                            \
      -montx 3 -monty 3                                                 \
      -label_mode 1 -label_size 4

#### ================= TAPPING ===========================
   
   set file_name = M_${reg}_thresholded_tap+tlrc
   if (! -f "./$ModelresultFolderName/TtestM_${reg}_tap+tlrc.HEAD" ) then
      ## running 3dttest on TaskVsRest for PW
      3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestM_${reg}_tap         \
               -resid ./$ModelresultFolderName/errtsM_$reg -ACF -Clustsim \
               -prefix_clustsim ccM_$reg -tempdir ./$ModelresultFolderName/ClustSimdata \
               -mask $GMmask  -setA M                                            \
               01 "$dataFolder/AlPu/${input_directory}/$file_name" \
               02 "$dataFolder/AnCD/${input_directory}/$file_name" \
               03 "$dataFolder/ArDC/${input_directory}/$file_name" \
               04 "$dataFolder/BeMa/${input_directory}/$file_name" \
               06 "$dataFolder/ClBo/${input_directory}/$file_name" \
               07 "$dataFolder/CoVB/${input_directory}/$file_name" \
               08 "$dataFolder/DoBi/${input_directory}/$file_name" \
               09 "$dataFolder/ElBe/${input_directory}/$file_name" \
               10 "$dataFolder/ElCo/${input_directory}/$file_name" \
               11 "$dataFolder/HiCh/${input_directory}/$file_name" \
               12 "$dataFolder/JoDM/${input_directory}/$file_name" \
               13 "$dataFolder/JoDP/${input_directory}/$file_name" \
               14 "$dataFolder/LeGa/${input_directory}/$file_name" \
               15 "$dataFolder/MaCh/${input_directory}/$file_name" \
               16 "$dataFolder/MaKi/${input_directory}/$file_name" \
               17 "$dataFolder/MaKM/${input_directory}/$file_name" \
               19 "$dataFolder/NaCa/${input_directory}/$file_name" \
               20 "$dataFolder/NiDe/${input_directory}/$file_name" \
               21 "$dataFolder/RaEM/${input_directory}/$file_name" \
               22 "$dataFolder/RaZi/${input_directory}/$file_name" \
               23 "$dataFolder/BrMa/${input_directory}/$file_name" \
               24 "$dataFolder/ElAc/${input_directory}/$file_name" \
               25 "$dataFolder/CeHa/${input_directory}/$file_name" \
               26 "$dataFolder/MiAn/${input_directory}/$file_name" \
               18 "$dataFolder/SaGa/${input_directory}/$file_name" \
               5 "$dataFolder/SoSe/${input_directory}/$file_name"
   endif

   set boundary_M = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestM_${reg}_tap+tlrc[1]" -1sided -pval $pValThresholdM`
   set ClustSize_M = `1d_tool.py -infile ccM_${reg}.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdM -csim_alpha 0.05 -verb 0`

   3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestM_${reg}_tap+tlrc" -NN $NN -clust_nvox $ClustSize_M -pref_map "$ModelresultFolder/clustMap_M${reg}Pos_tap" -pref_dat "$ModelresultFolder/clustData_M${reg}Pos_tap" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundary_M > "$ModelresultFolder/clustResults_M${reg}pos_tap.1D"

   set testPosM=`cat "$ModelresultFolder/clustResults_M${reg}pos_tap.1D"`


   # identifying the ROIs of the clusters and printing the results in txt file
   if ("$testPosM" == "#** NO CLUSTERS FOUND ***" ) then
      echo "no clusters found for positively activated voxels in ASL data"
   else
      whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResults_M${reg}pos_tap.1D'[1,2,3]' -bmask $ModelresultFolder/clustMap_M${reg}Pos_tap+tlrc -tab > posROIs_M${reg}_tap.1D

      set opref = "$ImageFolder/clustMap_M${reg}_Pos_tap"

      @chauffeur_afni                                                      \
         -ulay              "${underlayMNI}"                               \
         -box_focus_slices  AMASK_FOCUS_ULAY                               \
         -olay              "$ModelresultFolder/clustMap_M${reg}Pos_tap+tlrc"  \
         -set_subbricks     0 -1 -1                                        \
         -ulay_range        0% 130%                                        \
         -cbar              Reds_and_Blues_Inv                                        \
         -func_range        64                                             \
         -pbar_posonly                                                     \
         -opacity           6                                              \
         -prefix            ${opref}                                       \
         -set_xhairs        OFF                                            \
         -montx 3 -monty 3                                                 \
         -label_mode 1 -label_size 4

   endif


   set opref = "$ImageFolder/intersect_M_mask_${reg}_tap"

   @chauffeur_afni                                                      \
      -ulay              "${underlayMNI}"                               \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/intersect_M_mask_${reg}_tap+tlrc"  \
      -set_subbricks     0 -1 -1                                        \
      -ulay_range        0% 130%                                        \
      -cbar              Reds_and_Blues_Inv                                        \
      -func_range        64                                             \
      -pbar_posonly                                                     \
      -opacity           6                                              \
      -prefix            ${opref}                                       \
      -set_xhairs        OFF                                            \
      -montx 3 -monty 3                                                 \
      -label_mode 1 -label_size 4

end

### ==============================================================================================
### ====================== overlapping and DICE of the tso methods  ========================== ###

echo "Computing the overlapping of both method of computing mask of active voxels."
echo " Overlapping results " >  Overlapping_Hick_M_masks_results.txt

### testing CMRO2 positive with M clustered mask
if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2Pos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2Pos+tlrc.HEAD" "$ModelresultFolder/clustMap_MhrfPos_Hick+tlrc"           >> Overlapping_Hick_M_masks_results.txt                
else 
   echo "No positive CMRO2 HRF clusters"                                                                                                                                           >> Overlapping_Hick_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD" "$ModelresultFolder/clustMap_MrrfPos_Hick+tlrc"       >> Overlapping_Hick_M_masks_results.txt                 
else 
   echo "No positive CMRO2 RRF clusters"                                                                                                                                           >> Overlapping_Hick_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc" "$ModelresultFolder/clustMap_MhrfPos_Hick+tlrc" >> Overlapping_Hick_M_masks_results.txt                  
else 
   echo "No positive CMRO2 HRF calculated from BOLD and ASL beta coeffs clusters"                                                                                                  >> Overlapping_Hick_M_masks_results.txt 
endif 


if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc" "$ModelresultFolder/clustMap_MrrfPos_Hick+tlrc"   >> Overlapping_Hick_M_masks_results.txt                   
else 
   echo "No positive CMRO2 RRF calculated from BOLD and ASL beta coeffs clusters"                                                                              >> Overlapping_Hick_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc" "$ModelresultFolder/clustMap_MrrfPos_Hick+tlrc"   >> Overlapping_Hick_M_masks_results.txt      
             
else 
   echo "No negative CMRO2 RRF calculated from BOLD and ASL beta coeffs clusters"                                                                              >> Overlapping_Hick_M_masks_results.txt 
endif 




### testing CMRO2 positive with M intersection mask
if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2Pos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2Pos+tlrc.HEAD" "$ModelresultFolder/intersect_M_mask_hrf_Hick+tlrc"          >> Overlapping_Hick_M_masks_results.txt                
else 
   echo "No positive CMRO2 HRF clusters"                                                                                                                                                                 >> Overlapping_Hick_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD" "$ModelresultFolder/intersect_M_mask_rrf_Hick+tlrc"         >> Overlapping_Hick_M_masks_results.txt                 
else 
   echo "No positive CMRO2 RRF clusters"                                                                                                                              >> Overlapping_Hick_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc" "$ModelresultFolder/intersect_M_mask_hrf_Hick+tlrc"   >> Overlapping_Hick_M_masks_results.txt                  
else 
   echo "No positive CMRO2 HRF calculated from BOLD and ASL beta coeffs clusters"                                                                                     >> Overlapping_Hick_M_masks_results.txt 
endif 


if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc" "$ModelresultFolder/intersect_M_mask_rrf_Hick+tlrc"   >> Overlapping_Hick_M_masks_results.txt                   
else 
   echo "No positive CMRO2 RRF calculated from BOLD and ASL beta coeffs clusters"                                                                                     >> Overlapping_Hick_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc" "$ModelresultFolder/intersect_M_mask_rrf_Hick+tlrc"   >> Overlapping_Hick_M_masks_results.txt                 
else 
   echo "No negative CMRO2 RRF calculated from BOLD and ASL beta coeffs clusters"                                                                                     >> Overlapping_Hick_M_masks_results.txt 
endif 

#### ----------------------------------   tapping overlap   ----------------------------
echo "Computing the overlapping of both method of computing mask of active voxels."
echo " Overlapping results " >  Overlapping_tap_M_masks_results.txt

### testing CMRO2 positive with M clustered mask
if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2Pos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2Pos+tlrc.HEAD" "$ModelresultFolder/clustMap_MhrfPos_tap+tlrc"           >> Overlapping_tap_M_masks_results.txt                
else 
   echo "No positive CMRO2 HRF clusters"                                                                                                                                           >> Overlapping_tap_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD" "$ModelresultFolder/clustMap_MrrfPos_tap+tlrc"       >> Overlapping_tap_M_masks_results.txt                 
else 
   echo "No positive CMRO2 RRF clusters"                                                                                                                                           >> Overlapping_tap_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc" "$ModelresultFolder/clustMap_MhrfPos_tap+tlrc" >> Overlapping_tap_M_masks_results.txt                  
else 
   echo "No positive CMRO2 HRF calculated from BOLD and ASL beta coeffs clusters"                                                                                                  >> Overlapping_tap_M_masks_results.txt 
endif 


if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc" "$ModelresultFolder/clustMap_MrrfPos_tap+tlrc"   >> Overlapping_tap_M_masks_results.txt                   
else 
   echo "No positive CMRO2 RRF calculated from BOLD and ASL beta coeffs clusters"                                                                              >> Overlapping_tap_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc" "$ModelresultFolder/clustMap_MrrfPos_tap+tlrc"   >> Overlapping_tap_M_masks_results.txt      
             
else 
   echo "No negative CMRO2 RRF calculated from BOLD and ASL beta coeffs clusters"                                                                              >> Overlapping_tap_M_masks_results.txt 
endif 




### testing CMRO2 positive with M intersection mask
if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2Pos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2Pos+tlrc.HEAD" "$ModelresultFolder/intersect_M_mask_hrf_tap+tlrc"          >> Overlapping_tap_M_masks_results.txt                
else 
   echo "No positive CMRO2 HRF clusters"                                                                                                                              >> Overlapping_tap_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD" "$ModelresultFolder/intersect_M_mask_rrf_tap+tlrc"         >> Overlapping_tap_M_masks_results.txt                 
else 
   echo "No positive CMRO2 RRF clusters"                                                                                                                              >> Overlapping_tap_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc" "$ModelresultFolder/intersect_M_mask_hrf_tap+tlrc"   >> Overlapping_tap_M_masks_results.txt                  
else 
   echo "No positive CMRO2 HRF calculated from BOLD and ASL beta coeffs clusters"                                                                                     >> Overlapping_tap_M_masks_results.txt 
endif 


if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc" "$ModelresultFolder/intersect_M_mask_rrf_tap+tlrc"   >> Overlapping_tap_M_masks_results.txt                   
else 
   echo "No positive CMRO2 RRF calculated from BOLD and ASL beta coeffs clusters"                                                                                     >> Overlapping_tap_M_masks_results.txt 
endif 

if (-e "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc.HEAD") then
   3dABoverlap -no_automask "$githubFolder/results/task_versus_rest_clusterization_analysis/Model_results/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc" "$ModelresultFolder/intersect_M_mask_rrf_tap+tlrc"   >> Overlapping_tap_M_masks_results.txt                 
else 
   echo "No negative CMRO2 RRF calculated from BOLD and ASL beta coeffs clusters"                                                                                     >> Overlapping_tap_M_masks_results.txt 
endif 

echo "job finished"
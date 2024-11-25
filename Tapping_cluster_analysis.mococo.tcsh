#!/bin/tcsh -xef
# to execute via bash: 
#   tcsh -xef Tapping_cluster_analysis.mococo.tcsh 2>&1 | tee output.Tapping_cluster_analysis.mococo_18_09


### This program is used to analyse activation patterns on all subjects. As some outliers has been identified, there are usually lesser
### lines in the t-tests than there are subjects. The full test is usually commented at the end.
### One tests BOLD, a second tests ASL and the results are both used to compute an intersect mask that corresponds to voxels that are both 
### active in BOLD and ASL and in which we can measure CMRO2.
### The last study tests through t-test, the clusteres of CMRO2 regressed data directly. 
### We then do a DICE analysis and overlap count of voxels to see if we find similar stuff
### We already did some similar study on the mean CMRO2(t) regressed by tapping regressor, and threshold with arbitrary values. 
### We will here use the values empirically found (PW-pval 0.01 and BOLD PVal 0.007)
###
### Input data come from different analysis that have been done at different steps. BOLD and ASL come from the regular classic regression
### thus CMRO2_classic folder, while the CMRO2 regression have been done later (CMRO2_regression.allSubj.hick_tapping.tcsh) in the thesis and are found in the CMRO2_regression folder of each subject
###
## Important : The mean of every dataset has to be 0 because ttest tests against 0.
## It is possible to do paired t-tests with two datasets -setA and -setB



set Home = $PWD
set results_dir = '../results/tapping_task_versus_rest_clusterization_analysis'
set dataFolder  = '/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data'
set input_directory = "Analysis/CMRO2calc_classic"
set CMRO2_input_directory = "Analysis/CMRO2_regression"
set underlayMNI = "/home/mococo/abin/MNI152_2009_template_SSW.nii.gz"
set ImageFolder = "images"
set ModelresultFolder = "Model_results"

set atlas = "Schaefer_Yeo_17n_400 -atlas MNI_Glasser_HCP_v1.0 -atlas Brainnetome_1.0"
set interMask = "$ModelresultFolder/atlas_inter+tlrc"
set pValThreshold_PW = 0.01
set pValThreshold_BOLD = 0.005
set pValThreshold_CMRO2 = 0.01
set NN = 2
set mask =  "$Home/mask_group+tlrc"

mkdir -p $results_dir
cd $results_dir
mkdir -p $ModelresultFolder
mkdir -p $ImageFolder
mkdir -p $ModelresultFolder/ClustSimdata

set GMmask = "../meanGMmask+tlrc"


setenv AFNI_SUPP_ATLAS "/home/mococo/abin/AFNI_atlas_spaces.niml"

set subjects =  ('AlPu' 'AnCD' 'ArDC' 'BeMa' 'CeHa' 'ClBo' 'CoVB' 'DoBi' 'ElBe' 'ElCo' 'HiCh' 'JoDM' 'JoDP' 'LeGa' 'MaCh' 'MaKi' 'MaKM' 'MiAn' 'NaCa' 'NiDe' 'RaEM' 'RaZi' 'SaGa' 'SoSe')


## The mean of every dataset has to be 0 because ttest tests against 0.
# because : * With 1 set ('-setA'), the mean across input datasets (usually subjects)
#    is tested against 0.


### =======================================================================================
### ================================== Tapping ASL  =================================== ###
# if (! -e "./$ModelresultFolder/TtestTapping_PW+tlrc.HEAD" ) then
   3dttest++ -overwrite -prefix ./$ModelresultFolder/TtestTapping_PW                 \
            -resid ./$ModelresultFolder/errtsTapping_PW -ACF -Clustsim -prefix_clustsim ccTapping_PW -tempdir ./$ModelresultFolder/ClustSimdata \
            -mask $GMmask  -setA tapping_PW                                            \
            01 "$dataFolder/AlPu/${input_directory}/stats.PW3.AlPu+tlrc.BRIK[6]" \
            02 "$dataFolder/AnCD/${input_directory}/stats.PW3.AnCD+tlrc.BRIK[6]" \
            03 "$dataFolder/ArDC/${input_directory}/stats.PW3.ArDC+tlrc.BRIK[6]" \
            04 "$dataFolder/BeMa/${input_directory}/stats.PW3.BeMa+tlrc.BRIK[6]" \
            05 "$dataFolder/CeHa/${input_directory}/stats.PW3.CeHa+tlrc.BRIK[6]" \
            06 "$dataFolder/ClBo/${input_directory}/stats.PW3.ClBo+tlrc.BRIK[6]" \
            07 "$dataFolder/CoVB/${input_directory}/stats.PW3.CoVB+tlrc.BRIK[6]" \
            08 "$dataFolder/DoBi/${input_directory}/stats.PW3.DoBi+tlrc.BRIK[6]" \
            09 "$dataFolder/ElBe/${input_directory}/stats.PW3.ElBe+tlrc.BRIK[6]" \
            10 "$dataFolder/ElCo/${input_directory}/stats.PW3.ElCo+tlrc.BRIK[6]" \
            12 "$dataFolder/JoDM/${input_directory}/stats.PW3.JoDM+tlrc.BRIK[6]" \
            13 "$dataFolder/JoDP/${input_directory}/stats.PW3.JoDP+tlrc.BRIK[6]" \
            14 "$dataFolder/LeGa/${input_directory}/stats.PW3.LeGa+tlrc.BRIK[6]" \
            15 "$dataFolder/MaCh/${input_directory}/stats.PW3.MaCh+tlrc.BRIK[6]" \
            16 "$dataFolder/MaKi/${input_directory}/stats.PW3.MaKi+tlrc.BRIK[6]" \
            17 "$dataFolder/MaKM/${input_directory}/stats.PW3.MaKM+tlrc.BRIK[6]" \
            19 "$dataFolder/NaCa/${input_directory}/stats.PW3.NaCa+tlrc.BRIK[6]" \
            20 "$dataFolder/NiDe/${input_directory}/stats.PW3.NiDe+tlrc.BRIK[6]" \
            21 "$dataFolder/RaEM/${input_directory}/stats.PW3.RaEM+tlrc.BRIK[6]" \
            22 "$dataFolder/RaZi/${input_directory}/stats.PW3.RaZi+tlrc.BRIK[6]" \
            18 "$dataFolder/SaGa/${input_directory}/stats.PW3.SaGa+tlrc.BRIK[6]" \
            11 "$dataFolder/SoSe/${input_directory}/stats.PW3.SoSe+tlrc.BRIK[6]"
# endif
set ClustSizeTapping_PW = `1d_tool.py -infile ccTapping_PW.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThreshold_PW -csim_alpha 0.05 -verb 0`
mv ccTapping_PW.CSimA.NN2_1sided.1D temp.1D
rm -f ccTapping_PW.CSimA.NN*
mv temp.1D ccTapping_PW.CSimA.NN2_1sided.1D


set boundaryTapping_PW = `p2dsetstat -quiet -inset "./$ModelresultFolder/TtestTapping_PW+tlrc[1]" -1sided -pval $pValThreshold_PW`


3dClusterize -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTapping_PW+tlrc" -NN $NN -clust_nvox $ClustSizeTapping_PW -pref_map ./$ModelresultFolder/clustMapTapping_PWPos -pref_dat ./$ModelresultFolder/clustDataTapping_PWPos -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTapping_PW > ./$ModelresultFolder/clustResultsTapping_PWpos.1D
3dClusterize -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTapping_PW+tlrc" -NN $NN -clust_nvox $ClustSizeTapping_PW -pref_map ./$ModelresultFolder/clustMapTapping_PWNeg -pref_dat ./$ModelresultFolder/clustDataTapping_PWNeg -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTapping_PW > ./$ModelresultFolder/clustResultsTapping_PWneg.1D

set testPos=`cat $ModelresultFolder/clustResultsTapping_PWpos.1D`
set testNeg=`cat $ModelresultFolder/clustResultsTapping_PWneg.1D`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPos" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -bmask ./$ModelresultFolder/clustMapTapping_PWPos+tlrc -tab > posROIs_Tapping_PW.1D
   gen_cluster_table                                  \
           -input_map   $ModelresultFolder/clustMapTapping_PWPos+tlrc           \
           -input_atlas  ~/abin/Schaefer_17N_400.nii.gz   \
           -prefix      posROIs_Tapping_PW_table.1D
           
   set opref = "$ImageFolder/clustMapTapping_PW_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "./$ModelresultFolder/clustMapTapping_PWPos+tlrc"                        \
      -set_subbricks     0 -1 -1                                      \
      -ulay_range        0% 130%                                        \
      -cbar              ROI_i64                                        \
      -func_range        64                                             \
      -pbar_posonly                                                     \
      -opacity           6                                              \
      -prefix            ${opref}                                       \
      -set_xhairs        OFF                                            \
      -montx 3 -monty 3                                                 \
      -label_mode 1 -label_size 4
endif


if ("$testNeg" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file ./$ModelresultFolder/clustResultsTapping_PWneg.1D'[1,2,3]' -bmask ./$ModelresultFolder/clustMapTapping_PWNeg+tlrc -tab > negROIs_Tapping_PW.1D

   set opref = "$ImageFolder/clustMapTapping_PW_Neg"

   @chauffeur_afni                                                       \
      -ulay              "$underlayMNI"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "./$ModelresultFolder/clustMapTapping_PWNeg+tlrc"                        \
      -ulay_range        0% 130%                                        \
      -cbar              ROI_i64                                        \
      -func_range        64                                             \
      -pbar_posonly                                                     \
      -opacity           6                                              \
      -prefix            ${opref}                                       \
      -set_xhairs        OFF                                            \
      -montx 3 -monty 3                                                 \
      -label_mode 1 -label_size 4
endif

### =============================================================================================
### ======================================= Tapping BOLD  =================================== ###
# if (! -e "./$ModelresultFolder/TtestTapping_BOLD+tlrc.HEAD" ) then

   3dttest++ -overwrite -prefix ./$ModelresultFolder/TtestTapping_BOLD                 \
            -resid ./$ModelresultFolder/errts_Tapping_BOLD -ACF -Clustsim -prefix_clustsim ccTapping_BOLD -tempdir ./$ModelresultFolder/ClustSimdata \
            -mask $GMmask  -setA tapping_BOLD                                            \
            01 "$dataFolder/AlPu/${input_directory}/stats.MEC3.AlPu_REML+tlrc.BRIK[6]" \
            02 "$dataFolder/AnCD/${input_directory}/stats.MEC3.AnCD_REML+tlrc.BRIK[6]" \
            03 "$dataFolder/ArDC/${input_directory}/stats.MEC3.ArDC_REML+tlrc.BRIK[6]" \
            04 "$dataFolder/BeMa/${input_directory}/stats.MEC3.BeMa_REML+tlrc.BRIK[6]" \
            05 "$dataFolder/CeHa/${input_directory}/stats.MEC3.CeHa_REML+tlrc.BRIK[6]" \
            06 "$dataFolder/ClBo/${input_directory}/stats.MEC3.ClBo_REML+tlrc.BRIK[6]" \
            07 "$dataFolder/CoVB/${input_directory}/stats.MEC3.CoVB_REML+tlrc.BRIK[6]" \
            08 "$dataFolder/DoBi/${input_directory}/stats.MEC3.DoBi_REML+tlrc.BRIK[6]" \
            09 "$dataFolder/ElBe/${input_directory}/stats.MEC3.ElBe_REML+tlrc.BRIK[6]" \
            10 "$dataFolder/ElCo/${input_directory}/stats.MEC3.ElCo_REML+tlrc.BRIK[6]" \
            12 "$dataFolder/JoDM/${input_directory}/stats.MEC3.JoDM_REML+tlrc.BRIK[6]" \
            13 "$dataFolder/JoDP/${input_directory}/stats.MEC3.JoDP_REML+tlrc.BRIK[6]" \
            14 "$dataFolder/LeGa/${input_directory}/stats.MEC3.LeGa_REML+tlrc.BRIK[6]" \
            15 "$dataFolder/MaCh/${input_directory}/stats.MEC3.MaCh_REML+tlrc.BRIK[6]" \
            16 "$dataFolder/MaKi/${input_directory}/stats.MEC3.MaKi_REML+tlrc.BRIK[6]" \
            17 "$dataFolder/MaKM/${input_directory}/stats.MEC3.MaKM_REML+tlrc.BRIK[6]" \
            19 "$dataFolder/NaCa/${input_directory}/stats.MEC3.NaCa_REML+tlrc.BRIK[6]" \
            20 "$dataFolder/NiDe/${input_directory}/stats.MEC3.NiDe_REML+tlrc.BRIK[6]" \
            21 "$dataFolder/RaEM/${input_directory}/stats.MEC3.RaEM_REML+tlrc.BRIK[6]" \
            22 "$dataFolder/RaZi/${input_directory}/stats.MEC3.RaZi_REML+tlrc.BRIK[6]" \
            18 "$dataFolder/SaGa/${input_directory}/stats.MEC3.SaGa_REML+tlrc.BRIK[6]" \
            11 "$dataFolder/SoSe/${input_directory}/stats.MEC3.SoSe_REML+tlrc.BRIK[6]"
# endif
set ClustSizeTapping_BOLD = `1d_tool.py -infile ccTapping_BOLD.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThreshold_BOLD -csim_alpha 0.05 -verb 0`

mv ccTapping_BOLD.CSimA.NN2_1sided.1D temp.1D
rm -f ccTapping_BOLD.CSimA.NN*
mv temp.1D ccTapping_BOLD.CSimA.NN2_1sided.1D

set boundaryTapping_BOLD = `p2dsetstat -quiet -inset "./$ModelresultFolder/TtestTapping_BOLD+tlrc[1]" -1sided -pval $pValThreshold_BOLD`


3dClusterize -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTapping_BOLD+tlrc" -NN $NN -clust_nvox $ClustSizeTapping_BOLD -pref_map ./$ModelresultFolder/clustMapTapping_BOLDPos -pref_dat ./$ModelresultFolder/clustDataTapping_BOLDPos -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTapping_BOLD > ./$ModelresultFolder/clustResultsTapping_BOLDpos.1D
3dClusterize -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTapping_BOLD+tlrc" -NN $NN -clust_nvox $ClustSizeTapping_BOLD -pref_map ./$ModelresultFolder/clustMapTapping_BOLDNeg -pref_dat ./$ModelresultFolder/clustDataTapping_BOLDNeg -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTapping_BOLD > ./$ModelresultFolder/clustResultsTapping_BOLDneg.1D

set testPos=`cat $ModelresultFolder/clustResultsTapping_BOLDpos.1D`
set testNeg=`cat $ModelresultFolder/clustResultsTapping_BOLDneg.1D`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPos" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in BOLD data"
else
   whereami -space MNI -atlas $atlas -coord_file ./$ModelresultFolder/clustResultsTapping_BOLDpos.1D'[1,2,3]' -bmask ./$ModelresultFolder/clustMapTapping_BOLDPos+tlrc -tab > posROIs_Tapping_BOLD.1D

   set opref = "$ImageFolder/clustMapTapping_BOLD_Pos"

   @chauffeur_afni                                                       \
      -ulay              "$underlayMNI"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "./$ModelresultFolder/clustMapTapping_BOLDPos+tlrc"                        \
      -set_subbricks     0 -1 -1                                      \
      -ulay_range        0% 130%                                        \
      -cbar              ROI_i64                                        \
      -func_range        64                                             \
      -pbar_posonly                                                     \
      -opacity           6                                              \
      -prefix            ${opref}                                       \
      -set_xhairs        OFF                                            \
      -montx 3 -monty 3                                                 \
      -label_mode 1 -label_size 4

endif

if ("$testNeg" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in BOLD data"
else
   whereami -space MNI -atlas $atlas -coord_file ./$ModelresultFolder/clustResultsTapping_BOLDneg.1D'[1,2,3]' -bmask ./$ModelresultFolder/clustMapTapping_BOLDNeg+tlrc -tab > negROIs_Tapping_BOLD.1D

   set opref = "$ImageFolder/clustMapTapping_BOLD_Neg"

   @chauffeur_afni                                                       \
      -ulay              "$underlayMNI"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "./$ModelresultFolder/clustMapTapping_BOLDNeg+tlrc"                        \
      -ulay_range        0% 130%                                        \
      -set_subbricks     0 -1 -1                                      \
      -cbar              ROI_i64                                        \
      -func_range        64                                             \
      -pbar_posonly                                                     \
      -opacity           6                                              \
      -prefix            ${opref}                                       \
      -set_xhairs        OFF                                            \
      -montx 3 -monty 3                                                 \
      -label_mode 1 -label_size 4

endif


### =======================================================================================
## =================== finding common voxels between BOLD and ASL masks ===================
# Here, we compute the atlas_inter mask that regroups the voxels that are both present in BOLD clustered data and ASL clustered data
# This mask, or atlas is the one used in different analysis further along the pipeline
3dmask_tool -overwrite -input "./$ModelresultFolder/clustMapTapping_BOLDPos+tlrc.HEAD ./$ModelresultFolder/clustMapTapping_PWPos+tlrc.HEAD" -prefix ./$ModelresultFolder/atlas_inter \
            -inter


set opref = "$ImageFolder/clustMap_intersection_pos"

@chauffeur_afni                                                       \
   -ulay              "$underlayMNI"      \
   -box_focus_slices  AMASK_FOCUS_ULAY                               \
   -olay              "./$ModelresultFolder/atlas_inter+tlrc"                        \
   -ulay_range        0% 130%                                        \
   -set_subbricks     0 -1 -1                                      \
   -cbar              ROI_i64                                        \
   -func_range        64                                             \
   -pbar_posonly                                                     \
   -opacity           6                                              \
   -prefix            ${opref}                                       \
   -set_xhairs        OFF                                            \
   -montx 3 -monty 3                                                 \
   -label_mode 1 -label_size 4


### ==============================================================================================
### ======================================= Tapping CMRO2  =================================== ###
### We are here doing a ttest on the CMRO2 data that has been regressed individually.


# set fileName = "stats.CMRO2_HRF_tap+tlrc.HEAD'[2]'"

3dttest++ -overwrite -prefix ./$ModelresultFolder/TtestTapping_CMRO2_2                  \
         -resid ./$ModelresultFolder/errts_Tapping_CMRO2 -ACF -Clustsim -prefix_clustsim ccTapping_CMRO2 -tempdir ./$ModelresultFolder/ClustSimdata \
         -mask $GMmask  -setA tapping_CMRO2                                            \
         01 "$dataFolder/AlPu/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         02 "$dataFolder/AnCD/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         03 "$dataFolder/ArDC/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         04 "$dataFolder/BeMa/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         05 "$dataFolder/CeHa/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         06 "$dataFolder/ClBo/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         07 "$dataFolder/CoVB/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         08 "$dataFolder/DoBi/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         09 "$dataFolder/ElBe/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         10 "$dataFolder/ElCo/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         12 "$dataFolder/JoDM/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         13 "$dataFolder/JoDP/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         14 "$dataFolder/LeGa/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         15 "$dataFolder/MaCh/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         16 "$dataFolder/MaKi/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         17 "$dataFolder/MaKM/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         19 "$dataFolder/NaCa/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         20 "$dataFolder/NiDe/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         21 "$dataFolder/RaEM/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         22 "$dataFolder/RaZi/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         18 "$dataFolder/SaGa/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         24 "$dataFolder/MiAn/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         23 "$dataFolder/CeHa/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]" \
         11 "$dataFolder/SoSe/${CMRO2_input_directory}/stats.CMRO2_HRF_tap+tlrc.HEAD[2]"

set ClustSizeTapping_CMRO2 = `1d_tool.py -infile ccTapping_CMRO2.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThreshold_CMRO2 -csim_alpha 0.05 -verb 0`

mv ccTapping_CMRO2.CSimA.NN2_1sided.1D temp.1D
rm -f ccTapping_CMRO2.CSimA.NN*
mv temp.1D ccTapping_CMRO2.CSimA.NN2_1sided.1D

set boundaryTapping_CMRO2 = `p2dsetstat -quiet -inset "./$ModelresultFolder/TtestTapping_CMRO2+tlrc[1]" -1sided -pval $pValThreshold_CMRO2`


3dClusterize -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTapping_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeTapping_CMRO2 -pref_map ./$ModelresultFolder/clustMapTapping_CMRO2Pos -pref_dat ./$ModelresultFolder/clustDataTapping_CMRO2Pos -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTapping_CMRO2 > ./$ModelresultFolder/clustResultsTapping_CMRO2pos.1D
3dClusterize -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTapping_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeTapping_CMRO2 -pref_map ./$ModelresultFolder/clustMapTapping_CMRO2Neg -pref_dat ./$ModelresultFolder/clustDataTapping_CMRO2Neg -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTapping_CMRO2 > ./$ModelresultFolder/clustResultsTapping_CMRO2neg.1D

set testPos=`cat $ModelresultFolder/clustResultsTapping_CMRO2pos.1D`
set testNeg=`cat $ModelresultFolder/clustResultsTapping_CMRO2neg.1D`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPos" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in CMRO2 data"
else
   whereami -space MNI -atlas $atlas -coord_file ./$ModelresultFolder/clustResultsTapping_CMRO2pos.1D'[1,2,3]' -bmask ./$ModelresultFolder/clustMapTapping_CMRO2Pos+tlrc -tab > posROIs_Tapping_CMRO2.1D

   set opref = "$ImageFolder/clustMapTapping_CMRO2_Pos"

   @chauffeur_afni                                                       \
      -ulay              "$underlayMNI"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "./$ModelresultFolder/clustMapTapping_CMRO2Pos+tlrc"                        \
      -set_subbricks     0 -1 -1                                      \
      -ulay_range        0% 130%                                        \
      -cbar              ROI_i64                                        \
      -func_range        64                                             \
      -pbar_posonly                                                     \
      -opacity           6                                              \
      -prefix            ${opref}                                       \
      -set_xhairs        OFF                                            \
      -montx 3 -monty 3                                                 \
      -label_mode 1 -label_size 4

endif

if ("$testNeg" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in CMRO2 data"
else
   whereami -space MNI -atlas $atlas -coord_file ./$ModelresultFolder/clustResultsTapping_CMRO2neg.1D'[1,2,3]' -bmask ./$ModelresultFolder/clustMapTapping_CMRO2Neg+tlrc -tab > negROIs_Tapping_CMRO2.1D

   set opref = "$ImageFolder/clustMapTapping_CMRO2_Neg"

   @chauffeur_afni                                                       \
      -ulay              "$underlayMNI"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "./$ModelresultFolder/clustMapTapping_CMRO2Neg+tlrc"                        \
      -ulay_range        0% 130%                                        \
      -set_subbricks     0 -1 -1                                      \
      -cbar              ROI_i64                                        \
      -func_range        64                                             \
      -pbar_posonly                                                     \
      -opacity           6                                              \
      -prefix            ${opref}                                       \
      -set_xhairs        OFF                                            \
      -montx 3 -monty 3                                                 \
      -label_mode 1 -label_size 4
endif


### ==============================================================================================
### ====================== overlapping and DICE of the tso methods  ========================== ###
echo "Computing the overlapping of both method of computing mask of active voxels."
echo " Overlapping results "                                                                                                     >  Overlapping_masks_results.txt

if (-e $ModelresultFolder/clustMapTapping_CMRO2Pos+tlrc.HEAD) then
      3dABoverlap -no_automask $interMask "$ModelresultFolder/clustMapTapping_CMRO2Pos+tlrc.HEAD"                                >> Overlapping_masks_results.txt
else 
   echo "No positive cluster"
endif 

if (-e $ModelresultFolder/clustMapTapping_CMRO2Neg+tlrc.HEAD) then
      3dABoverlap -no_automask $interMask "$ModelresultFolder/clustMapTapping_CMRO2Neg+tlrc.HEAD"                                >> Overlapping_masks_results.txt           
else 
   echo "No negative cluster on CMRO2"
endif 

echo "job finished"



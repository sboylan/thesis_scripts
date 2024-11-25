#!/bin/tcsh -xef

# to execute via bash: 
#   tcsh -xef Hick_cluster_analysis.mococo.tcsh 2>&1 | tee output.Hick_cluster_analysis.mococo_26_09
### This program is used to analyse activation patterns on all subjects through a t-test. As some outliers has been identified, there are usually lesser
### lines in the t-tests than there are subjects. The full test is usually commented at the end.
### One tests BOLD, a second tests ASL and the results are both used to compute an intersect mask that corresponds to voxels that are both 
### active in BOLD and ASL and in which we can measure CMRO2.
### The last t-tests analyses the clusteres of CMRO2 regressed data directly. 
### We then do a DICE analysis and overlap count of voxels to see if we find similar stuff
### We already did some similar study on the mean CMRO2(t) regressed by tapping regressor, and threshold with arbitrary values. 
### We will here use the values empirically found (PW-pval 0.01 and BOLD PVal 0.007)
###
### Input data come from different analysis that have been done at different steps. BOLD and ASL come from the regular classic regression
### thus CMRO2_classic folder, while the CMRO2 regression have been done later (CMRO2_regression.allSubj.hick_tapping.tcsh) in the thesis and are found in the CMRO2_regression folder of each subject
###
### Analysis on CMRO2 are done in positive as well as negative clusters because CMRO2 has negative activation in Tapping task
### Newest modifications include a new t-test calculation for CMRO2 that have calculated from BOLD and ASL datasets directly.
### We then have to take into account that the CMRO2 mean is 1 not 0, contrary to BOLD, ASL and regressed CMRO2 dataset that are beta coefficients, thus mean around 0.


set Home = $PWD
set githubFolder = "/home/mococo/Documents/Simon_Boylan2/hick_entropy_analysis"
set results_dir = "$githubFolder/results/task_versus_rest_clusterization_analysis"
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

set regressors = ('hrf' 'rrf')
foreach reg ( $regressors )
   set file_name = M_${reg}_thresholded+tlrc
   if (! -f "./$ModelresultFolderName/TtestM_${reg}+tlrc.HEAD" ) then
      ## running 3dttest on TaskVsRest for PW
      3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestM_$reg               \
               -resid ./$ModelresultFolderName/errtsM_$reg -ACF -Clustsim -prefix_clustsim ccM_$reg -tempdir ./$ModelresultFolderName/ClustSimdata \
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
end

if (! -f "./$ModelresultFolderName/TtestTvsR_PW2+tlrc.HEAD" ) then
   ### ========== Task versus Rest ASL  ================= ###
   ## running 3dttest on TaskVsRest for PW
   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestTvsR_PW2                  \
            -resid ./$ModelresultFolderName/errtsTvsR_PW -ACF -Clustsim -prefix_clustsim ccTvsR_PW -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_PW                                            \
            01 "$dataFolder/AlPu/${input_directory}/stats.PW2_TvsR.AlPu+tlrc.BRIK[6]" \
            02 "$dataFolder/AnCD/${input_directory}/stats.PW2_TvsR.AnCD+tlrc.BRIK[6]" \
            03 "$dataFolder/ArDC/${input_directory}/stats.PW2_TvsR.ArDC+tlrc.BRIK[6]" \
            04 "$dataFolder/BeMa/${input_directory}/stats.PW2_TvsR.BeMa+tlrc.BRIK[6]" \
            06 "$dataFolder/ClBo/${input_directory}/stats.PW2_TvsR.ClBo+tlrc.BRIK[6]" \
            07 "$dataFolder/CoVB/${input_directory}/stats.PW2_TvsR.CoVB+tlrc.BRIK[6]" \
            08 "$dataFolder/DoBi/${input_directory}/stats.PW2_TvsR.DoBi+tlrc.BRIK[6]" \
            09 "$dataFolder/ElBe/${input_directory}/stats.PW2_TvsR.ElBe+tlrc.BRIK[6]" \
            10 "$dataFolder/ElCo/${input_directory}/stats.PW2_TvsR.ElCo+tlrc.BRIK[6]" \
            11 "$dataFolder/HiCh/${input_directory}/stats.PW2_TvsR.HiCh+tlrc.BRIK[6]" \
            12 "$dataFolder/JoDM/${input_directory}/stats.PW2_TvsR.JoDM+tlrc.BRIK[6]" \
            13 "$dataFolder/JoDP/${input_directory}/stats.PW2_TvsR.JoDP+tlrc.BRIK[6]" \
            14 "$dataFolder/LeGa/${input_directory}/stats.PW2_TvsR.LeGa+tlrc.BRIK[6]" \
            15 "$dataFolder/MaCh/${input_directory}/stats.PW2_TvsR.MaCh+tlrc.BRIK[6]" \
            16 "$dataFolder/MaKi/${input_directory}/stats.PW2_TvsR.MaKi+tlrc.BRIK[6]" \
            17 "$dataFolder/MaKM/${input_directory}/stats.PW2_TvsR.MaKM+tlrc.BRIK[6]" \
            19 "$dataFolder/NaCa/${input_directory}/stats.PW2_TvsR.NaCa+tlrc.BRIK[6]" \
            20 "$dataFolder/NiDe/${input_directory}/stats.PW2_TvsR.NiDe+tlrc.BRIK[6]" \
            21 "$dataFolder/RaEM/${input_directory}/stats.PW2_TvsR.RaEM+tlrc.BRIK[6]" \
            22 "$dataFolder/RaZi/${input_directory}/stats.PW2_TvsR.RaZi+tlrc.BRIK[6]" \
            23 "$dataFolder/BrMa/${input_directory}/stats.PW2_TvsR.BrMa+tlrc.BRIK[6]" \
            24 "$dataFolder/ElAc/${input_directory}/stats.PW2_TvsR.ElAc+tlrc.BRIK[6]" \
            18 "$dataFolder/SaGa/${input_directory}/stats.PW2_TvsR.SaGa+tlrc.BRIK[6]" \
            5 "$dataFolder/SoSe/${input_directory}/stats.PW2_TvsR.SoSe+tlrc.BRIK[6]"
endif


if (! -f "./$ModelresultFolderName/TtestTvsR_BOLD2+tlrc.HEAD" ) then
   ### ============= Task versus Rest BOLD  ================ ###
   ## running 3dttest on TaskVsRest for BOLD
   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestTvsR_BOLD2                  \
            -resid ./$ModelresultFolderName/errts_TvsR_BOLD -ACF -Clustsim -prefix_clustsim ccTvsR_BOLD -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_BOLD                                            \
            01 "$dataFolder/AlPu/${input_directory}/stats.MEC2_TvsR.AlPu_REML+tlrc.BRIK[6]" \
            02 "$dataFolder/AnCD/${input_directory}/stats.MEC2_TvsR.AnCD_REML+tlrc.BRIK[6]" \
            03 "$dataFolder/ArDC/${input_directory}/stats.MEC2_TvsR.ArDC_REML+tlrc.BRIK[6]" \
            04 "$dataFolder/BeMa/${input_directory}/stats.MEC2_TvsR.BeMa_REML+tlrc.BRIK[6]" \
            06 "$dataFolder/ClBo/${input_directory}/stats.MEC2_TvsR.ClBo_REML+tlrc.BRIK[6]" \
            07 "$dataFolder/CoVB/${input_directory}/stats.MEC2_TvsR.CoVB_REML+tlrc.BRIK[6]" \
            08 "$dataFolder/DoBi/${input_directory}/stats.MEC2_TvsR.DoBi_REML+tlrc.BRIK[6]" \
            09 "$dataFolder/ElBe/${input_directory}/stats.MEC2_TvsR.ElBe_REML+tlrc.BRIK[6]" \
            10 "$dataFolder/ElCo/${input_directory}/stats.MEC2_TvsR.ElCo_REML+tlrc.BRIK[6]" \
            11 "$dataFolder/HiCh/${input_directory}/stats.MEC2_TvsR.HiCh_REML+tlrc.BRIK[6]" \
            12 "$dataFolder/JoDM/${input_directory}/stats.MEC2_TvsR.JoDM_REML+tlrc.BRIK[6]" \
            13 "$dataFolder/JoDP/${input_directory}/stats.MEC2_TvsR.JoDP_REML+tlrc.BRIK[6]" \
            14 "$dataFolder/LeGa/${input_directory}/stats.MEC2_TvsR.LeGa_REML+tlrc.BRIK[6]" \
            15 "$dataFolder/MaCh/${input_directory}/stats.MEC2_TvsR.MaCh_REML+tlrc.BRIK[6]" \
            16 "$dataFolder/MaKi/${input_directory}/stats.MEC2_TvsR.MaKi_REML+tlrc.BRIK[6]" \
            17 "$dataFolder/MaKM/${input_directory}/stats.MEC2_TvsR.MaKM_REML+tlrc.BRIK[6]" \
            19 "$dataFolder/NaCa/${input_directory}/stats.MEC2_TvsR.NaCa_REML+tlrc.BRIK[6]" \
            20 "$dataFolder/NiDe/${input_directory}/stats.MEC2_TvsR.NiDe_REML+tlrc.BRIK[6]" \
            21 "$dataFolder/RaEM/${input_directory}/stats.MEC2_TvsR.RaEM_REML+tlrc.BRIK[6]" \
            22 "$dataFolder/RaZi/${input_directory}/stats.MEC2_TvsR.RaZi_REML+tlrc.BRIK[6]" \
            23 "$dataFolder/BrMa/${input_directory}/stats.MEC2_TvsR.BrMa_REML+tlrc.BRIK[6]" \
            24 "$dataFolder/ElAc/${input_directory}/stats.MEC2_TvsR.ElAc_REML+tlrc.BRIK[6]" \
            18 "$dataFolder/SaGa/${input_directory}/stats.MEC2_TvsR.SaGa_REML+tlrc.BRIK[6]" \
            5 "$dataFolder/SoSe/${input_directory}/stats.MEC2_TvsR.SoSe_REML+tlrc.BRIK[6]"
endif

if (! -f "./$ModelresultFolderName/TtestTvsR_CMRO2+tlrc.HEAD" ) then
   ### ========== Task versus Rest CMRO2  ================= ###
   ## running 3dttest on TaskVsRest for CMRO2 from regression datasets

   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestTvsR_CMRO2                  \
            -resid ./$ModelresultFolderName/errtsTvsR_CMRO2 -ACF -Clustsim -prefix_clustsim ccTvsR_CMRO2 -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_CMRO2                                            \
            01 "$dataFolder/AlPu/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            02 "$dataFolder/AnCD/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            03 "$dataFolder/ArDC/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            04 "$dataFolder/BeMa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            06 "$dataFolder/ClBo/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            07 "$dataFolder/CoVB/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            08 "$dataFolder/DoBi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            09 "$dataFolder/ElBe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            10 "$dataFolder/ElCo/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            11 "$dataFolder/HiCh/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            12 "$dataFolder/JoDM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            13 "$dataFolder/JoDP/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            14 "$dataFolder/LeGa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            15 "$dataFolder/MaCh/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            16 "$dataFolder/MaKi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            17 "$dataFolder/MaKM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            19 "$dataFolder/NaCa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            20 "$dataFolder/NiDe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            21 "$dataFolder/RaEM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            22 "$dataFolder/RaZi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            23 "$dataFolder/BrMa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            24 "$dataFolder/ElAc/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            5 "$dataFolder/SaGa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]" \
            18 "$dataFolder/SoSe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]"
endif

## ---------------------   CMRO2 ttest from calculated CMRO2 from beta coefficients of BOLD and ASL  ------------------
## running 3dttest on TaskVsRest for CMRO2 from BOLD and ASl beta coefs HRF   
## demeaning the CMRO2 datasets.
set dataToDemean = `ls $dataFolder/*/${input_directory}/CMRO2_TvsR_hrf+tlrc.BRIK`
set list = ()
set numberList = (`count -digits 2 1 24`)
set counter = 0
foreach dataset ($dataToDemean)
   set fileName = `echo $dataset | awk -F/ '{print $NF}'`
   set folderName = `echo $dataset | awk -F'data/' '{print $2}' | awk -F/ '{print $1}'`
   set newFileName = demeaned_${folderName}_${fileName}
   echo $newFileName
   if (! ("$folderName" == "CeHa") && ! ("$folderName" == "MiAn")) then
      @ counter = ($counter + 1)
      3dcalc -overwrite -a ${dataset} -b $GMmask\
               -exp 'b*(a-1)' -prefix ./$ModelresultFolderName/$newFileName 
      set list = ($list "$numberList[$counter] ./$ModelresultFolderName/$newFileName \ ")
   endif
end
echo $list

3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestTvsR_CMRO2_calculated_HRF \
         -resid ./$ModelresultFolderName/errts_CMRO2_calculated_HRF -ACF -Clustsim \
         -prefix_clustsim ccTvsR_CMRO2_calculated_HRF -tempdir ./$ModelresultFolderName/ClustSimdata \
         -mask $GMmask  -setA "taskVsRest_CMRO2_calculated_HRF" \
         01 ./Model_results/demeaned_AlPu_CMRO2_TvsR_hrf+tlrc.BRIK \
         02 ./Model_results/demeaned_AnCD_CMRO2_TvsR_hrf+tlrc.BRIK \
         03 ./Model_results/demeaned_ArDC_CMRO2_TvsR_hrf+tlrc.BRIK \
         04 ./Model_results/demeaned_BeMa_CMRO2_TvsR_hrf+tlrc.BRIK \
         05 ./Model_results/demeaned_BrMa_CMRO2_TvsR_hrf+tlrc.BRIK \
         06 ./Model_results/demeaned_ClBo_CMRO2_TvsR_hrf+tlrc.BRIK \
         07 ./Model_results/demeaned_CoVB_CMRO2_TvsR_hrf+tlrc.BRIK \
         08 ./Model_results/demeaned_DoBi_CMRO2_TvsR_hrf+tlrc.BRIK \
         09 ./Model_results/demeaned_ElAc_CMRO2_TvsR_hrf+tlrc.BRIK \
         10 ./Model_results/demeaned_ElBe_CMRO2_TvsR_hrf+tlrc.BRIK \
         11 ./Model_results/demeaned_ElCo_CMRO2_TvsR_hrf+tlrc.BRIK \
         12 ./Model_results/demeaned_HiCh_CMRO2_TvsR_hrf+tlrc.BRIK \
         13 ./Model_results/demeaned_JoDM_CMRO2_TvsR_hrf+tlrc.BRIK \
         14 ./Model_results/demeaned_JoDP_CMRO2_TvsR_hrf+tlrc.BRIK \
         15 ./Model_results/demeaned_LeGa_CMRO2_TvsR_hrf+tlrc.BRIK \
         16 ./Model_results/demeaned_MaCh_CMRO2_TvsR_hrf+tlrc.BRIK \
         17 ./Model_results/demeaned_MaKi_CMRO2_TvsR_hrf+tlrc.BRIK \
         18 ./Model_results/demeaned_MaKM_CMRO2_TvsR_hrf+tlrc.BRIK \
         19 ./Model_results/demeaned_NaCa_CMRO2_TvsR_hrf+tlrc.BRIK \
         20 ./Model_results/demeaned_NiDe_CMRO2_TvsR_hrf+tlrc.BRIK \
         21 ./Model_results/demeaned_RaEM_CMRO2_TvsR_hrf+tlrc.BRIK \
         22 ./Model_results/demeaned_RaZi_CMRO2_TvsR_hrf+tlrc.BRIK \
         23 ./Model_results/demeaned_SaGa_CMRO2_TvsR_hrf+tlrc.BRIK \
         24 ./Model_results/demeaned_SoSe_CMRO2_TvsR_hrf+tlrc.BRIK


   ## running 3dttest on TaskVsRest for CMRO2 from BOLD and ASl beta coefs HRF   
   ## demeaning the CMRO2 datasets.
   set dataToDemean = `ls $dataFolder/*/${input_directory}/CMRO2_TvsR_rrf+tlrc.BRIK`
   set list = ()
   set counter = 0
   foreach dataset ($dataToDemean)
      set fileName = `echo $dataset | awk -F/ '{print $NF}'`
      set folderName = `echo $dataset | awk -F'data/' '{print $2}' | awk -F/ '{print $1}'`
      set newFileName = demeaned_${folderName}_${fileName}
      echo $newFileName
      if (! ("$folderName" == "CeHa") && ! ("$folderName" == "MiAn")) then
         @ counter = ($counter + 1)
         3dcalc -overwrite -a ${dataset} -b $GMmask\
                  -exp 'b*(a-1)' -prefix ./$ModelresultFolderName/$newFileName
         set list = ($list "$numberList[$counter] ./$ModelresultFolderName/$newFileName \ ")
      endif
   end
   echo $list

   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestTvsR_CMRO2_calculated_RRF \
            -resid ./$ModelresultFolderName/errts_CMRO2_calculated_RRF -ACF -Clustsim -prefix_clustsim ccTvsR_CMRO2_calculated_RRF -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA "taskVsRest_CMRO2_calculated_RRF" \
            01 ./Model_results/demeaned_AlPu_CMRO2_TvsR_rrf+tlrc.BRIK \
            02 ./Model_results/demeaned_AnCD_CMRO2_TvsR_rrf+tlrc.BRIK \
            03 ./Model_results/demeaned_ArDC_CMRO2_TvsR_rrf+tlrc.BRIK \
            04 ./Model_results/demeaned_BeMa_CMRO2_TvsR_rrf+tlrc.BRIK \
            05 ./Model_results/demeaned_BrMa_CMRO2_TvsR_rrf+tlrc.BRIK \
            06 ./Model_results/demeaned_ClBo_CMRO2_TvsR_rrf+tlrc.BRIK \
            07 ./Model_results/demeaned_CoVB_CMRO2_TvsR_rrf+tlrc.BRIK \
            08 ./Model_results/demeaned_DoBi_CMRO2_TvsR_rrf+tlrc.BRIK \
            09 ./Model_results/demeaned_ElAc_CMRO2_TvsR_rrf+tlrc.BRIK \
            10 ./Model_results/demeaned_ElBe_CMRO2_TvsR_rrf+tlrc.BRIK \
            11 ./Model_results/demeaned_ElCo_CMRO2_TvsR_rrf+tlrc.BRIK \
            12 ./Model_results/demeaned_HiCh_CMRO2_TvsR_rrf+tlrc.BRIK \
            13 ./Model_results/demeaned_JoDM_CMRO2_TvsR_rrf+tlrc.BRIK \
            14 ./Model_results/demeaned_JoDP_CMRO2_TvsR_rrf+tlrc.BRIK \
            15 ./Model_results/demeaned_LeGa_CMRO2_TvsR_rrf+tlrc.BRIK \
            16 ./Model_results/demeaned_MaCh_CMRO2_TvsR_rrf+tlrc.BRIK \
            17 ./Model_results/demeaned_MaKi_CMRO2_TvsR_rrf+tlrc.BRIK \
            18 ./Model_results/demeaned_MaKM_CMRO2_TvsR_rrf+tlrc.BRIK \
            19 ./Model_results/demeaned_NaCa_CMRO2_TvsR_rrf+tlrc.BRIK \
            20 ./Model_results/demeaned_NiDe_CMRO2_TvsR_rrf+tlrc.BRIK \
            21 ./Model_results/demeaned_RaEM_CMRO2_TvsR_rrf+tlrc.BRIK \
            22 ./Model_results/demeaned_RaZi_CMRO2_TvsR_rrf+tlrc.BRIK \
            23 ./Model_results/demeaned_SaGa_CMRO2_TvsR_rrf+tlrc.BRIK \
            24 ./Model_results/demeaned_SoSe_CMRO2_TvsR_rrf+tlrc.BRIK

   ### ========== Condition 1 (H0) CMRO2  ================= ###
   ## running 3dttest on H0 for CMRO2
if (! -f "./$ModelresultFolderName/TtestH0_CMRO2+tlrc.HEAD" ) then

   # set fileName = "stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]"
   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestH0_CMRO2                  \
            -resid ./$ModelresultFolderName/errtsH0_CMRO2 -ACF -Clustsim -prefix_clustsim ccH0_CMRO2 -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_CMRO2                                            \
            01 "$dataFolder/AlPu/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            02 "$dataFolder/AnCD/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            03 "$dataFolder/ArDC/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            04 "$dataFolder/BeMa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            06 "$dataFolder/ClBo/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            07 "$dataFolder/CoVB/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            08 "$dataFolder/DoBi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            09 "$dataFolder/ElBe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            10 "$dataFolder/ElCo/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            11 "$dataFolder/HiCh/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            12 "$dataFolder/JoDM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            13 "$dataFolder/JoDP/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            14 "$dataFolder/LeGa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            15 "$dataFolder/MaCh/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            16 "$dataFolder/MaKi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            17 "$dataFolder/MaKM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            19 "$dataFolder/NaCa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            20 "$dataFolder/NiDe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            21 "$dataFolder/RaEM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            22 "$dataFolder/RaZi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            23 "$dataFolder/BrMa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            24 "$dataFolder/ElAc/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            5 "$dataFolder/SaGa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]" \
            18 "$dataFolder/SoSe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[2]"
endif

if (! -f "./$ModelresultFolderName/TtestH1_CMRO2+tlrc.HEAD" ) then
   ### ========== Condition 2 (H1) CMRO2  ================= ###
   ## running 3dttest on H1 for CMRO2
   # set fileName = "stats.stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[6]'"
   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestH1_CMRO2                  \
            -resid ./$ModelresultFolderName/errtsH1_CMRO2 -ACF -Clustsim -prefix_clustsim ccH1_CMRO2 -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_CMRO2                                            \
            01 "$dataFolder/AlPu/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            02 "$dataFolder/AnCD/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            03 "$dataFolder/ArDC/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            04 "$dataFolder/BeMa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            06 "$dataFolder/ClBo/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            07 "$dataFolder/CoVB/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            08 "$dataFolder/DoBi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            09 "$dataFolder/ElBe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            10 "$dataFolder/ElCo/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            11 "$dataFolder/HiCh/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            12 "$dataFolder/JoDM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            13 "$dataFolder/JoDP/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            14 "$dataFolder/LeGa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            15 "$dataFolder/MaCh/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            16 "$dataFolder/MaKi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            17 "$dataFolder/MaKM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            19 "$dataFolder/NaCa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            20 "$dataFolder/NiDe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            21 "$dataFolder/RaEM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            22 "$dataFolder/RaZi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            23 "$dataFolder/BrMa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            24 "$dataFolder/ElAc/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            5 "$dataFolder/SaGa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]" \
            18 "$dataFolder/SoSe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[6]"
endif

if (! -f "./$ModelresultFolderName/TtestH2_CMRO2+tlrc.HEAD" ) then
   ### ========== Condition 4 (H2) CMRO2  ================= ###
   ## running 3dttest on H2 for CMRO2
   # set fileName = "stats.CMRO2_HRF_Hick_conds+tlrc.HEAD'[10]'"
   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestH2_CMRO2                  \
            -resid ./$ModelresultFolderName/errtsH2_CMRO2 -ACF -Clustsim -prefix_clustsim ccH2_CMRO2 -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_CMRO2                                            \
            01 "$dataFolder/AlPu/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            02 "$dataFolder/AnCD/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            03 "$dataFolder/ArDC/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            04 "$dataFolder/BeMa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            06 "$dataFolder/ClBo/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            07 "$dataFolder/CoVB/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            08 "$dataFolder/DoBi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            09 "$dataFolder/ElBe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            10 "$dataFolder/ElCo/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            11 "$dataFolder/HiCh/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            12 "$dataFolder/JoDM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            13 "$dataFolder/JoDP/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            14 "$dataFolder/LeGa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            15 "$dataFolder/MaCh/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            16 "$dataFolder/MaKi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            17 "$dataFolder/MaKM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            19 "$dataFolder/NaCa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            20 "$dataFolder/NiDe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            21 "$dataFolder/RaEM/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            22 "$dataFolder/RaZi/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            23 "$dataFolder/BrMa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            24 "$dataFolder/ElAc/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            5 "$dataFolder/SaGa/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]" \
            18 "$dataFolder/SoSe/${CMRO2_input_directory}/stats.CMRO2_HRF_Hick_conds+tlrc.HEAD[10]"
endif

if (! -f "./$ModelresultFolderName/TtestTvsR_CMRO2_RRF+tlrc.HEAD" ) then
   ### ========== Task versus Rest CMRO2 RRF  ================= ###
   ## running 3dttest on TaskVsRest for CMRO2 RRF
   # set fileName = "stats.CMRO2_HRF_Hick_TvsR+tlrc.HEAD[2]"
   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestTvsR_CMRO2_RRF                  \
            -resid ./$ModelresultFolderName/errtsTvsR_CMRO2_RRF -ACF -Clustsim -prefix_clustsim ccTvsR_CMRO2_RRF -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_CMRO2_RRF                                            \
            01 "$dataFolder/AlPu/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            02 "$dataFolder/AnCD/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            03 "$dataFolder/ArDC/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            04 "$dataFolder/BeMa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            06 "$dataFolder/ClBo/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            07 "$dataFolder/CoVB/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            08 "$dataFolder/DoBi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            09 "$dataFolder/ElBe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            10 "$dataFolder/ElCo/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            11 "$dataFolder/HiCh/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            12 "$dataFolder/JoDM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            13 "$dataFolder/JoDP/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            14 "$dataFolder/LeGa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            15 "$dataFolder/MaCh/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            16 "$dataFolder/MaKi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            17 "$dataFolder/MaKM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            19 "$dataFolder/NaCa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            20 "$dataFolder/NiDe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            21 "$dataFolder/RaEM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            22 "$dataFolder/RaZi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            23 "$dataFolder/BrMa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            24 "$dataFolder/ElAc/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            5 "$dataFolder/SaGa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]" \
            18 "$dataFolder/SoSe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_TvsR+tlrc.HEAD[2]"
endif

   ### ========== Condition 1 (H0) CMRO2  ================= ###
   ## running 3dttest on H0 for CMRO2
   # set fileName = "stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]"

if (! -f "./$ModelresultFolderName/TtestH0_CMRO2_RRF+tlrc.HEAD" ) then
   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestH0_CMRO2_RRF                  \
            -resid ./$ModelresultFolderName/errtsH0_CMRO2_RRF -ACF -Clustsim -prefix_clustsim ccH0_CMRO2_RRF -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_CMRO2_RRF                                            \
            01 "$dataFolder/AlPu/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            02 "$dataFolder/AnCD/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            03 "$dataFolder/ArDC/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            04 "$dataFolder/BeMa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            06 "$dataFolder/ClBo/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            07 "$dataFolder/CoVB/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            08 "$dataFolder/DoBi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            09 "$dataFolder/ElBe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            10 "$dataFolder/ElCo/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            11 "$dataFolder/HiCh/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            12 "$dataFolder/JoDM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            13 "$dataFolder/JoDP/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            14 "$dataFolder/LeGa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            15 "$dataFolder/MaCh/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            16 "$dataFolder/MaKi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            17 "$dataFolder/MaKM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            19 "$dataFolder/NaCa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            20 "$dataFolder/NiDe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            21 "$dataFolder/RaEM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            22 "$dataFolder/RaZi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            23 "$dataFolder/BrMa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            24 "$dataFolder/ElAc/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            5 "$dataFolder/SaGa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]" \
            18 "$dataFolder/SoSe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[2]"
endif

if (! -f "./$ModelresultFolderName/TtestH1_CMRO2_RRF+tlrc.HEAD" ) then
   ### ========== Condition 2 (H1) CMRO2  ================= ###
   ## running 3dttest on H1 for CMRO2
   # set fileName = "stats.stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[6]'"
   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestH1_CMRO2_RRF                  \
            -resid ./$ModelresultFolderName/errtsH1_CMRO2_RRF -ACF -Clustsim -prefix_clustsim ccH1_CMRO2_RRF -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_CMRO2_RRF                                            \
            01 "$dataFolder/AlPu/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            02 "$dataFolder/AnCD/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            03 "$dataFolder/ArDC/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            04 "$dataFolder/BeMa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            06 "$dataFolder/ClBo/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            07 "$dataFolder/CoVB/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            08 "$dataFolder/DoBi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            09 "$dataFolder/ElBe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            10 "$dataFolder/ElCo/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            11 "$dataFolder/HiCh/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            12 "$dataFolder/JoDM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            13 "$dataFolder/JoDP/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            14 "$dataFolder/LeGa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            15 "$dataFolder/MaCh/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            16 "$dataFolder/MaKi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            17 "$dataFolder/MaKM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            19 "$dataFolder/NaCa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            20 "$dataFolder/NiDe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            21 "$dataFolder/RaEM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            22 "$dataFolder/RaZi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            23 "$dataFolder/BrMa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            24 "$dataFolder/ElAc/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            5 "$dataFolder/SaGa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]" \
            18 "$dataFolder/SoSe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[6]"
endif

if (! -f "./$ModelresultFolderName/TtestH2_CMRO2_RRF+tlrc.HEAD" ) then
   ### ========== Condition 4 (H2) CMRO2  ================= ###
   ## running 3dttest on H2 for CMRO2
   # set fileName = "stats.CMRO2_RRF_Hick_conds+tlrc.HEAD'[10]'"
   3dttest++ -overwrite -prefix ./$ModelresultFolderName/TtestH2_CMRO2_RRF                  \
            -resid ./$ModelresultFolderName/errtsH2_CMRO2_RRF -ACF -Clustsim -prefix_clustsim ccH2_CMRO2_RRF -tempdir ./$ModelresultFolderName/ClustSimdata \
            -mask $GMmask  -setA taskVsRest_CMRO2_RRF                                            \
            01 "$dataFolder/AlPu/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            02 "$dataFolder/AnCD/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            03 "$dataFolder/ArDC/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            04 "$dataFolder/BeMa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            06 "$dataFolder/ClBo/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            07 "$dataFolder/CoVB/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            08 "$dataFolder/DoBi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            09 "$dataFolder/ElBe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            10 "$dataFolder/ElCo/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            11 "$dataFolder/HiCh/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            12 "$dataFolder/JoDM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            13 "$dataFolder/JoDP/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            14 "$dataFolder/LeGa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            15 "$dataFolder/MaCh/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            16 "$dataFolder/MaKi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            17 "$dataFolder/MaKM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            19 "$dataFolder/NaCa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            20 "$dataFolder/NiDe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            21 "$dataFolder/RaEM/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            22 "$dataFolder/RaZi/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            23 "$dataFolder/BrMa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            24 "$dataFolder/ElAc/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            5 "$dataFolder/SaGa/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]" \
            18 "$dataFolder/SoSe/${CMRO2_input_directory}/stats.CMRO2_RRF_Hick_conds+tlrc.HEAD[10]"
endif

### =======================     BOLD & ASL     =========================================
### BOLD ans ASL analysis with PW pval = 0.01 and BOLD pVal = 0.007

set pValThresholdPW = 0.01
set pValThresholdBOLD = 0.007
set suffix_atlas = "_${pValThresholdPW}_${pValThresholdBOLD}"

## PW analysis
set boundaryTvsR_PW = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestTvsR_PW2+tlrc[1]" -1sided -pval $pValThresholdPW`
set ClustSizeTvsR_PW = `1d_tool.py -infile ccTvsR_PW.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdPW -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_PW2+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_PW -pref_map "$ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}" -pref_dat "$ModelresultFolder/clustDataTvsR_PWPos${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_PW > "$ModelresultFolder/clustResultsTvsR_PWpos${suffix_atlas}.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_PW2+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_PW -pref_map "$ModelresultFolder/clustMapTvsR_PWNeg${suffix_atlas}" -pref_dat "$ModelresultFolder/clustDataTvsR_PWNeg${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_PW > "$ModelresultFolder/clustResultsTvsR_PWneg${suffix_atlas}.1D"

set testPosPW=`cat "$ModelresultFolder/clustResultsTvsR_PWpos${suffix_atlas}.1D"`
set testNegPW=`cat "$ModelresultFolder/clustResultsTvsR_PWneg${suffix_atlas}.1D"`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosPW" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_PWpos${suffix_atlas}.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}+tlrc -tab > posROIs_TvsR_PW.1D

   set opref = "$ImageFolder/clustMapTvsR_PW_Pos${suffix_atlas}"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}+tlrc"                        \
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


## BOLD analysis
set ClustSizeTvsR_BOLD = `1d_tool.py -infile ccTvsR_BOLD.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdBOLD -csim_alpha 0.05 -verb 0`
set boundaryTvsR_BOLD = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestTvsR_BOLD2+tlrc[1]" -1sided -pval $pValThresholdBOLD`


3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_BOLD2+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_BOLD -pref_map $ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas} -pref_dat $ModelresultFolder/clustDataTvsR_BOLDPos${suffix_atlas} -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_BOLD > $ModelresultFolder/clustResultsTvsR_BOLDpos${suffix_atlas}.1D
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_BOLD2+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_BOLD -pref_map $ModelresultFolder/clustMapTvsR_BOLDNeg${suffix_atlas} -pref_dat $ModelresultFolder/clustDataTvsR_BOLDNeg${suffix_atlas} -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_BOLD > $ModelresultFolder/clustResultsTvsR_BOLDneg${suffix_atlas}.1D

set testPosBOLD=`cat $ModelresultFolder/clustResultsTvsR_BOLDpos${suffix_atlas}.1D`
set testNegBOLD=`cat $ModelresultFolder/clustResultsTvsR_BOLDneg${suffix_atlas}.1D`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosBOLD" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in BOLD data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_BOLDpos${suffix_atlas}.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}+tlrc -tab > posROIs_TvsR_BOLD.1D
endif

set opref = "$ImageFolder/clustMapTvsR_BOLD_Pos${suffix_atlas}"

@chauffeur_afni                                                       \
   -ulay              "$underlayMNI"                                  \
   -box_focus_slices  AMASK_FOCUS_ULAY                                \
   -olay              "$ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}+tlrc"\
   -set_subbricks     0 -1 -1                                         \
   -ulay_range        0% 130%                                         \
   -cbar              ROI_i64                                         \
   -func_range        64                                              \
   -pbar_posonly                                                      \
   -opacity           6                                               \
   -prefix            ${opref}                                        \
   -set_xhairs        OFF                                             \
   -montx 3 -monty 3                                                  \
   -label_mode 1 -label_size 4


### finding common voxels between masks ###
if (! ("$testPosBOLD" == "#** NO CLUSTERS FOUND ***") && ! ("$testPosPW" == "#** NO CLUSTERS FOUND ***")) then

   3dmask_tool -overwrite -input "$ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}+tlrc.HEAD $ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}+tlrc.HEAD" -prefix $ModelresultFolder/atlas_inter \
               -inter

   3dclust -dxyz=3 -1Dformat -NN2  $ModelresultFolder/atlas_inter+tlrc > $ModelresultFolder/clustResults_atlas_inter.1D
   whereami -atlas $atlas -coord_file $ModelresultFolder/clustResults_atlas_inter.1D'[1,2,3]' -bmask $ModelresultFolder/atlas_inter+tlrc -tab > posROIs_atlas_inter.1D


   set opref = "$ImageFolder/clustMap_intersection_pos${suffix_atlas}"

   @chauffeur_afni                                                      \
      -ulay              "$underlayMNI"                                 \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/atlas_inter+tlrc"        \
      -ulay_range        0% 130%                                        \
      -set_subbricks     0 -1 -1                                        \
      -cbar              ROI_i64                                        \
      -func_range        64                                             \
      -pbar_posonly                                                     \
      -opacity           6                                              \
      -prefix            ${opref}                                       \
      -set_xhairs        OFF                                            \
      -montx 3 -monty 3                                                 \
      -label_mode 1 -label_size 4

endif


### ===============================    CMRO2    ========================================
### CMRO2 task versus rest analysis from regression with pval = 0.01

set pValThresholdCMRO2 = 0.01

## CMRO2 analysis
set boundaryTvsR_CMRO2 = `p2dsetstat -quiet -inset $ModelresultFolder/TtestTvsR_CMRO2+tlrc'[1]' -1sided -pval $pValThresholdCMRO2`
set ClustSizeTvsR_CMRO2 = `1d_tool.py -infile ccTvsR_CMRO2.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_CMRO2 -pref_map "$ModelresultFolder/clustMapTvsR_CMRO2Pos" -pref_dat "$ModelresultFolder/clustDataTvsR_CMRO2Pos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_CMRO2 > "$ModelresultFolder/clustResultsTvsR_CMRO2pos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_CMRO2 -pref_map "$ModelresultFolder/clustMapTvsR_CMRO2Neg" -pref_dat "$ModelresultFolder/clustDataTvsR_CMRO2Neg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_CMRO2 > "$ModelresultFolder/clustResultsTvsR_CMRO2neg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsTvsR_CMRO2pos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsTvsR_CMRO2neg.1D"`

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_CMRO2pos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_CMRO2Pos+tlrc -tab > posROIs_TvsR_CMRO2.1D

   set opref = "$ImageFolder/clustMapTvsR_CMRO2_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapTvsR_CMRO2Pos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_CMRO2neg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_CMRO2Neg+tlrc -tab > negROIs_TvsR_CMRO2.1D

   set opref = "$ImageFolder/clustMapTvsR_CMRO2_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapTvsR_CMRO2Neg+tlrc"                        \
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



## --------------------------------  calculated --------------------------------
### CMRO2 task versus rest analysis from BOLD and ASL beta coeffs with pval = 0.01

set boundaryTvsR_CMRO2 = `p2dsetstat -quiet -inset $ModelresultFolder/TtestTvsR_CMRO2_calculated_HRF+tlrc'[1]' -1sided -pval $pValThresholdCMRO2`
set ClustSizeTvsR_CMRO2 = `1d_tool.py -infile ccTvsR_CMRO2_calculated_HRF.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_CMRO2_calculated_HRF+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_CMRO2 -pref_map "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos" -pref_dat "$ModelresultFolder/clustDataTvsR_CMRO2_calculated_HRFPos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_CMRO2 > "$ModelresultFolder/clustResultsTvsR_CMRO2_calculated_HRFpos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_CMRO2_calculated_HRF+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_CMRO2 -pref_map "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFNeg" -pref_dat "$ModelresultFolder/clustDataTvsR_CMRO2_calculated_HRFNeg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_CMRO2 > "$ModelresultFolder/clustResultsTvsR_CMRO2_calculated_HRFneg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsTvsR_CMRO2_calculated_HRFpos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsTvsR_CMRO2_calculated_HRFneg.1D"`

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_CMRO2_calculated_HRFpos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc -tab > posROIs_TvsR_CMRO2_calculated_HRF.1D

   set opref = "$ImageFolder/clustMapTvsR_CMRO2_calculated_HRF_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_CMRO2_calculated_HRFneg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFNeg+tlrc -tab > negROIs_TvsR_CMRO2_calculated_HRF.1D

   set opref = "$ImageFolder/clustMapTvsR_CMRO2_calculated_HRF_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFNeg+tlrc"                        \
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


## --------------------------------   H0   -----------------------------------------
## CMRO2 analysis H0 from regression
set boundaryH0_CMRO2 = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestH0_CMRO2+tlrc[1]" -1sided -pval $pValThresholdCMRO2`
set ClustSizeH0_CMRO2 = `1d_tool.py -infile ccH0_CMRO2.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH0_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeH0_CMRO2 -pref_map "$ModelresultFolder/clustMapH0_CMRO2Pos" -pref_dat "$ModelresultFolder/clustDataH0_CMRO2Pos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryH0_CMRO2 > "$ModelresultFolder/clustResultsH0_CMRO2pos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH0_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeH0_CMRO2 -pref_map "$ModelresultFolder/clustMapH0_CMRO2Neg" -pref_dat "$ModelresultFolder/clustDataH0_CMRO2Neg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryH0_CMRO2 > "$ModelresultFolder/clustResultsH0_CMRO2neg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsH0_CMRO2pos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsH0_CMRO2neg.1D"`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH0_CMRO2pos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH0_CMRO2Pos+tlrc -tab > posROIs_H0_CMRO2.1D

   set opref = "$ImageFolder/clustMapH0_CMRO2_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH0_CMRO2Pos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH0_CMRO2neg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH0_CMRO2Neg+tlrc -tab > negROIs_H0_CMRO2.1D

   set opref = "$ImageFolder/clustMapH0_CMRO2_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH0_CMRO2Neg+tlrc"                        \
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

## --------------------------------   H1   -----------------------------------------
## CMRO2 analysis H1
set boundaryH1_CMRO2 = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestH1_CMRO2+tlrc[1]" -1sided -pval $pValThresholdCMRO2`
set ClustSizeH1_CMRO2 = `1d_tool.py -infile ccH1_CMRO2.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH1_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeH1_CMRO2 -pref_map "$ModelresultFolder/clustMapH1_CMRO2Pos" -pref_dat "$ModelresultFolder/clustDataH1_CMRO2Pos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryH1_CMRO2 > "$ModelresultFolder/clustResultsH1_CMRO2pos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH1_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeH1_CMRO2 -pref_map "$ModelresultFolder/clustMapH1_CMRO2Neg" -pref_dat "$ModelresultFolder/clustDataH1_CMRO2Neg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryH1_CMRO2 > "$ModelresultFolder/clustResultsH1_CMRO2neg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsH1_CMRO2pos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsH1_CMRO2neg.1D"`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH1_CMRO2pos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH1_CMRO2Pos+tlrc -tab > posROIs_H1_CMRO2.1D

   set opref = "$ImageFolder/clustMapH1_CMRO2_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH1_CMRO2Pos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH1_CMRO2neg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH1_CMRO2Neg+tlrc -tab > negROIs_H1_CMRO2.1D

   set opref = "$ImageFolder/clustMapH1_CMRO2_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH1_CMRO2Neg+tlrc"                        \
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
## --------------------------------   H2   ------------------------------------------
## CMRO2 analysis H2
set boundaryH2_CMRO2 = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestH2_CMRO2+tlrc[1]" -1sided -pval $pValThresholdCMRO2`
set ClustSizeH2_CMRO2 = `1d_tool.py -infile ccH2_CMRO2.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH2_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeH2_CMRO2 -pref_map "$ModelresultFolder/clustMapH2_CMRO2Pos" -pref_dat "$ModelresultFolder/clustDataH2_CMRO2Pos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryH2_CMRO2 > "$ModelresultFolder/clustResultsH2_CMRO2pos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH2_CMRO2+tlrc" -NN $NN -clust_nvox $ClustSizeH2_CMRO2 -pref_map "$ModelresultFolder/clustMapH2_CMRO2Neg" -pref_dat "$ModelresultFolder/clustDataH2_CMRO2Neg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryH2_CMRO2 > "$ModelresultFolder/clustResultsH2_CMRO2neg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsH2_CMRO2pos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsH2_CMRO2neg.1D"`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH2_CMRO2pos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH2_CMRO2Pos+tlrc -tab > posROIs_H2_CMRO2.1D

   set opref = "$ImageFolder/clustMapH2_CMRO2_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH2_CMRO2Pos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH2_CMRO2neg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH2_CMRO2Neg+tlrc -tab > negROIs_H2_CMRO2.1D

   set opref = "$ImageFolder/clustMapH2_CMRO2_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH2_CMRO2Neg+tlrc"                        \
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

### ===============================    CMRO2  RRF  ========================================
### CMRO2 RRF task versus rest analysis with pval = 0.01

set pValThresholdCMRO2 = 0.01

## CMRO2 analysis
set boundaryTvsR_CMRO2 = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestTvsR_CMRO2_RRF+tlrc[1]" -1sided -pval $pValThresholdCMRO2`
set ClustSizeTvsR_CMRO2 = `1d_tool.py -infile ccTvsR_CMRO2_RRF.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_CMRO2_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_CMRO2 -pref_map "$ModelresultFolder/clustMapTvsR_CMRO2_RRFPos" -pref_dat "$ModelresultFolder/clustDataTvsR_CMRO2_RRFPos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_CMRO2 > "$ModelresultFolder/clustResultsTvsR_CMRO2_RRFpos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_CMRO2_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_CMRO2 -pref_map "$ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg" -pref_dat "$ModelresultFolder/clustDataTvsR_CMRO2_RRFNeg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_CMRO2 > "$ModelresultFolder/clustResultsTvsR_CMRO2_RRFneg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsTvsR_CMRO2_RRFpos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsTvsR_CMRO2_RRFneg.1D"`

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in CMRO2 RRF data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_CMRO2_RRFpos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_CMRO2_RRFPos+tlrc -tab > posROIs_TvsR_CMRO2_RRF.1D

   set opref = "$ImageFolder/clustMapTvsR_CMRO2_RRF_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapTvsR_CMRO2_RRFPos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_CMRO2_RRFneg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg+tlrc -tab > negROIs_TvsR_CMRO2_RRF.1D

   set opref = "$ImageFolder/clustMapTvsR_CMRO2_RRF_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg+tlrc"                        \
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

## --------------------------------  calculated --------------------------------
### CMRO2 task versus rest analysis from BOLD and ASL beta coeffs with pval = 0.01
set boundaryTvsR_CMRO2 = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestTvsR_CMRO2_calculated_RRF+tlrc[1]" -1sided -pval $pValThresholdCMRO2`
set ClustSizeTvsR_CMRO2 = `1d_tool.py -infile ccTvsR_CMRO2_calculated_RRF.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_CMRO2_calculated_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_CMRO2 -pref_map "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFPos" -pref_dat "$ModelresultFolder/clustDataTvsR_CMRO2_calculated_RRFPos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_CMRO2 > "$ModelresultFolder/clustResultsTvsR_CMRO2_calculated_RRFpos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestTvsR_CMRO2_calculated_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_CMRO2 -pref_map "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFNeg" -pref_dat "$ModelresultFolder/clustDataTvsR_CMRO2_calculated_RRFNeg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_CMRO2 > "$ModelresultFolder/clustResultsTvsR_CMRO2_calculated_RRFneg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsTvsR_CMRO2_calculated_RRFpos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsTvsR_CMRO2_calculated_RRFneg.1D"`

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_CMRO2_calculated_RRFpos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc -tab > posROIs_TvsR_CMRO2_calculated_RRF.1D

   set opref = "$ImageFolder/clustMapTvsR_CMRO2_calculated_RRF_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsTvsR_CMRO2_calculated_RRFneg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc -tab > negROIs_TvsR_CMRO2_calculated_RRF.1D

   set opref = "$ImageFolder/clustMapTvsR_CMRO2_calculated_RRF_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFNeg+tlrc"                        \
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


## --------------------------------   H0   -----------------------------------------
## CMRO2_RRF analysis H0 regressed
set boundaryH0_CMRO2 = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestH0_CMRO2_RRF+tlrc[1]" -1sided -pval $pValThresholdCMRO2`
set ClustSizeH0_CMRO2 = `1d_tool.py -infile ccH0_CMRO2_RRF.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH0_CMRO2_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeH0_CMRO2 -pref_map "$ModelresultFolder/clustMapH0_CMRO2_RRFPos" -pref_dat "$ModelresultFolder/clustDataH0_CMRO2_RRFPos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryH0_CMRO2 > "$ModelresultFolder/clustResultsH0_CMRO2_RRFpos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH0_CMRO2_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeH0_CMRO2 -pref_map "$ModelresultFolder/clustMapH0_CMRO2_RRFNeg" -pref_dat "$ModelresultFolder/clustDataH0_CMRO2_RRFNeg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryH0_CMRO2 > "$ModelresultFolder/clustResultsH0_CMRO2_RRFneg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsH0_CMRO2_RRFpos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsH0_CMRO2_RRFneg.1D"`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH0_CMRO2_RRFpos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH0_CMRO2_RRFPos+tlrc -tab > posROIs_H0_CMRO2_RRF.1D

   set opref = "$ImageFolder/clustMapH0_CMRO2_RRF_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH0_CMRO2_RRFPos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH0_CMRO2_RRFneg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH0_CMRO2_RRFNeg+tlrc -tab > negROIs_H0_CMRO2_RRF.1D

   set opref = "$ImageFolder/clustMapH0_CMRO2_RRF_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH0_CMRO2_RRFNeg+tlrc"                        \
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

## --------------------------------   H1   -----------------------------------------
## CMRO2_RRF analysis H1 regressed
set boundaryH1_CMRO2 = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestH1_CMRO2_RRF+tlrc[1]" -1sided -pval $pValThresholdCMRO2`
set ClustSizeH1_CMRO2 = `1d_tool.py -infile ccH1_CMRO2_RRF.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH1_CMRO2_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeH1_CMRO2 -pref_map "$ModelresultFolder/clustMapH1_CMRO2_RRFPos" -pref_dat "$ModelresultFolder/clustDataH1_CMRO2_RRFPos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryH1_CMRO2 > "$ModelresultFolder/clustResultsH1_CMRO2_RRFpos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH1_CMRO2_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeH1_CMRO2 -pref_map "$ModelresultFolder/clustMapH1_CMRO2_RRFNeg" -pref_dat "$ModelresultFolder/clustDataH1_CMRO2_RRFNeg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryH1_CMRO2 > "$ModelresultFolder/clustResultsH1_CMRO2_RRFneg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsH1_CMRO2_RRFpos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsH1_CMRO2_RRFneg.1D"`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH1_CMRO2_RRFpos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH1_CMRO2_RRFPos+tlrc -tab > posROIs_H1_CMRO2_RRF.1D

   set opref = "$ImageFolder/clustMapH1_CMRO2_RRF_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH1_CMRO2_RRFPos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH1_CMRO2_RRFneg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH1_CMRO2_RRFNeg+tlrc -tab > negROIs_H1_CMRO2_RRF.1D

   set opref = "$ImageFolder/clustMapH1_CMRO2_RRF_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH1_CMRO2_RRFNeg+tlrc"                        \
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
## --------------------------------   H2   ------------------------------------------
## CMRO2_RRF analysis H2 regressed
set boundaryH2_CMRO2 = `p2dsetstat -quiet -inset "$ModelresultFolder/TtestH2_CMRO2_RRF+tlrc[1]" -1sided -pval $pValThresholdCMRO2`
set ClustSizeH2_CMRO2 = `1d_tool.py -infile ccH2_CMRO2_RRF.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThresholdCMRO2 -csim_alpha 0.05 -verb 0`

3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH2_CMRO2_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeH2_CMRO2 -pref_map "$ModelresultFolder/clustMapH2_CMRO2_RRFPos" -pref_dat "$ModelresultFolder/clustDataH2_CMRO2_RRFPos" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryH2_CMRO2 > "$ModelresultFolder/clustResultsH2_CMRO2_RRFpos.1D"
3dClusterize -overwrite -noabs -1Dformat -inset "$ModelresultFolder/TtestH2_CMRO2_RRF+tlrc" -NN $NN -clust_nvox $ClustSizeH2_CMRO2 -pref_map "$ModelresultFolder/clustMapH2_CMRO2_RRFNeg" -pref_dat "$ModelresultFolder/clustDataH2_CMRO2_RRFNeg" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryH2_CMRO2 > "$ModelresultFolder/clustResultsH2_CMRO2_RRFneg.1D"

set testPosCMRO2=`cat "$ModelresultFolder/clustResultsH2_CMRO2_RRFpos.1D"`
set testNegCMRO2=`cat "$ModelresultFolder/clustResultsH2_CMRO2_RRFneg.1D"`


# identifying the ROIs of the clusters and printing the results in txt file
if ("$testPosCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for positively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH2_CMRO2_RRFpos.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH2_CMRO2_RRFPos+tlrc -tab > posROIs_H2_CMRO2_RRF.1D

   set opref = "$ImageFolder/clustMapH2_CMRO2_RRF_Pos"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH2_CMRO2_RRFPos+tlrc"                        \
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

# identifying the ROIs of the clusters and printing the results in txt file
if ("$testNegCMRO2" == "#** NO CLUSTERS FOUND ***" ) then
   echo "no clusters found for negatively activated voxels in ASL data"
else
   whereami -space MNI -atlas $atlas -coord_file $ModelresultFolder/clustResultsH2_CMRO2_RRFneg.1D'[1,2,3]' -bmask $ModelresultFolder/clustMapH2_CMRO2_RRFNeg+tlrc -tab > negROIs_H2_CMRO2_RRF.1D

   set opref = "$ImageFolder/clustMapH2_CMRO2_RRF_Neg"

   @chauffeur_afni                                                       \
      -ulay              "${underlayMNI}"      \
      -box_focus_slices  AMASK_FOCUS_ULAY                               \
      -olay              "$ModelresultFolder/clustMapH2_CMRO2_RRFNeg+tlrc"                        \
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
### ==============================================================================================
### ====================== overlapping and DICE of the tso methods  ========================== ###

echo "Computing the overlapping of both method of computing mask of active voxels."
echo " Overlapping results " >  Overlapping_masks_results_factor.txt

## testing CMRO2 positive with intersection mask
if (-e $ModelresultFolder/clustMapTvsR_CMRO2Pos+tlrc.HEAD) then
   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_CMRO2Pos+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   # set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_CMRO2Pos+tlrc"`
   # set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_CMRO2Pos+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   # set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   # echo "number of overlapping voxels between CMRO2 HRF and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   # echo "number of total voxels in CMRO2 HRF clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of CMRO2 HRF mask voxels" >> Overlapping_masks_results_factor.txt              
else 
   echo "No positive CMRO2 HRF clusters" >> Overlapping_masks_results_factor.txt 
endif 

if (-e $ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc.HEAD) then

   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   # set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc"`
   # set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_RRFPos+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   # set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   # echo "number of overlapping voxels between CMRO2 RRF calculated from BOLD and ASL beta coeffs and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   # echo "number of total voxels in CMRO2 RRF calculated from BOLD and ASL beta coeffs clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of CMRO2 RRF calculated from BOLD and ASL beta coeffs mask voxels" >> Overlapping_masks_results_factor.txt              
else 
   echo "No positive CMRO2 RRF calculated from BOLD and ASL beta coeffs clusters" >> Overlapping_masks_results_factor.txt 
endif 

if (-e $ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc.HEAD) then
   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   # set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc"`
   # set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_CMRO2_calculated_HRFPos+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   # set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   # echo "number of overlapping voxels between CMRO2 HRF calculated from BOLD and ASL beta coeffs and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   # echo "number of total voxels in CMRO2 HRF calculated from BOLD and ASL beta coeffs clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of CMRO2 HRF calculated from BOLD and ASL beta coeffs mask voxels" >> Overlapping_masks_results_factor.txt              
else 
   echo "No positive CMRO2 HRF calculated from BOLD and ASL beta coeffs clusters" >> Overlapping_masks_results_factor.txt 
endif 


if (-e $ModelresultFolder/clustMapTvsR_CMRO2_RRFPos+tlrc.HEAD) then
   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_CMRO2_RRFPos+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   # set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_CMRO2_RRFPos+tlrc"`
   # set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_CMRO2_RRFPos+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   # set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   # echo "number of overlapping voxels between CMRO2 RRF and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   # echo "number of total voxels in CMRO2 RRF clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of CMRO2 RRF mask voxels" >> Overlapping_masks_results_factor.txt              
else 
   echo "No positive CMRO2 RRF clusters" >> Overlapping_masks_results_factor.txt 
endif 

if (-e $ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}+tlrc.HEAD) then
   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_BOLDPos+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   # set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}+tlrc"`
   # set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   # set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   # echo "number of overlapping voxels between BOLD and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   # echo "number of total voxels in BOLD clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of BOLD mask voxels" >> Overlapping_masks_results_factor.txt              
else 
   echo "No positive BOLD clusters" >> Overlapping_masks_results_factor.txt 
endif 

if (-e $ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}+tlrc.HEAD) then
   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_PWPos+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}+tlrc"`
   set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   echo "number of overlapping voxels between ASL and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   echo "number of total voxels in ASL clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of ASL mask voxels" >> Overlapping_masks_results_factor.txt              
else 
   echo "No positive ASL clusters" >> Overlapping_masks_results_factor.txt 
endif



if (-e $ModelresultFolder/clustMapTvsR_CMRO2Neg${suffix_atlas}+tlrc.HEAD) then
   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_CMRO2Neg+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   # echo "Negative clusters: " >> Overlapping_masks_results_factor.txt      
   # set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_CMRO2Neg${suffix_atlas}+tlrc"`
   # set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_CMRO2Neg${suffix_atlas}+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   # set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   # echo "number of overlapping voxels between CMRO2 HRF and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   # echo "number of total voxels in CMRO2 HRF clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of CMRO2 HRF mask voxels" >> Overlapping_masks_results_factor.txt              
else 
   echo "No negative CMRO2 HRF clusters" >> Overlapping_masks_results_factor.txt 
endif 
if (-e $ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg${suffix_atlas}+tlrc.HEAD) then
   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   # set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg${suffix_atlas}+tlrc"`
   # set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_CMRO2_RRFNeg${suffix_atlas}+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   # set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   # echo "number of overlapping voxels between CMRO2 RRF and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   # echo "number of total voxels in CMRO2 RRF clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of CMRO2 RRF mask voxels" >> Overlapping_masks_results_factor.txt              
else 
   echo "No negative CMRO2 RRF clusters" >> Overlapping_masks_results_factor.txt 
endif 
if (-e $ModelresultFolder/clustMapTvsR_BOLDNeg${suffix_atlas}+tlrc.HEAD) then
   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_BOLDNeg+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   # set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_BOLDNeg${suffix_atlas}+tlrc"`
   # set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_BOLDNeg${suffix_atlas}+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   # set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   # echo "number of overlapping voxels between BOLD and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   # echo "number of total voxels in BOLD clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of BOLD mask voxels" >> Overlapping_masks_results_factor.txt              
else 
   echo "No negative BOLD clusters" >> Overlapping_masks_results_factor.txt 
endif 
if (-e $ModelresultFolder/clustMapTvsR_PWNeg${suffix_atlas}+tlrc.HEAD) then
   3dABoverlap -no_automask "$ModelresultFolder/clustMapTvsR_PWNeg+tlrc" "$ModelresultFolder/atlas_inter+tlrc" >> Overlapping_masks_results_factor.txt      

   # set totVxl = `3dBrickStat -count -non-zero "$ModelresultFolder/clustMapTvsR_PWNeg${suffix_atlas}+tlrc"`
   # set Noverlap = `3dOverlap "$ModelresultFolder/clustMapTvsR_PWNeg${suffix_atlas}+tlrc" "$ModelresultFolder/atlas_inter+tlrc"`
   # set prctOverlap = `echo "scale=5; ($Noverlap / $totVxl) * 100" | bc`

   # echo "number of overlapping voxels between ASL and intersectional masks is: $Noverlap" >> Overlapping_masks_results_factor.txt      
   # echo "number of total voxels in ASL clustered mask is: $totVxl voxels" >> Overlapping_masks_results_factor.txt
   # echo "percent of voxel overlap: $prctOverlap % of ASL mask voxels" >> Overlapping_masks_results_factor.txt  
   # echo "number of total voxels in intersection of BOLD and ASL masks is: `3dBrickStat -count -non-zero "$ModelresultFolder/atlas_inter+tlrc"` voxels" >> Overlapping_masks_results.txt             
else 
   echo "No negatvie ASL clusters" >> Overlapping_masks_results_factor.txt 
endif 

rm cc*

echo "job finished"
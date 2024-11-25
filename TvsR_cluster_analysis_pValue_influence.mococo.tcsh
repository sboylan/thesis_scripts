#!/bin/tcsh -xef

# to execute via bash: 
#   tcsh -xef TvsR_cluster_analysis_pValue_influence.mococo.tcsh 2>&1 | tee output.TvsR_cluster_analysis_pValue_influence.mococo_12_08

set Home = $PWD
set results_dir = '../results/task_versus_rest_clusterization_analysis_pValue_influence'
set dataFolder  = '/home/mococo/Documents/Simon_Boylan2/quantitativ_fMRI/data'
set input_directory = "Analysis/CMRO2calc_classic"
set underlayMNI = "/home/mococo/abin/MNI152_2009_template_SSW.nii.gz"
set ImageFolder = "images"
set ModelresultFolder = "Model_results"
# set suffix = "pValTest"
set nameOfPvalnalaysis = "pvalue_influence_on_number_of_voxel_in_mask.1D"

set atlas = "Schaefer_Yeo_17n_400 -atlas MNI_Glasser_HCP_v1.0 -atlas Brainnetome_1.0"
setenv AFNI_SUPP_ATLAS "/home/mococo/abin/AFNI_atlas_spaces.niml"

set pVals = (0.001 0.003 0.005 0.007 0.01 0.03 0.05 0.1)
# set pVals = (0.01)

# echo -n "enter the value of p_value threshold : "
# set pValThreshold = $<

set NN = 2
set mask =  "$Home/mask_group+tlrc"

mkdir -p $results_dir
cd $results_dir
mkdir -p $ModelresultFolder
mkdir -p $ImageFolder
mkdir -p $ModelresultFolder/ClustSimdata

echo "pVal minNclustThrshBOLD minNclustThrshPW NvoxBOLD NvoxPW NvoxInterMask t_value" > $nameOfPvalnalaysis


# set subjects =  ('AlPu' 'AnCD' 'ArDC' 'BeMa' 'BrMa' 'CeHa' 'ClBo' 'CoVB' 'DoBi' 'ElAc' 'ElBe' 'ElCo' 'HiCh' 'JoDM' 'JoDP' 'LeGa' 'MaCh' 'MaKi' 'MaKM' 'MiAn' 'NaCa' 'NiDe' 'RaEM' 'RaZi' 'SaGa' 'SoSe')
## The mean of every dataset has to be 0 because ttest tests against 0.
# because : * With 1 set ('-setA'), the mean across input datasets (usually subjects)
#    is tested against 0.

set GMmask = "../meanGMmask+tlrc"


if (! -f "./$ModelresultFolder/TtestTvsR_PW+tlrc.HEAD" ) then

    ## ========== Task versus Rest ASL  ================= ###
    # running 3dttest on TaskVsRest for PW
    3dttest++ -overwrite -prefix ./$ModelresultFolder/TtestTvsR_PW                  \
             -resid ./$ModelresultFolder/errtsTvsR_PW -ACF -Clustsim -prefix_clustsim ccTvsR_PW -tempdir ./$ModelresultFolder/ClustSimdata \
             -mask $GMmask  -setA taskVsRest_PW                                            \
             01 "$dataFolder/AlPu/${input_directory}/stats.PW2_TvsR.AlPu+tlrc.BRIK[6]" \
             02 "$dataFolder/AnCD/${input_directory}/stats.PW2_TvsR.AnCD+tlrc.BRIK[6]" \
             03 "$dataFolder/ArDC/${input_directory}/stats.PW2_TvsR.ArDC+tlrc.BRIK[6]" \
             04 "$dataFolder/BeMa/${input_directory}/stats.PW2_TvsR.BeMa+tlrc.BRIK[6]" \
             05 "$dataFolder/CeHa/${input_directory}/stats.PW2_TvsR.CeHa+tlrc.BRIK[6]" \
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
             18 "$dataFolder/MiAn/${input_directory}/stats.PW2_TvsR.MiAn+tlrc.BRIK[6]" \
             19 "$dataFolder/NaCa/${input_directory}/stats.PW2_TvsR.NaCa+tlrc.BRIK[6]" \
             20 "$dataFolder/NiDe/${input_directory}/stats.PW2_TvsR.NiDe+tlrc.BRIK[6]" \
             21 "$dataFolder/RaEM/${input_directory}/stats.PW2_TvsR.RaEM+tlrc.BRIK[6]" \
             22 "$dataFolder/RaZi/${input_directory}/stats.PW2_TvsR.RaZi+tlrc.BRIK[6]" \
             23 "$dataFolder/SaGa/${input_directory}/stats.PW2_TvsR.SaGa+tlrc.BRIK[6]" \
             24 "$dataFolder/SoSe/${input_directory}/stats.PW2_TvsR.SoSe+tlrc.BRIK[6]" \
             25 "$dataFolder/BrMa/${input_directory}/stats.PW2_TvsR.BrMa+tlrc.BRIK[6]" \
             26 "$dataFolder/ElAc/${input_directory}/stats.PW2_TvsR.ElAc+tlrc.BRIK[6]"
endif

if (! -f "./$ModelresultFolder/TtestTvsR_BOLD+tlrc.HEAD" ) then
    ## ============= Task versus Rest BOLD  ================ ###
    # running 3dttest on TaskVsRest for BOLD
    3dttest++ -overwrite -prefix ./$ModelresultFolder/TtestTvsR_BOLD                  \
             -resid ./$ModelresultFolder/errts_TvsR_BOLD -ACF -Clustsim -prefix_clustsim ccTvsR_BOLD -tempdir ./$ModelresultFolder/ClustSimdata \
             -mask $GMmask  -setA taskVsRest_BOLD                                            \
             01 "$dataFolder/AlPu/${input_directory}/stats.MEC2_TvsR.AlPu_REML+tlrc.BRIK[6]" \
             02 "$dataFolder/AnCD/${input_directory}/stats.MEC2_TvsR.AnCD_REML+tlrc.BRIK[6]" \
             03 "$dataFolder/ArDC/${input_directory}/stats.MEC2_TvsR.ArDC_REML+tlrc.BRIK[6]" \
             04 "$dataFolder/BeMa/${input_directory}/stats.MEC2_TvsR.BeMa_REML+tlrc.BRIK[6]" \
             05 "$dataFolder/CeHa/${input_directory}/stats.MEC2_TvsR.CeHa_REML+tlrc.BRIK[6]" \
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
             18 "$dataFolder/MiAn/${input_directory}/stats.MEC2_TvsR.MiAn_REML+tlrc.BRIK[6]" \
             19 "$dataFolder/NaCa/${input_directory}/stats.MEC2_TvsR.NaCa_REML+tlrc.BRIK[6]" \
             20 "$dataFolder/NiDe/${input_directory}/stats.MEC2_TvsR.NiDe_REML+tlrc.BRIK[6]" \
             21 "$dataFolder/RaEM/${input_directory}/stats.MEC2_TvsR.RaEM_REML+tlrc.BRIK[6]" \
             22 "$dataFolder/RaZi/${input_directory}/stats.MEC2_TvsR.RaZi_REML+tlrc.BRIK[6]" \
             23 "$dataFolder/SaGa/${input_directory}/stats.MEC2_TvsR.SaGa_REML+tlrc.BRIK[6]" \
             24 "$dataFolder/SoSe/${input_directory}/stats.MEC2_TvsR.SoSe_REML+tlrc.BRIK[6]" \
             25 "$dataFolder/BrMa/${input_directory}/stats.MEC2_TvsR.BrMa_REML+tlrc.BRIK[6]" \
             26 "$dataFolder/ElAc/${input_directory}/stats.MEC2_TvsR.ElAc_REML+tlrc.BRIK[6]"
endif


foreach pValThreshold ( $pVals )
    set suffix_atlas = "$pValThreshold"

    set boundaryTvsR = `p2dsetstat -quiet -inset "./$ModelresultFolder/TtestTvsR_PW+tlrc[1]" -1sided -pval $pValThreshold`


## ASL analysis
    set ClustSizeTvsR_PW = `1d_tool.py -infile ccTvsR_PW.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThreshold -csim_alpha 0.05 -verb 0`
    echo $ClustSizeTvsR_PW

    3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_PW+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_PW -pref_map "./$ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_PWPos${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR > "./$ModelresultFolder/clustResultsTvsR_PWpos${suffix_atlas}.1D"
    3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_PW+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_PW -pref_map "./$ModelresultFolder/clustMapTvsR_PWNeg${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_PWNeg${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR > "./$ModelresultFolder/clustResultsTvsR_PWneg${suffix_atlas}.1D"

    set testPosPW=`cat "./$ModelresultFolder/clustResultsTvsR_PWpos${suffix_atlas}.1D"`
    set testNegPW=`cat "./$ModelresultFolder/clustResultsTvsR_PWneg${suffix_atlas}.1D"`
    # echo "PWNeg : $testNegPW"
    # echo "PWPos : $testPosPW"

## BOLD analysis
    set ClustSizeTvsR_BOLD = `1d_tool.py -infile ccTvsR_BOLD.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThreshold -csim_alpha 0.05 -verb 0`
    echo $ClustSizeTvsR_BOLD

    3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_BOLD+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_BOLD -pref_map "./$ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_BOLDPos${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR > "./$ModelresultFolder/clustResultsTvsR_BOLDpos${suffix_atlas}.1D"
    3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_BOLD+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_BOLD -pref_map "./$ModelresultFolder/clustMapTvsR_BOLDNeg${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_BOLDNeg${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR > "./$ModelresultFolder/clustResultsTvsR_BOLDneg${suffix_atlas}.1D"

    set testPosBOLD=`cat $ModelresultFolder/clustResultsTvsR_BOLDpos${suffix_atlas}.1D`
    set testNegBOLD=`cat $ModelresultFolder/clustResultsTvsR_BOLDneg${suffix_atlas}.1D`
    # echo "BOLDNeg : $testNegBOLD"
    # echo "BOLDPos : $testPosBOLD"

    ### finding common voxels between masks ###
    if (! ("$testPosBOLD" == "#** NO CLUSTERS FOUND ***")) then
        set NbrVoxelsBOLD = `3dBrickStat -count -non-zero "./${ModelresultFolder}/clustMapTvsR_BOLDPos${suffix_atlas}+tlrc.HEAD"`
    else
        set NbrVoxelsBOLD = 'NaN'
    endif

    if (! ("$testPosPW" == "#** NO CLUSTERS FOUND ***")) then
        set NbrVoxelsPW = `3dBrickStat -count -non-zero "./${ModelresultFolder}/clustMapTvsR_PWPos${suffix_atlas}+tlrc.HEAD"`
    else
        set NbrVoxelsPW = NaN
    endif

    if (! ("$testPosBOLD" == "#** NO CLUSTERS FOUND ***") && ! ("$testPosPW" == "#** NO CLUSTERS FOUND ***")) then

        3dmask_tool -overwrite -input "./$ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}+tlrc.HEAD ./$ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}+tlrc.HEAD" -prefix ./$ModelresultFolder/atlas_interPos${suffix_atlas} \
                    -inter

        set NbrVoxelsIntersectMask = `3dBrickStat -count -non-zero ./${ModelresultFolder}/atlas_interPos${suffix_atlas}+tlrc`

        set opref = "$ImageFolder/clustMap_intersection_pos${suffix_atlas}"

        @chauffeur_afni                                                       \
           -ulay              "$underlayMNI"      \
           -box_focus_slices  AMASK_FOCUS_ULAY                               \
           -olay              "./$ModelresultFolder/atlas_interPos${suffix_atlas}+tlrc"                        \
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
    else
        set NbrVoxelsIntersectMask = 'NaN'
        echo "no positive cluster intersection mask for pVal = $pValThreshold"
    endif
    echo "$pValThreshold $ClustSizeTvsR_BOLD $ClustSizeTvsR_PW $NbrVoxelsBOLD $NbrVoxelsPW $NbrVoxelsIntersectMask $boundaryTvsR" >> $nameOfPvalnalaysis

    if (! ("$testNegBOLD" == "#** NO CLUSTERS FOUND ***")) then
        set NbrVoxelsBOLD = `3dBrickStat -count -non-zero "./${ModelresultFolder}/clustMapTvsR_BOLDNeg${suffix_atlas}+tlrc.HEAD"`
    else
        set NbrVoxelsBOLD = 'NaN'
    endif

    if (! ("$testNegPW" == "#** NO CLUSTERS FOUND ***")) then
        set NbrVoxelsPW = `3dBrickStat -count -non-zero "./${ModelresultFolder}/clustMapTvsR_PWNeg${suffix_atlas}+tlrc.HEAD"`
    else
        set NbrVoxelsPW = NaN
    endif

    if (! ("$testNegBOLD" == "#** NO CLUSTERS FOUND ***") && ! ("$testNegPW" == "#** NO CLUSTERS FOUND ***")) then

        3dmask_tool -overwrite -input "./$ModelresultFolder/clustMapTvsR_BOLDNeg${suffix_atlas}+tlrc.HEAD ./$ModelresultFolder/clustMapTvsR_PWNeg${suffix_atlas}+tlrc.HEAD" -prefix ./$ModelresultFolder/atlas_interNeg${suffix_atlas} \
                    -inter

        set NbrVoxelsIntersectMask = `3dBrickStat -count -non-zero ./${ModelresultFolder}/atlas_interNeg${suffix_atlas}+tlrc`
   

        set opref = "$ImageFolder/clustMap_intersection_neg${suffix_atlas}"

        @chauffeur_afni                                                       \
           -ulay              "$underlayMNI"      \
           -box_focus_slices  AMASK_FOCUS_ULAY                               \
           -olay              "./$ModelresultFolder/atlas_interNeg${suffix_atlas}+tlrc"                        \
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
    else 
        set NbrVoxelsIntersectMask = 'NaN'
        echo "no negative cluster intersection mask for pVal = $pValThreshold"
    endif
    echo "-$pValThreshold -$ClustSizeTvsR_BOLD -$ClustSizeTvsR_PW -$NbrVoxelsBOLD -$NbrVoxelsPW -$NbrVoxelsIntersectMask -$boundaryTvsR" >> $nameOfPvalnalaysis
end


echo "job finished"
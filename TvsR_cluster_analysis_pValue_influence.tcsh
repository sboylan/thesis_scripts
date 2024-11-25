#!/bin/tcsh -xef

# to execute via bash: 
#   tcsh -xef XXX.tcsh 2>&1 | tee output.XXX

set Home = $PWD
set results_dir = '../results/task_versus_rest_clusterization_analysis_pValue_influence'
set dataFolder  = 'XXX/quantitativ_fMRI/data'
set input_directory = "Analysis/CMRO2calc_classic"
set underlayMNI = "XXX/abin/MNI152_2009_template_SSW.nii.gz"
set ImageFolder = "images"
set ModelresultFolder = "Model_results"
# set suffix = "pValTest"
set nameOfPvalnalaysis = "pvalue_influence_on_number_of_voxel_in_mask.1D"

set atlas = "Schaefer_Yeo_17n_400 -atlas MNI_Glasser_HCP_v1.0 -atlas Brainnetome_1.0"
setenv AFNI_SUPP_ATLAS "XXX/abin/AFNI_atlas_spaces.niml"

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


# set subjects =  ('test1')
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
             01 "$dataFolder/XXX/${input_directory}/stats.PW2_TvsR.XXX+tlrc.BRIK[6]" \
             02 "$dataFolder/XXX/${input_directory}/stats.PW2_TvsR.XXX+tlrc.BRIK[6]" 
endif

if (! -f "./$ModelresultFolder/TtestTvsR_BOLD+tlrc.HEAD" ) then
    ## ============= Task versus Rest BOLD  ================ ###
    # running 3dttest on TaskVsRest for BOLD
    3dttest++ -overwrite -prefix ./$ModelresultFolder/TtestTvsR_BOLD                  \
             -resid ./$ModelresultFolder/errts_TvsR_BOLD -ACF -Clustsim -prefix_clustsim ccTvsR_BOLD -tempdir ./$ModelresultFolder/ClustSimdata \
             -mask $GMmask  -setA taskVsRest_BOLD                                            \
             01 "$dataFolder/XXX/${input_directory}/stats.MEC2_TvsR.XXX_REML+tlrc.BRIK[6]" \
             02 "$dataFolder/XXX/${input_directory}/stats.MEC2_TvsR.XXX_REML+tlrc.BRIK[6]" 
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

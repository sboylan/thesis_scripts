#!/bin/tcsh -xef

# to execute via bash: 
#   tcsh -xef XXX.tcsh 2>&1 | tee output.XXX

### This script analysis the size of the intersection of BOLD and ASL clusters, with regard with the p-value chosen fro PW and for BOLD.
### It outputs a table that help select a combination of p-values.
### The analysis is done on hick task data, but with task-versus-rest regression analysis, which is not the same dataset as the regression for each condition.


set Home = $PWD
set results_dir = '../results/task_versus_rest_clusterization_analysis_pValue_influence_2D'
set dataFolder  = 'XXX/quantitativ_fMRI/data'
set input_directory = "Analysis/CMRO2calc_classic"
set underlayMNI = "XXX/abin/MNI152_2009_template_SSW.nii.gz"
set ImageFolder = "images"
set ModelresultFolder = "Model_results"
# set suffix = "pValTest"
set nameOfPvalnalaysis = "pvalue_influence_on_number_of_voxel_in_mask_2D.1D"

set atlas = "Schaefer_Yeo_17n_400 -atlas MNI_Glasser_HCP_v1.0 -atlas Brainnetome_1.0"
setenv AFNI_SUPP_ATLAS "XXX/abin/AFNI_atlas_spaces.niml"
set GMmask = "../meanGMmask+tlrc"

set pVals = (0.001 0.003 0.005 0.007 0.01 0.03 0.05 0.1)
set NN = 2

mkdir -p $results_dir
cd $results_dir
mkdir -p $ModelresultFolder
mkdir -p $ImageFolder
mkdir -p $ModelresultFolder/ClustSimdata


## =============================  All subjects ========================================
## We run a first analysis with all subjects, nex analysis will be without the outliers.

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


echo "PW|BOLD $pVals" > $nameOfPvalnalaysis  # It is indeed PW as lines and BOLD as column, it has been verified
echo "PW|BOLD $pVals" > negative_$nameOfPvalnalaysis  # For clusters of negative values

foreach pValThreshold ( $pVals )

    set boundaryTvsR_PW = `p2dsetstat -quiet -inset "./$ModelresultFolder/TtestTvsR_PW+tlrc[1]" -1sided -pval $pValThreshold`
    set plist = $pValThreshold
    set nlist = $pValThreshold

    foreach pValThreshold2 ( $pVals )
        set suffix_atlas = "${pValThreshold}_${pValThreshold2}"

        ## ASL analysis
        set ClustSizeTvsR_PW = `1d_tool.py -infile ccTvsR_PW.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThreshold -csim_alpha 0.05 -verb 0`

        3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_PW+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_PW -pref_map "./$ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_PWPos${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_PW > "./$ModelresultFolder/clustResultsTvsR_PWpos${suffix_atlas}.1D"
        3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_PW+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_PW -pref_map "./$ModelresultFolder/clustMapTvsR_PWNeg${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_PWNeg${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_PW > "./$ModelresultFolder/clustResultsTvsR_PWneg${suffix_atlas}.1D"

        set testPosPW=`cat "./$ModelresultFolder/clustResultsTvsR_PWpos${suffix_atlas}.1D"`
        set testNegPW=`cat "./$ModelresultFolder/clustResultsTvsR_PWneg${suffix_atlas}.1D"`
        # echo "PWNeg : $testNegPW"
        # echo "PWPos : $testPosPW"

    ## BOLD analysis
        set ClustSizeTvsR_BOLD = `1d_tool.py -infile ccTvsR_BOLD.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThreshold2 -csim_alpha 0.05 -verb 0`

        set boundaryTvsR_BOLD = `p2dsetstat -quiet -inset "./$ModelresultFolder/TtestTvsR_PW+tlrc[1]" -1sided -pval $pValThreshold2`

        3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_BOLD+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_BOLD -pref_map "./$ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_BOLDPos${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_BOLD > "./$ModelresultFolder/clustResultsTvsR_BOLDpos${suffix_atlas}.1D"
        3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_BOLD+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_BOLD -pref_map "./$ModelresultFolder/clustMapTvsR_BOLDNeg${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_BOLDNeg${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_BOLD > "./$ModelresultFolder/clustResultsTvsR_BOLDneg${suffix_atlas}.1D"

        set testPosBOLD=`cat $ModelresultFolder/clustResultsTvsR_BOLDpos${suffix_atlas}.1D`
        set testNegBOLD=`cat $ModelresultFolder/clustResultsTvsR_BOLDneg${suffix_atlas}.1D`
        # echo "BOLDNeg : $testNegBOLD"
        # echo "BOLDPos : $testPosBOLD"

        ### finding common voxels between masks ###
        if (! ("$testPosBOLD" == "#** NO CLUSTERS FOUND ***") && ! ("$testPosPW" == "#** NO CLUSTERS FOUND ***")) then
            3dmask_tool -overwrite -input "./$ModelresultFolder/clustMapTvsR_BOLDPos${suffix_atlas}+tlrc.HEAD ./$ModelresultFolder/clustMapTvsR_PWPos${suffix_atlas}+tlrc.HEAD" -prefix ./$ModelresultFolder/atlas_interPos${suffix_atlas} \
                        -inter
            set NbrVoxelsIntersectMask = `3dBrickStat -count -non-zero ./${ModelresultFolder}/atlas_interPos${suffix_atlas}+tlrc`
        else
            set NbrVoxelsIntersectMask = 'NaN'
            echo "no positive cluster intersection mask for pVal = $pValThreshold"
        endif
        #incrementing list
        set plist = ($plist $NbrVoxelsIntersectMask)
        ### finding common voxels between masks ###
        if (! ("$testNegBOLD" == "#** NO CLUSTERS FOUND ***") && ! ("$testNegPW" == "#** NO CLUSTERS FOUND ***")) then
            3dmask_tool -overwrite -input "./$ModelresultFolder/clustMapTvsR_BOLDNeg${suffix_atlas}+tlrc.HEAD ./$ModelresultFolder/clustMapTvsR_PWNeg${suffix_atlas}+tlrc.HEAD" -prefix ./$ModelresultFolder/atlas_interNeg${suffix_atlas} \
                        -inter
            set NbrVoxelsIntersectMask = `3dBrickStat -count -non-zero ./${ModelresultFolder}/atlas_interNeg${suffix_atlas}+tlrc`
        else
            set NbrVoxelsIntersectMask = 'NaN'
            echo "no negative cluster intersection mask for pVal = $pValThreshold"
        endif
        set nlist = ($nlist $NbrVoxelsIntersectMask)

    end
    echo "$plist" >> $nameOfPvalnalaysis
    echo "$nlist" >> negative_$nameOfPvalnalaysis
end

## ===========================  Without outliers ======================================
## This time, we get rid of the outliers for hick tasks : CeHa and MiAn
## I run this analysis to be thorough and because for some reason I find an 
## intersection maks of 205 voxels instead of the 409 that previous study finds.

if (! -f "./$ModelresultFolder/TtestTvsR_PW_cleaned+tlrc.HEAD" ) then
    ## ========== Task versus Rest ASL  ================= ###
    # running 3dttest on TaskVsRest for PW
    3dttest++ -overwrite -prefix ./$ModelresultFolder/TtestTvsR_PW_cleaned                  \
             -resid ./$ModelresultFolder/errtsTvsR_PW_cleaned -ACF -Clustsim -prefix_clustsim ccTvsR_PW_cleaned -tempdir ./$ModelresultFolder/ClustSimdata \
             -mask $GMmask  -setA taskVsRest_PW_cleaned                                            \
             01 "$dataFolder/XXX/${input_directory}/stats.PW2_TvsR.XXX+tlrc.BRIK[6]" \
             02 "$dataFolder/XXX/${input_directory}/stats.PW2_TvsR.XXX+tlrc.BRIK[6]"
endif

if (! -f "./$ModelresultFolder/TtestTvsR_BOLD_cleaned+tlrc.HEAD" ) then
    ## ============= Task versus Rest BOLD  ================ ###
    # running 3dttest on TaskVsRest for BOLD
    3dttest++ -overwrite -prefix ./$ModelresultFolder/TtestTvsR_BOLD_cleaned                  \
             -resid ./$ModelresultFolder/errts_TvsR_BOLD_cleaned -ACF -Clustsim -prefix_clustsim ccTvsR_BOLD_cleaned -tempdir ./$ModelresultFolder/ClustSimdata \
             -mask $GMmask  -setA taskVsRest_BOLD_cleaned                                            \
             01 "$dataFolder/XXX/${input_directory}/stats.MEC2_TvsR.XXX_REML+tlrc.BRIK[6]" \
             02 "$dataFolder/XXX/${input_directory}/stats.MEC2_TvsR.XXX_REML+tlrc.BRIK[6]" 
endif

set nameOfPvalnalaysis = "pvalue_influence_on_number_of_voxel_in_mask_2D_without_outliers.1D"

echo "PW|BOLD $pVals" > ${nameOfPvalnalaysis}
echo "PW|BOLD $pVals" > negative_${nameOfPvalnalaysis}

foreach pValThreshold ( $pVals )

    set boundaryTvsR_PW_cleaned = `p2dsetstat -quiet -inset "./$ModelresultFolder/TtestTvsR_PW_cleaned+tlrc[1]" -1sided -pval $pValThreshold`
    set plist = $pValThreshold
    set nlist = $pValThreshold

    foreach pValThreshold2 ( $pVals )
        set suffix_atlas = "${pValThreshold}_${pValThreshold2}"

        ## ASL analysis
        set ClustSizeTvsR_PW_cleaned = `1d_tool.py -infile ccTvsR_PW_cleaned.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThreshold -csim_alpha 0.05 -verb 0`

        3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_PW_cleaned+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_PW_cleaned -pref_map "./$ModelresultFolder/clustMapTvsR_PW_cleanedPos${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_PW_cleanedPos${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_PW_cleaned > "./$ModelresultFolder/clustResultsTvsR_PW_cleanedpos${suffix_atlas}.1D"
        3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_PW_cleaned+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_PW_cleaned -pref_map "./$ModelresultFolder/clustMapTvsR_PW_cleanedNeg${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_PW_cleanedNeg${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_PW_cleaned > "./$ModelresultFolder/clustResultsTvsR_PW_cleanedneg${suffix_atlas}.1D"

        set testPosPW=`cat "./$ModelresultFolder/clustResultsTvsR_PW_cleanedpos${suffix_atlas}.1D"`
        set testNegPW=`cat "./$ModelresultFolder/clustResultsTvsR_PW_cleanedneg${suffix_atlas}.1D"`
        # echo "PWNeg : $testNegPW"
        # echo "PWPos : $testPosPW"

    ## BOLD analysis
        set ClustSizeTvsR_BOLD_cleaned = `1d_tool.py -infile ccTvsR_BOLD_cleaned.CSimA.NN2_1sided.1D -csim_show_clustsize -csim_pthr $pValThreshold2 -csim_alpha 0.05 -verb 0`

        set boundaryTvsR_BOLD_cleaned = `p2dsetstat -quiet -inset "./$ModelresultFolder/TtestTvsR_PW_cleaned+tlrc[1]" -1sided -pval $pValThreshold2`

        3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_BOLD_cleaned+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_BOLD_cleaned -pref_map "./$ModelresultFolder/clustMapTvsR_BOLD_cleanedPos${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_BOLD_cleanedPos${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'RIGHT_TAIL' $boundaryTvsR_BOLD_cleaned > "./$ModelresultFolder/clustResultsTvsR_BOLD_cleanedpos${suffix_atlas}.1D"
        3dClusterize -quiet -overwrite -noabs -1Dformat -inset "./$ModelresultFolder/TtestTvsR_BOLD_cleaned+tlrc" -NN $NN -clust_nvox $ClustSizeTvsR_BOLD_cleaned -pref_map "./$ModelresultFolder/clustMapTvsR_BOLD_cleanedNeg${suffix_atlas}" -pref_dat "./$ModelresultFolder/clustDataTvsR_BOLD_cleanedNeg${suffix_atlas}" -mask $GMmask -ithr 1 -idat 0 -1sided 'LEFT_TAIL' -$boundaryTvsR_BOLD_cleaned > "./$ModelresultFolder/clustResultsTvsR_BOLD_cleanedneg${suffix_atlas}.1D"

        set testPosBOLD=`cat $ModelresultFolder/clustResultsTvsR_BOLD_cleanedpos${suffix_atlas}.1D`
        set testNegBOLD=`cat $ModelresultFolder/clustResultsTvsR_BOLD_cleanedneg${suffix_atlas}.1D`
        # echo "BOLDNeg : $testNegBOLD"
        # echo "BOLDPos : $testPosBOLD"

        ### finding common voxels between masks ###
        if (! ("$testPosBOLD" == "#** NO CLUSTERS FOUND ***") && ! ("$testPosPW" == "#** NO CLUSTERS FOUND ***")) then
            3dmask_tool -overwrite -input "./$ModelresultFolder/clustMapTvsR_BOLD_cleanedPos${suffix_atlas}+tlrc.HEAD ./$ModelresultFolder/clustMapTvsR_PW_cleanedPos${suffix_atlas}+tlrc.HEAD" -prefix ./$ModelresultFolder/atlas_interPos${suffix_atlas} \
                        -inter
            set NbrVoxelsIntersectMask = `3dBrickStat -count -non-zero ./${ModelresultFolder}/atlas_interPos${suffix_atlas}+tlrc`
        else
            set NbrVoxelsIntersectMask = 'NaN'
            echo "no positive cluster intersection mask for pVal = $pValThreshold"
        endif

        # incrementing list
        set plist = ($plist $NbrVoxelsIntersectMask)
        ### finding common voxels between masks ###
        if (! ("$testNegBOLD" == "#** NO CLUSTERS FOUND ***") && ! ("$testNegPW" == "#** NO CLUSTERS FOUND ***")) then
            3dmask_tool -overwrite -input "./$ModelresultFolder/clustMapTvsR_BOLD_cleanedNeg${suffix_atlas}+tlrc.HEAD ./$ModelresultFolder/clustMapTvsR_PW_cleanedNeg${suffix_atlas}+tlrc.HEAD" -prefix ./$ModelresultFolder/atlas_interNeg${suffix_atlas} \
                        -inter
            set NbrVoxelsIntersectMask = `3dBrickStat -count -non-zero ./${ModelresultFolder}/atlas_interNeg${suffix_atlas}+tlrc`
        else
            set NbrVoxelsIntersectMask = 'NaN'
            echo "no negative cluster intersection mask for pVal = $pValThreshold"
        endif

        # incrementing list
        set nlist = ($nlist $NbrVoxelsIntersectMask)
    end
    echo "$plist" >> $nameOfPvalnalaysis
    echo "$nlist" >> negative_$nameOfPvalnalaysis
end

echo "job finished"

function from1d2GLMcsv(varargin)
    if nargin > 1
        csvName = varargin{1};
    else
        csvName = 'intersect_clust_mask_voxel_data.csv';
    end
    for i = 2: nargin
        M(:,:,i-1) = table2array(readtable(varargin{i}));
    end
    voxel=repmat((1:size(M,1))',size(M,3)*size(M,2),1);
    subj=repmat(repelem((1:size(M,2)),size(M,1))',size(M,3),1);
    condi = repelem((1:size(M,3)),size(M,1)*size(M,2))';

    tbM = table(condi,subj,voxel,M(:),'VariableNames',{'entropy','subject','voxel','CMRO2'}) ;
    writetable(tbM,csvName);
    disp(["data written to file ",csvName])
end
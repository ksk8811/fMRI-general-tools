
function [trshld] = MonteCarlo(statsImgDir,statsImgFile,maskFile, rmm, pthr, iter)
% statsImgFile - SPMt or ResMS image to estimate the smoothing in mm. Better use ResMS: this procedure usually overestimates the smooth kernel than estimating the smooth kernel on the residuals
% statsImgDir - directory of a tested model (where the SPMt or ResMS is).
% will save the output text file there
% maskFile  - mask file either created by SPM (mask.img) or explicit mask if used
% rmm  - rmm is used to define connection cretiria. for SPM (edge connection) counted as pne dimention of voxel size * sqrt(3), e.g. for voxSize = 3 3 3, rmm = 5
% pthr  - individual voxel threshold probability
% iter  - number of Monte Carlo simulations. 1000 is default in REST
% 

outName = strcat('AlphaSim_', num2str(pthr), '_', num2str(iter));
statFile = fullfile(statsImgDir,statsImgFile);

[dLh,resels,FWHM, nVoxels]=rest_Smoothest(statFile, maskFile);

s = FWHM;

rest_AlphaSim(maskFile,statsImgDir,outName,rmm,s,pthr,iter);

MCtext = fullfile(statsImgDir, strcat(outName,'.txt'));
MC = ddreadfile(MCtext);

for i = 23:length(MC)
    if str2double(MC{i}{6})<0.05
        break
    end
    trshld =  MC{i}{1};
end

%%27/04/2018 doesn't work on matlab 2017 or older. Run on Matlab 2016. 

%% setpaths
addpath(genpath('/Users/k.siudakrzywicka/Desktop/tools/MATLAB_repository/fMRI_tools/REST_V1.8_130615'))
%% parameters
statsImgDir =  pwd;
statsImgFile= 'ResMS.nii';
maskFile  = fullfile(statsImgDir, 'mask.nii');
rmm = 5;
pthr = 0.0001;
iter = 1000; 

%% call the function
[trshld] = MonteCarlo(statsImgDir,statsImgFile,maskFile, rmm, pthr, iter);
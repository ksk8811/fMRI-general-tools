function [ structure ] = localize(cor)
%converts the MNI coordinates into Talairach and gets from Talairach deamon
%the approximate structure. remember to add talairach.jar file to your pwd!
%PointToTD operates on a single coordinate and has three search options: 
%(1) Structural Probability Maps, 
%(2) Talairach label, 
%(3) Talairach labels within a cube range and 
%(4) Talairach gray matter labels.

javaaddpath('/Users/k.siudakrzywicka/Desktop/tools/MATLAB_repository/fMRI_tools/skrypty_bacze/talairach.jar')
tal = mni2tal(cor);
rtal = round2(tal, 0.1);
len = length(mat2str(rtal));
out1 = sprintf('javaMethod(''main'',''org.talairach.PointToTD'',{''4,'', ''%d,'', ''%d,'', ''%d''})', rtal(1), rtal(2),rtal(3));
out2 = evalc(out1);
keyword = 'Returned:';
key_len = length(keyword);
structure = out2(strfind(out2, keyword)+key_len+1:end-1);
end


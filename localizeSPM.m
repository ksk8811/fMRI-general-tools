function [structure]=localizeSPM()

javaaddpath('/Users/k.siudakrzywicka/Desktop/tools/MATLAB_repository/fMRI_tools/skrypty_bacze/talairach.jar')
xyzmm=spm_mip_ui('GetCoords');
mni = xyzmm';
tal = mni2tal(mni);
rtal = round2(tal, 0.1);
len = length(mat2str(rtal));
out1 = sprintf('javaMethod(''main'',''org.talairach.PointToTD'',{''4,'', ''%d,'', ''%d,'', ''%d''})', rtal(1), rtal(2),rtal(3));
out2 = evalc(out1);
in = 8+len+9;
structure = out2(in+1:end-1);
end
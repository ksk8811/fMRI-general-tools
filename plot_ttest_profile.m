function tvals =  plot_ttest_profile(sub_dir, model, stat, cnumbers)

%works only for constrasts<10, couldn't integrate a 0.4%d from sprintf and
%regexpi. Sorry :(
%woks for the following data structure:
%subjects_directory/subject/model/spmT.nii if your model is in a
%subdirectory, include it in the model variable.

load( 'SPM.mat' ) ;

nconds = length(cnumbers);

xyzmm = spm_mip_ui('GetCoords');
iM = SPM.xVol.iM ;
xyzvox = iM( 1:3, : ) * [ xyzmm ; 1 ] ;

scans = dir([sub_dir '**/' model '/' stat '_*.nii']);
search = regexpi({scans.name}', [stat '_000' mat2str(cnumbers) '.nii$']);
scans = fullfile({scans.folder}, strcat({scans.name}))';
scans = scans(~(cellfun(@isempty,search)));
tvals = ones(length(scans),1);

for s = 1:length(scans)
    tvals(s) = spm_sample_vol( spm_vol(scans{s}), xyzvox(1), xyzvox(2), xyzvox(3), 1 );
end

tvals = reshape(tvals, nconds, [])';
tvals = rmmissing(tvals);

xlabels = cell(1,nconds);
for c = 1:nconds
    spm_struct_for_t_image = spm_vol(scans{c});
    if strcmp (stat,'beta')
        label = strfind(spm_struct_for_t_image.descrip, ' ');
        xlabels{c} = spm_struct_for_t_image.descrip(label(4)+1: end-6);
    else
        xlabels{c} = spm_struct_for_t_image.descrip(strfind(spm_struct_for_t_image.descrip, ': ')+2: end);
    end
    
    
end

 if contains(model, 'words')
        tvals = tvals(:, [1 2 3 6 4 5]);
        xlabels = xlabels(:, [1 2 3 6 4 5]);
    elseif contains(model, 'color')
        tvals = tvals(:, [1 5 2 4 3]);
        xlabels = xlabels(:, [1 5 2 4 3]);
 end




meanactiv = mean(tvals);  %%%% mean activation across subjects
meanbysubj = mean(tvals,2);
withinsubj = tvals-repmat(meanbysubj,1,nconds); %%%% mean activation after subtraction of the subject's mean
sterror = std(withinsubj)/sqrt(length(tvals));

figure('units', 'inches')

bar(meanactiv);
hold on
errorbar(meanactiv,sterror,'.k');
hold off
YLstr = sprintf( 'Response at [%g, %g, %g]', xyzmm ) ;
title( YLstr, 'FontSize', 12 )
ylabel(stat)
    xticklabels(xlabels)
    xtickangle(45)
set(gcf,'Units','inches','Position',[0 0 5 10])


end
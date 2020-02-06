function mean_tvals =  plot_ttest_profile_ROI(sub_dir,roi, model, cnumbers)

%works only for constrasts<10, couldn't integrate a 0.4%d from sprintf and
%regexpi. Sorry :(
%woks for the following data structure:
%subjects_directory/subject/model/spmT.nii if your model is in a
%subdirectory, include it in the model variable. If you're creating your
%ROI with FSL remember to reslice it. Unf

[~,name,~] = fileparts(roi);
search_table = dir([name '*.xlsx']);

if isempty(search_table)
    
    [mean_tvals, xlabels] = meanTfromROI(sub_dir,roi, model, cnumbers);
    
    T = array2table(mean_tvals, 'VariableNames', xlabels);
    writetable(T, [name '.xlsx']);
    
else
    
    T = readtable([name '.xlsx']);
    mean_tvals = table2array(T);
    xlabels = T.Properties.VariableNames;
end

meanactiv = mean(mean_tvals);  %%%% mean activation across subjects
meanbysubj = mean(mean_tvals,2);
withinsubj = mean_tvals-repmat(meanbysubj,1,nconds); %%%% mean activation after subtraction of the subject's mean
sterror = std(withinsubj)/sqrt(length(mean_tvals));

figure('units', 'inches')

bar(categorical(xlabels),meanactiv);
hold on
errorbar(categorical(xlabels),meanactiv,sterror,'.k');
hold off

YLstr = sprintf( 'Response in %s', name ) ;
title( YLstr, 'FontSize', 12 )
set(gcf,'Units','inches','Position',[0 0 7 10])


end
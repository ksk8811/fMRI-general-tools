clear
clc
close all

addpath('/Users/k.siudakrzywicka/Desktop/RDS_fMRI/RDS_localizers/scripts');

sub_dir = '/Users/k.siudakrzywicka/Desktop/RDS_fMRI/Controls/Processed_566_471_vol/';
model = 'stats_color';
stat = 'con'; %spmT or beta or con;
cnumbers = 1:5;
do_stats = 0;


roi_dir = '/Users/k.siudakrzywicka/Desktop/RDS_fMRI/Controls/colorRegions_rois/from_secondLevel_peaks/domain-regions/corrected/best_50_vox/';
cd (roi_dir)

rois = dir('bin*50*.nii');
rois = {rois.name};
rois = strcat(roi_dir, rois);

if do_stats
    test_table = {};
end
%%
for r = 1:length(rois)
    
    roi = rois{r};
    [~,name,~] = fileparts(roi);
    search_table = dir([roi_dir '/' name '_' model '_contrasts_' sprintf('%d', cnumbers) '_' stat '.xlsx']);
    
    
    if isempty(search_table)
        
        [mean_tvals, condition_names] = meanTfromROI(sub_dir,roi, model,stat, cnumbers);
        
        T = array2table(mean_tvals, 'VariableNames', condition_names);
        writetable(T, [name '_' model '_contrasts_' sprintf('%d', cnumbers) '_' stat  '.xlsx']);
        
    else
        
        T = readtable([name '_' model '_contrasts_' sprintf('%d', cnumbers) '_' stat '.xlsx']);
       
    end
  
    % reorganise data for nicer plots
    
    if contains(model, 'words')
        T = T(:, [1 2 3 6 4 5]);
    elseif contains(model, 'color')
        T = T(:, [1 5 2 4 3]);
    end
    xlabels = T.Properties.VariableNames;
    mean_tvals = table2array(T);

    %% plot

        
    meanactiv = mean(mean_tvals);  %%%% mean activation across subjects
    meanbysubj = mean(mean_tvals,2);
    withinsubj = mean_tvals-repmat(meanbysubj,1,length(cnumbers)); %%%% mean activation after subtraction of the subject's mean
    sterror = std(withinsubj)/sqrt(length(mean_tvals));
    
    figure('units', 'inches')
    
    bar(meanactiv);
    hold on
    errorbar(meanactiv,sterror,'.k');
    hold off
    
    YLstr = sprintf( 'Response in %s', name ) ;
    title( YLstr, 'FontSize', 12 )
    ylabel(stat)
    xticklabels(xlabels)
    xtickangle(45)
    set(gcf,'Units','inches','Position',[0 0 5 10])
    %ylim([-1 3])
    
     %% stats
    if do_stats
        name
        
        if contains(model, 'color')
            [ranovatblb, t_test_results] = color_ROI_stats(T);
            writetable(ranovatblb, ['ANOVA_' name '_' model '_contrasts_' sprintf('%d', cnumbers) '_' stat  '.xlsx'], 'WriteRowNames',true);
            test_table(r,:) = [name, t_test_results];
                
            
        elseif contains(model, 'words')
            [ranovatblb, post_hoc, t_test_results] = domain_ROI_stats (T)
            writetable(ranovatblb, ['ANOVA_' name '_' model '_contrasts_' sprintf('%d', cnumbers) '_' stat  '.xlsx'], 'WriteRowNames',true);
            writetable(post_hoc, ['post-hoc_ANOVA_' name '_' model '_contrasts_' sprintf('%d', cnumbers) '_' stat  '.xlsx'], 'WriteRowNames',true);
            writetable(t_test_results, ['ttes_vs_0_' name '_' model '_contrasts_' sprintf('%d', cnumbers) '_' stat  '.xlsx'], 'WriteRowNames',true);
            
            maxvalue = abs(max(meanactiv))+max(sterror);
            
            
            %mark significance
            if ranovatblb{3,5}<0.05
                
                yt = get(gca, 'YTick');
                xt = get(gca, 'XTick');
                
                if post_hoc{1, 5}<0.05
                    
                hold on
                plot(xt([3 4]), [maxvalue maxvalue]*1.2, '-k',...
                    xt([5 6]), [maxvalue maxvalue]*1.2, '-k',...
                    [mean(xt([3 4])) mean(xt([5 6]))], [maxvalue*1.2 maxvalue*1.2]+0.1, '-k',...
                    mean(xt([4 5])), maxvalue*1.2+0.15, '*k')
                hold off

                
                end
                
                if post_hoc{2, 5}<0.05
                    
                    hold on
                plot(xt([1 2]), [maxvalue maxvalue]*1.2, '-k',...
                    xt([3 4]), [maxvalue maxvalue]*1.2, '-k',...
                    [mean(xt([1 2])) mean(xt([3 4]))], [maxvalue*1.2 maxvalue*1.2]+0.1, '-k',...
                    mean(xt([2 3])), maxvalue*1.2+0.15, '*k')
                hold off

                
                end
                
                if post_hoc{4, 5}<0.05
                    
                    hold on
                plot(xt([1 2]), [maxvalue maxvalue]*1.2, '-k',...
                    xt([5 6]), [maxvalue maxvalue]*1.2, '-k',...
                    [mean(xt([1 2])) mean(xt([5 6]))], [maxvalue*1.2 maxvalue*1.2]+0.2, '-k',...
                    mean(xt([2 5])), maxvalue*1.2+0.25, '*k')
                hold off

               
                end
            end
            
            hold on
            plot (find(t_test_results.h1), maxvalue+0.08, '*k') 
        
        end
        
        
    end
    
    plot2pdf([name '_' model '_contrasts_' sprintf('%d', cnumbers) '_' stat '.pdf']);
end
if do_stats && contains(model, 'color')
    test_table = cell2table(test_table,...
        'VariableNames',{'name', 'h1','p', 'lower_ci', 'upper_ci', 't', 'df', 'sd'});
    writetable(test_table, 'congruency_effect.xlsx');
end
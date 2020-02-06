sub_dir = '/Users/k.siudakrzywicka/Desktop/RDS_fMRI/Controls/Processed_566_471_vol/';
model = 'stats_color';
cnumbers = 1:5;
stat = 'beta'; %spmT or beta;

plot_ttest_profile(sub_dir, model, stat, cnumbers)
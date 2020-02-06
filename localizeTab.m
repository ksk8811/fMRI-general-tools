%% this script localizes the peaks listed on the SPM results table

%In order to run in, you have to have a SPM Results Table active in your
%MatLab workspace.

x = size(TabDat.dat); %measures the size of the SPM results table
l = x(1); %iterates on the number of SPM results table rows (numer of peaks listed)
clear res
clear tab

for i = 1:l
    loc = localize(TabDat.dat{i,12}); %uses an external localize functon on a given peak coordinate
    splloc = strsplit(loc, ',');
    if length(splloc) == 1
        res(i).str = 'No gray matter within +/- 5mm';
    else
        res(i).str = splloc{3};
        if strcmp(splloc{5}, '*')
            res(i).ba = splloc{5};
        elseif length(splloc{5})>2
            res(i).ba = splloc{5};
        else
            res(i).ba = splloc{5}(end-1:end);
        end
        res(i).hem = splloc{1}(1:end-length('cerebrum')-1);
        res(i).Zscore = mat2str(round2(TabDat.dat{i, 10}, 0.01));
        res(i).ClusSize = mat2str(TabDat.dat{i, 5});
        res(i).corx = num2str(TabDat.dat{i,12}(1));
        res(i).cory = num2str(TabDat.dat{i,12}(2));
        res(i).corz = num2str(TabDat.dat{i,12}(3));
    end

    
    
    
end
res = res';
tab = struct2cell(res);
tab = tab';
table = cell2table(tab, 'VariableNames', {'Region', 'BA', 'Hemisphere', 'Z','ClusterSize', 'x', 'y', 'z'})

spm('defaults','FMRI')

 
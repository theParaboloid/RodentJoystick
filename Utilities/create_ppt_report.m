function [] = create_ppt_report(dirlist)

stats = load_stats(dirlist,0,0);
stats_ts = load_stats(dirlist,0,1);
pptname = strcat(dirlist(1).name,'\analysis.ppt');


clear fig_handle;
try
[~,~,fig_handle(1)] = np_js_distribution(dirlist,40,1,1,1,1,[]);
[~,~,fig_handle(2)] = np_post_distribution(dirlist,40,1,1,1,1,[]);
exportfigpptx(pptname,fig_handle,[1 2]);
close(fig_handle);
catch e
    display(strcat('Failed np_js distribution: ',e.message));
end


clear fig_handle;
try
[~,~,fig_handle(1)] = activity_heat_map(stats, 1, [2 99], [],[1 100], 1, 0, 1);
[~,~,fig_handle(2)] = activity_heat_map(stats, 1, [2 99], [],[1 100], 2, 0, 1);
[~,~,fig_handle(3)] = activity_heat_map(stats, 1, [2 99], [],[1 100], 3, 0, 1);
exportfigpptx(pptname,fig_handle,[1 3]);
close(fig_handle);
catch
    
end


clear fig_handle;
try
[~,~,fig_handle(1)] = activity_heat_map(stats_ts, 1, [2 99], [],[1 100], 1, 0, 1);
[~,~,fig_handle(2)] = activity_heat_map(stats_ts, 1, [2 99], [],[1 100], 2, 0, 1);
[~,~,fig_handle(3)] = activity_heat_map(stats_ts, 1, [2 99], [],[1 100], 3, 0, 1);
exportfigpptx(pptname,fig_handle,[1 3]);
close(fig_handle);
catch
    
end


clear fig_handle;
try
[~,fig_handle(1)] = multi_anglethreshcross(dirlist,45*(6.35/100),0,0,10,[],1,0,2);
exportfigpptx(pptname,fig_handle,[1 1]);
close(fig_handle);
catch
end


clear fig_handle;
try
[~,fig_handle(1)] = multi_tau_theta(dirlist(end),30*(6.35/100),0,0,[],1,0,2);
[~,fig_handle(2)] = multi_tau_theta(dirlist(end),30*(6.35/100),0,0,[],1,0,3);
exportfigpptx(pptname,fig_handle,[1 2]);
close(fig_handle);
catch
end

clear fig_handle;
try
[~,~,~,~,fig_handle] = angledist_trialevo(dirlist,45,0);
exportfigpptx(pptname,fig_handle,[2 3]);
close(fig_handle);
catch
    display('Failed angledist_trialevo');
end

clear fig_handle;
try
[~,~,~,~,fig_handle] = angledist_timeevo(dirlist,45,0);
exportfigpptx(pptname,fig_handle,[1 1]);
close(fig_handle);
catch
end


clear fig_handle;
try
[~,~,~,~,fig_handle] = posthreshcross_trialevo(dirlist);
exportfigpptx(pptname,fig_handle,[1 2]);
close(fig_handle);
catch
end


clear fig_handle;
try
[~,~,~,~,fig_handle(1)] = posthreshcross_timeevo(dirlist);
exportfigpptx(pptname,fig_handle,[1 1]);
close(fig_handle);
catch
end

clear fig_handle;
try
    
[dirlist_all,name,ext] = fileparts(dirlist(1).name);
[dirlist_all,name,ext] = fileparts(dirlist_all);
dirlist_all = rdir(strcat(dirlist_all,'\*\'),'isdir');

[~,~,~,~,fig_handle] = angledist_trialevo(dirlist_all(65:end),45,0);
exportfigpptx(pptname,fig_handle,[2 3]);
close(fig_handle);
catch
    display('Failed angledist_trialevo');
end


clear fig_handle;
try
[dirlist_all,name,ext] = fileparts(dirlist(1).name);
[dirlist_all,name,ext] = fileparts(dirlist_all);
dirlist_all = rdir(strcat(dirlist_all,'\*\'),'isdir');
    
[~,~,~,~,fig_handle] = angledist_timeevo(dirlist_all(65:end),45,0);
exportfigpptx(pptname,fig_handle,[1 1]);
close(fig_handle);
catch
end

clear fig_handle;
try
[dirlist_all,name,ext] = fileparts(dirlist(1).name);
[dirlist_all,name,ext] = fileparts(dirlist_all);
dirlist_all = rdir(strcat(dirlist_all,'\*\'),'isdir');  
    
[~,~,~,~,fig_handle] = posthreshcross_trialevo(dirlist_all(65:end));
exportfigpptx(pptname,fig_handle,[1 2]);
close(fig_handle);
catch
end

clear fig_handle;
try
[dirlist_all,name,ext] = fileparts(dirlist(1).name);
[dirlist_all,name,ext] = fileparts(dirlist_all);
dirlist_all = rdir(strcat(dirlist_all,'\*\'),'isdir');

[~,~,~,~,fig_handle(1)] = posthreshcross_timeevo(dirlist_all(65:end));
exportfigpptx(pptname,fig_handle,[1 1]);
close(fig_handle);
catch
end
close all
clear fig_handle;


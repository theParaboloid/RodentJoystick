function [theta_nl,theta_nl_rt,theta_l,theta_l_rt,fig_handle] = angledist_timeevo(dirlist,varargin)

default = {45,1};
numvarargs = length(varargin);
if numvarargs > 2
    error('too many arguments (> 3), only 1 required and 2 optional.');
end
[default{1:numvarargs}] = varargin{:};
[dist,save_flag] = default{:};
theta_l = [];
theta_l_rt = [];
theta_nl = [];
theta_nl_rt = [];


for i = 1:length(dirlist)
%   i
    [pathstr,name,ext] = fileparts(dirlist(i).name);
    [pathstr_rule,name,ext] = fileparts(pathstr);
    contingency_angle = strsplit(name,'_');
    
    out_thresh = str2num(contingency_angle{2});
    hold_time(i) = str2num(contingency_angle{3});
    hold_thresh(i) = str2num(contingency_angle{4});
    angle1(i) = str2num(contingency_angle{5});
    angle2(i) = str2num(contingency_angle{6});
    
    try
    stats = load_stats(dirlist(i),0,1);
    stats = get_stats_with_len(stats,50);
    stats = get_stats_startatzero(stats,hold_thresh(i));
    stats_l = get_stats_with_trajid(stats,1);
    stats_nl = get_stats_with_trajid(stats,2);
    [~,theta_l_t,theta_l_rtime] = anglethreshcross(stats_l,out_thresh(i)*(6.35/100),0,0,1,10,[],0);
    [~,theta_nl_t,theta_nl_rtime] = anglethreshcross(stats_nl,out_thresh(i)*(6.35/100),0,0,1,10,[],0);
    catch
    end
   
    theta_l = [theta_l theta_l_t];
    theta_l_rt = [theta_l_rt theta_l_rtime];
    theta_nl = [theta_nl theta_nl_t];
    theta_nl_rt = [theta_nl_rt theta_nl_rtime];
    angle_index_nl(i) = numel(theta_nl);
    angle_index_l(i) = numel(theta_l);
end
offset = floor(min(theta_l_rt));
theta_l_rt = theta_l_rt - offset;
theta_nl_rt = theta_nl_rt - offset;
end_point = ceil(max(max(theta_l_rt),max(theta_nl_rt)));
fig_handle = figure;
h2 = plot(theta_nl_rt,theta_nl,'ro','MarkerSize',4);
%set(h2,'MarkerFaceColor','r');
hold on;
h1 = plot(theta_l_rt,theta_l,'ko','MarkerSize',4);
%set(h1,'MarkerFaceColor','k');
axis([0 end_point -180 180]);

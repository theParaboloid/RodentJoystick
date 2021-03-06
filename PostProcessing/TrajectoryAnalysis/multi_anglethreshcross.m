function [console_output,fig_handle] = multi_anglethreshcross(dirlist,varargin)

default = {30*(6.35/100),0,0,1,[],1,0,0};
numvarargs = length(varargin);
if numvarargs > 9
    error('too many arguments (> 10), only 1 required and 9 optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh,trajid,rw_only,interv,ax,plotflag,combineflag,lasercompareflag] = default{:};
fig_handle= [];

if plotflag
    if numel(ax)<1
        fig_handle = figure;
        ax = gca;
    end
end

colors = 'rbkmcgyrbkmcgyrbkmcgy';

if (lasercompareflag-1)
    combineflag=1;
    trajid=0;
    
    [statslist, dates] = load_stats(dirlist, combineflag,0, 'traj_struct');
    statshit = get_stats_with_trajid(statslist,1);
    statscatch = get_stats_with_trajid(statslist,lasercompareflag);
    dates{2} = strcat(dates{1},'-nl');
    dates{1} = strcat(dates{1},'-l');
    
    statslist(1) = statshit;
    statslist(2) = statscatch;
else
    [statslist, dates] = load_stats(dirlist, combineflag,0, 'traj_struct');
end

for i= 1:length(statslist)
    stats = get_stats_with_trajid(statslist(i),trajid);
    [~,theta{i}] = anglethreshcross(stats,thresh,0,rw_only,interv,ax,plotflag,colors(i));    
    console_output{i+1} = sprintf(strcat(dates{i},' Med: %d'),median([theta{i}]));
end

console_output{1} = 'Angle at Thresh';
if (lasercompareflag-1)
    [h,p] = kstest2([theta{1}],[theta{2}]);
    console_output{end+1} = sprintf('P value: %f',p);
end

if plotflag
    axes(ax);
    legend(dates);
    title(strcat('Angle at threshold Crossing :',num2str(thresh)));
end



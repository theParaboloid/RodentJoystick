function [angle_distr, fh, trajindices] = find_sector(stats, varargin)
%argument handling
default = {95, 'log', [20 80]};
numvarargs = length(varargin);
if numvarargs > 3
    error('trajectory_analysis: too many arguments (> 3), only one required and three optional.');
end
[default{1:numvarargs}] = varargin{:};
[thresh, pflag, colorperc] = default{:};
%if strcmp(pflag, 'log'); colorperc = [0 95]; end;

tstruct = stats.traj_struct;
%360th slot corresponds to 0
%trajectory_indices:
trajindices(1) = struct('traj_ind', []);
for i= 2:360; trajindices(i) = struct('traj_ind', []); end;
angle_distr = zeros(360,1); sample_size = 0;
for i = 1:length(tstruct)
    [first, second] = get_sector(tstruct(i).traj_x,tstruct(i).traj_y,thresh);
    if first ~= -1 && second ~= -1
        if (first == 0); first = 360; end
        if (second == 0); second = 360; end
        if (first>second)
            indices = [first:360, 1:second];
            %add information to struct containing trajectory in
            for j = first:360
                trajindices(j).traj_ind = [trajindices(j).traj_ind; i];
            end
            for j = 1:second
                trajindices(j).traj_ind = [trajindices(j).traj_ind; i];
            end 
        else
            indices = first:second;
            for j = indices
                trajindices(j).traj_ind = [trajindices(j).traj_ind; i];
            end
        end
        %add information about sector covered by trajectory to 
        %angle_distribution 
        angle_distr(indices)=1+angle_distr(indices);
        %note that not all trajectories are actually used, in computing a
        %quarter, we only end up taking the subset above the trajectory
        sample_size = sample_size + 1;
    end
end
for i = 1:360; trajindices(i).traj_ind = sort(trajindices(i).traj_ind); end
fh = draw_plots(stats, angle_distr, pflag, colorperc);
if sample_size < 10
    vec = ['Threshhold is too large, or not enough data. Not enough samples.'];
    error(vec);
end

end

function [first, second] = calc_target_sector(start_angle, traj_indices)
    
end

function fh = draw_plots(stats, angle_distr, pflag, colorperc)
%just gathering data, with some processing;
data = stats.traj_pdf_jstrial;
if strcmp(pflag, 'log')
    data = log(data);
    traj_pdf = reshape(data, 100*100, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= -Inf ));
else
    traj_pdf = reshape(data, 100*100, 1);
    traj_pdf = sort(traj_pdf(traj_pdf ~= 0));
end

fh = figure('Position', [100, 100, 1200, 500]);
%Plot results from traj_pdf
subplot(1,3,1); hold on;
title(['Trajectory Distribution: (',pflag,' scale)']); 
xlabel('X Position+50'); ylabel('Y Position + 50');
pcolorval2 = traj_pdf(floor(colorperc(2)/100*length(traj_pdf)));
pcolorval1 = traj_pdf(floor(colorperc(1)/100*length(traj_pdf))+1);
pcolor(data); shading flat; axis square; caxis([pcolorval1 pcolorval2]); hold off;

%grey color values for linear angle distribution
colorv = [0.75 0.7 0.6 0.5];

%plot normalized angle distribution
subplot(1,3,2); 
axis([1 359 0 inf]); axis square; hold on;
for i = 25:25:100
    angle_dist = get_angle_distr_for_thresh(stats, i);
    c = colorv(i/25);
    plot(1:1:360, angle_dist./(sum(angle_dist)), 'Color', [c c c]);
end
plot(1:1:360, angle_distr./sum(angle_distr), 'r');

%plot polar angle distribution
subplot(1,3,3);
theta = (1:1:360)*pi./180;
axmax = max(angle_distr./sum(angle_distr));
for i = 25:25:100
    angle_dist = get_angle_distr_for_thresh(stats, i); c = colorv(i/25); hold on;
    l=polar(theta', angle_dist./sum(angle_dist)); hold on;
    axmax = max([axmax, max(angle_dist./sum(angle_dist))]);
    set(l,'Color', [c c c]);
end
polar(theta', angle_distr./sum(angle_distr), 'b'); hold on;
axis([(-axmax) axmax (-axmax) axmax]); axis square;
hold off;
end


function [angle_distr] = get_angle_distr_for_thresh(stats, thresh)
tstruct = stats.traj_struct;
%360th slot corresponds to 0
angle_distr = zeros(360,1);
for i = 1:length(tstruct)
    [first, second] = get_sector(tstruct(i).traj_x,tstruct(i).traj_y,thresh);
    if first ~= -1 && second ~= -1
        if (first == 0); first = 360; end
        if (second == 0); second = 360; end
        indices = first:second;
        if (first>second); indices = [first:360, 1:second]; end
        angle_distr(indices)=1+angle_distr(indices);
    end
end
end

%get_sector(x,y, thresh) obtains the sector found by looking at all x,y
%values of the trajectory with magnitude above the threshold.
%The sector is given as two positive angles in [0, 359] with first = the
%start of the sector, and second the end, always moving counterclockwise
function [first, second] = get_sector(x, y, thresh)
    [angles, rad] = cart2pol(x, y);
    angles=angles(rad>thresh).*180./pi;
    if length(angles)<2
        first = -1; second = -1;
    else
        minim = floor(min(angles));
        maxim = floor(max(angles));
        %weird trajectory - give error signal
        if (minim == maxim) || (length(angles) == 2) || minim > maxim || length(angles)<2
            first = -1; second = -1;            
        else
            angles = angles(angles~=minim & angles~=maxim);
            test= angles(floor(length(angles)/2)+1);
            if test<minim || test > maxim
                first = maxim; second = minim;
            else
                first = minim; second = maxim;
            end
            if first<0
                first = first+360;
            end
            if second<0
                second = second+360;
            end
        end
    end
end
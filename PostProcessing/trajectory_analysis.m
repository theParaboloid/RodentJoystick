function [sortedtraj ] = trajectory_analysis(stats, bin_length)
TIME_RANGE = 2000;
%trajectory_analysis(stats, bin_length)
%   ARGUMENTS:

%place into bins (groups), mini structures
%iterate over bin ->
    %normalize (all on 100 ms time scale)-> mean, median, std above, below
    %for each data point
    % don't normalize (all on 100ms time scale) -> (4 above)
% should be able to plot?
bins=0:bin_length:TIME_RANGE;
tstruct=stats.traj_struct; 
holdtimes = hold_time_distr(tstruct, bin_length, 'data');
sortedtraj = sort_traj_into_bins(tstruct, bins, holdtimes);

%test plot below
bin2 = sortedtraj(2);
time = 0:1:bin2.lt-1;
[mean, median, stdev, numbers] = bin_stats(bin2);
figure(1);
plot(time, mean, time, median, time, mean+stdev, time, mean-stdev, time, numbers);


end

%bin_summary is a struct with length bin.lt 
%   bin_summary has the following fields (for each time i)(different from the outputs!!!): 
%       position := a vector of magnitudes corresponding to the various trajectories at time i.
%       mean := single value corresponding to the average position at that
%           time
%       median := single value of median position at that time
%       stdev := a single value that corresponds to the standard deviation
%           at the time i
%       numtraj := number of trajectories that lasted at least as long as
%       time i.
% mean, median, std are all number 
function [mean, median, stdev, numbers, bin_summary] = bin_stats(bin)
    for time = 1:(bin.lt-1)
        time_pos_ind = 0;
        for i = 1:(length(bin.trajectory))
            try 
                pos = bin.trajectory(i).magtraj(time); 
                %attempt to access the position of trajectory i at time
            catch err
                pos = -1000; % error signal if trajectory doesn't go that far
            end
            if pos > -1
                time_pos_ind = time_pos_ind+1;
                bin_summary(time).position(time_pos_ind) = pos;
            end
        end
        bin_summary(time).numtraj = time_pos_ind;
        bin_summary(time).mean = mean(position);
        bin_summary(time).med = median(position);
        bin_summary(time).stdev = std(position);
        
        numbers(time)= bin_summary(time).numtraj;
        mean(time) = mean(position);
        median(time) =bin_summary(time).med;
        stdev(time) = bin_summary(time).stdev;
    end
end

% will be a vector of structs containing fields for the range
% each struct has a field for a vector of structs containing
% trajectories
function sortedtraj = sort_traj_into_bins(tstruct, bins, holdtimes)

for i = 2:length(bins)
   sortedtraj(i-1) = struct('geq', bins(i-1),'lt',bins(i));
end
bin_traj_indices = ones(length(bins)-1, 1); 
%each bin has a vector of trajectory structures (simplified from tstruct)
% store the indices so we know at what index to add each new trajectory
for i = 1:length(holdtimes)
    bin_ind = bin_index(bins, holdtimes(i));
    traj_ind = bin_traj_indices(bin_ind);
    bin_traj_indices(bin_ind) = bin_traj_indices(bin_ind) + 1;
    sortedtraj(bin_ind).trajectory(traj_ind)= struct('magtraj', tstruct(i).magtraj, 'time', holdtimes(i));
end
end

% Bin indexing starts with 1 at the first nonzero element. Ie, If the bins
% are distributed as bins = [0 10 20 30 40],
%       bin_index(bins, 5) = 1, bin_index(bins 0) = 1
%       bin_index(bins, 9) = 1, bin_index(bins 10) = 2

function bin_ind = bin_index(bins, time)
    for i = 2:length(bins)
        if time < bins(i)
            bin_ind = i-1; break;
        end
    end
end
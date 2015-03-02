
function js_touch_dist(stats,targ_time,targ_reward,dist_thresh,all_traj_flag)
k=0;
traj_struct=stats.traj_struct;
start_prev=0;

holdlength=[];
for i=1:length(traj_struct)
    
    if (traj_struct(i).start_p == start_prev) && (all_traj_flag==0)
        holdlentemp = getmaxcontlength(traj_struct(i).magtraj,dist_thresh);
        compare_flag=holdlentemp>holdlength(k);
        if compare_flag
            holdlength(k) = holdlentemp;
        end
    else 
        k=k+1;
        holdlength(k) = getmaxcontlength(traj_struct(i).magtraj,dist_thresh);
    end
    start_prev = traj_struct(i).start_p;
end

k=0;
holdlength_prev=0;
for i=1:length(traj_struct)
    
    if traj_struct(i).start_p == start_prev
        holdlentemp = getmaxcontlength(traj_struct(i).magtraj,150);
        compare_flag=holdlentemp>holdlength_prev;
        if compare_flag
            holdlength_prev = holdlentemp;
            if traj_struct(i).posttouch>targ_time
                dist_distri(k) = max(traj_struct(i).magtraj(1:targ_time));
            else
                dist_distri(k) = 0;
            end
        end
    else
        k=k+1;
        holdlength_prev = getmaxcontlength(traj_struct(i).magtraj,150);
        if traj_struct(i).posttouch>targ_time
            dist_distri(k) = max(traj_struct(i).magtraj(1:targ_time));
        else
            dist_distri(k) = 0;
        end
    end
    start_prev = traj_struct(i).start_p;
end

dist_distri=dist_distri(dist_distri>0);
dist_time_hld = 0:10:600;
holddist_vect = histc(holdlength,dist_time_hld);
figure
stairs(dist_time_hld, holddist_vect,'k','LineWidth',2);

time_success = length(dist_distri)/k;
c = histc(dist_distri,1:1:100);
success_prob = cumsum(c)/sum(c);
targ_dist = find(success_prob>(targ_reward/time_success));


%figure(1); hist_int = 5; hold on;
%c = histc(dist_distri,0:hist_int:100);
%xlabel('Joystick Distance');
%ylabel('Count');
%stairs(0:hist_int:100, c);
if numel(targ_dist)>0
    set_dist = targ_dist(1);
else
    set_dist = 100;
end

disp(strcat('set_threshold:   ', num2str(set_dist)));
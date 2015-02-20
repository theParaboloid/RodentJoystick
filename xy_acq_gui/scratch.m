% h1 = figure;
% 
% h2 = figure;
function [trial_len]=pp_traj_anly(jstruct);
windowSize=20;
k=0;
fail=0;
succ=0;
trial_len = 0;
for i=1:149
    if numel(jstruct(i).js_pairs)>0 && numel(jstruct(i).np_pairs)>0
        np_pairs = jstruct(i).np_pairs;
        js_pairs = jstruct(i).js_pairs;
        rw_onset = jstruct(i).reward_onset;
        js_reward = jstruct(i).js_reward;
        for j=1:size(jstruct(i).js_pairs,1)
            
            %check if js movement happens in between nosepokes
            
            if(sum(((np_pairs(:,1)-js_pairs(j,1))<0)&((np_pairs(:,2)-js_pairs(j,1))>0))>0)
            
            c = (np_pairs(:,1)-js_pairs(j,1))<0;
            start_p = max(np_pairs(c));
            if numel(start_p)>0
                
                traj_x = jstruct(i).traj_x((start_p):(js_pairs(j,2)))-2.53;
                traj_y = jstruct(i).traj_y((start_p):(js_pairs(j,2)))-2.48;
                traj_x = filter(ones(1,windowSize)/windowSize,1,traj_x);
                traj_y = filter(ones(1,windowSize)/windowSize,1,traj_y);
                traj_x = traj_x(20:end-20);
                traj_y = traj_y(20:end-20);
                
                if ((traj_x(1)^2+traj_y(1)^2)^(0.5))<0.05
                    k=k+1;
                    trial_len(k) = sum(((traj_x.^2+traj_y.^2).^(0.5))>0.2));
                    
%                     if (js_reward(j))
%                         figure(h2);
%                         plot(traj_x,traj_y,'r');
%                         plot(traj_x(1:200:end),traj_y(1:200:end),'ro');
%                         hold on
%                         succ = succ+1;
%                     else
%                         figure(h1);
%                         plot(traj_x,traj_y,'b');
%                         plot(traj_x(1:200:end),traj_y(1:200:end),'bo');
%                         hold on
%                         fail = fail+1;
%                     end
%                     plot(traj_x(1),traj_y(1),'rx');
%                     axis([-0.8 0.8 -0.8 0.8])
                    
                end
            end
            end
        end
    end
end
succ
fail

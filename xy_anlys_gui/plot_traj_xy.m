function plot_traj_xy(traj_struct,t_step,offset_index,pl_index,handles)

%BOX CIRCLE RADIUS
RADIUS = 6.35;
fullplot_Axes = handles.axes6;
axes(fullplot_Axes);
cla; axis manual;
hold on;

%attempt getting contingency information from directory;
try
    working_dir = get(handles.working_dir_text,'String');
    stuff = strsplit(working_dir, '\');
    datecont = strsplit(stuff{end-1}, '_');
    thresh2 = str2num(datecont{2})*RADIUS/100;
    thresh = str2num(datecont{4})*RADIUS/100;
catch
end

%Plot Inner Thresh
x = thresh*cosd(0:1:360);
y = thresh*sind(0:1:360);
plot(x,y,'k','LineWidth',2);

%Plot Outer Thresh
x = thresh2*cosd(0:1:360);
y = thresh2*sind(0:1:360);
plot(x,y,'k','LineWidth',2);

%Plot Sector
rw_fr = str2num(get(handles.rw_zone_fr,'String'));
rw_to = str2num(get(handles.rw_zone_to,'String'));
x = cosd(1:1:360); y = sind(1:1:360);

if abs(rw_fr-rw_to) < 360
    plot(thresh*x(rw_fr:rw_to),thresh*y(rw_fr:rw_to),'c','LineWidth',2);
    plot(thresh2*x(rw_fr:rw_to),thresh2*y(rw_fr:rw_to),'c','LineWidth',2);
end

%Plot Radius
x = RADIUS*cosd(0:1:360);
y = RADIUS*sind(0:1:360);
plot(x,y,'k','LineWidth',2);


axis([-100 100 -100 100])
axis square;
k=pl_index;

traj_x=traj_struct(k).traj_x;
traj_y=traj_struct(k).traj_y;
%Scaling from Percents and smoothing
t_x = smooth(traj_x*(RADIUS/100), 3);
t_y = smooth(traj_y*(RADIUS/100), 3);

end_color = hsv2rgb([1 1 1]);
marker_color = hsv2rgb([0.6 1 1]);
step_color = (end_color - marker_color)/(floor(length(traj_x)/t_step)+1);
if numel(traj_x) > 0
    start_p = traj_struct(k).start_p ;
    js_reward=traj_struct(k).rw;
    max_value = traj_struct(k).max_value;
   
    switch offset_index
        case 1
            offset = length(traj_x);
        case 2
            offset = max_value;
        otherwise
            offset = length(traj_x);
    end

    if numel(offset)>0
        t_x = t_x(1:offset); t_y = t_y(1:offset);
        plot(t_x,t_y,'k');
        plot(t_x(end),t_y(end),'rx','MarkerSize',10,'LineWidth',2);
        plot(t_x(1),t_y(1),'bx','MarkerSize',10,'LineWidth',2);
        if t_step>1
            for i = t_step:t_step:offset
                plot(t_x(i),t_y(i), 'MarkerFaceColor', marker_color, 'Marker', 'O', 'MarkerSize', 5);
                marker_color = marker_color + step_color;
            end
        end
        axes(fullplot_Axes);
    end
end

axis([-1 1 -1 1]*RADIUS*1.08);
hold off;
end
function npjs_pairscount = multipcolor_np_js(boxdir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tmpdirlist = rdir([boxdir, '\*\*']);
for i = 1:length(tmpdirlist)
    if ~tmpdirlist(i).isdir; break; end;
    dirlist(i) = tmpdirlist(i);
end

statslist = load_stats(dirlist, 2, 'np_js');
for i = 1:length(statslist)
    npjs_pairscount(i) = length(statslist(i).np_js);
end

interv = 100;
data = np_js_distribution(dirlist, interv, 1, 2, 1, 0);
accumdata = [];
for i = 1:length(data);
    tmpdata = data{i};
    np_js = tmpdata(:, 2);
    accumdata = [accumdata; np_js'];
end
x = -1000:interv:1000;
y = 1:size(accumdata, 1);
figure; ax = gca;
pcolor(ax, x, y, accumdata);
shading flat;
title(ax, 'Nosepoke Aligned Joystick Contact Distribution');
xlabel(ax, 'Joystick Onset after Nosepoke (ms)');
ylabel(ax, 'Day');
line([0 0], [0 length(y)], 'LineWidth', 3, 'Color', [0 0 0]);
colorbar;
for i = 1:length(y)
    line([-1000 1000], [i i], 'LineWidth', 0.5, 'Color', [0 0 0]);
end
    
set(ax, 'XTick', -1000:250:1000);


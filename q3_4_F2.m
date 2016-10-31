










% -------------------------------------------------------------------------
% ANALYSIS
% -------------------------------------------------------------------------

tic

% the color map
map = flipud(colormap('jet'));



% what road qualities do the collisions occur on?
%figure(3);



figure(3);
clf 
hold on
for i = 0:99
    bar(i, collision_PCIs(i+1), 'FaceColor', map(map_interval(i, [0 100]),:), 'EdgeColor', [.8 .8 .8], 'BarWidth', 1)
end
xlabel('PCI')
ylabel('# collisions')
axis([-.5 100.5 0 14000])
title('PCI collision distribution without PCI = 100 road segments')

axes('Position', [.25 .6 .2 .2])
hold on
for i = 0:100
    bar(i, collision_PCIs(i+1), 'FaceColor', map(map_interval(i, [0 100]),:), 'EdgeColor', [.8 .8 .8], 'BarWidth', 1)
end
xlabel('PCI')
ylabel('# collisions')
axis([-.5 100.5 0 11e4])
saveas(gca, '/Users/ldudte/Dropbox/DIS/Q3/F2_1.png')




figure(4);
clf 
hold on
for i = 0:99
    bar(i, length_PCIs(i+1), 'FaceColor', map(map_interval(i, [0 100]),:), 'EdgeColor', [.8 .8 .8], 'BarWidth', 1)
end
xlabel('PCI')
ylabel('length (km)')
axis([-.5 100.5 0 2e4])
title('PCI length distribution without PCI = 100 road segments')

axes('Position', [.25 .6 .2 .2])
hold on
for i = 0:100
    bar(i, length_PCIs(i+1), 'FaceColor', map(map_interval(i, [0 100]),:), 'EdgeColor', [.8 .8 .8], 'BarWidth', 1)
end
xlabel('PCI')
ylabel('length (km)')
axis([-.5 100.5 0 2.75e5])
saveas(gca, '/Users/ldudte/Dropbox/DIS/Q3/F2_2.png')


figure(5); 
clf 
hold on
for i = 0:100 
    bar(i, collision_PCIs(i+1)/length_PCIs(i+1), 'FaceColor', map(map_interval(i, [0 100]),:), 'EdgeColor', [.8 .8 .8], 'BarWidth', 1)
end
xlabel('PCI')
ylabel('# collisions/length')
axis([-.5 100.5 0 1])
title('Normalized collision distribution (all data)')
saveas(gca, '/Users/ldudte/Dropbox/DIS/Q3/F2_3.png')





% how many roads are involved in the collisions?
% make histogram of collisions by # roads involved
collision_road_sizes = cell2mat(cellfun(@(x)size(x), collision_roads, 'UniformOutput', 0));
collision_road_sizes(:,2) = [];

figure(6)
clf
histogram(collision_road_sizes)
xlabel('# road segments involved in collision')
ylabel('# collisions')
axis([-.5 6.5 0 11e4])
title('How many road segments are involved in a collision?')
saveas(gca, '/Users/ldudte/Dropbox/DIS/Q3/F2_4.png')


% how many roads had 0 collisions? 1 collision? x collisions?
% make histogram of # of roads by collisions on that road
road_collision_sizes = cell2mat(cellfun(@(x)size(x), road_collisions, 'UniformOutput', 0));
road_collision_sizes(:,2) = [];


[N, edges] = histcounts(road_collision_sizes);
bin_x = diff(edges) + edges(1:end-1);
%bin_x(N==0) = [];
%N(N==0) = [];


figure(7)
clf
histogram(road_collision_sizes)
ylabel('# road segments')
xlabel('# collisions on road segment')
title('How many collisions have happened on a road segment?')
axis([0 325 0 3e4])

axes('Position', [.45 .45 .4 .4])
loglog(bin_x, N, '.')
hold on
loglog(1:325, 2e5*(1:325).^(-1))
saveas(gca, '/Users/ldudte/Dropbox/DIS/Q3/F2_5.png')

disp('plotted everything')

toc



























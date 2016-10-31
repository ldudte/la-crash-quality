
% -------------------------------------------------------------------------
% LA BOUNDARY DATA
% -------------------------------------------------------------------------

tic 

% https://data.lacity.org/A-Livable-and-Sustainable-City/City-Boundary-of-Los-Angeles/ppge-zfr4

% files
boundary_filename = '/Users/ldudte/Dropbox/DIS/Q3/data/City_Boundary.csv';

disp(boundary_filename)

% read and process data
T = readtable(boundary_filename);
boundary = convert_geom(T{1,1});

% separate holes from main boundary
boundaries_ind = 1;
boundaries = {};
segment_start_ind = 1;
eps = .025;
for i = 2:size(boundary,1)
    if norm(boundary(i,:) - boundary(i-1,:)) > eps
    
        % store a new boundary segment
        boundaries{boundaries_ind} = boundary(segment_start_ind:i-1,:);
        segment_start_ind = i;
        boundaries_ind = boundaries_ind + 1;
        
    end
end
if segment_start_ind ~= size(boundary,1)
    boundaries{boundaries_ind} = boundary(segment_start_ind:end,:);
end

% stitch up the main boundary (threshold parameter a bit small for it)
main_boundary = [];
for i = 1:5
    main_boundary = [main_boundary; boundaries{i}];
end

clear T


disp('loaded + processed boundary data')
toc













% -------------------------------------------------------------------------
% F1
% -------------------------------------------------------------------------

tic


labels = {'Santa Monica', 'Beverly Hills', 'Inglewood', 'Long Beach', 'Downtown', 'Pasadena', 'Topanga State Park', 'Manhattan Beach', 'Burbank'};

label_coords = [-118.4912 34.0195; -118.4004 34.086; -118.3531 33.9617; -118.1937 33.7701; -118.2468 34.0407; -118.1445 34.1478; -118.5506 34.0882; -118.4109 33.8847; -118.3090 34.1808];



% the color map
map = flipud(colormap('jet'));


% compute horizontal shrink to correct for latitude
shrink = cos(mean(collisions(:,2))*pi/180);



% plot PCIs
f=figure(1);
clf
hold on
axis off
axis equal
axis([-98.3, -97.8, 33.65, 34.4])

for i = 1:length(roads)    
    if ~isnan(PCI(i))
        %if rand < .05
        plot(shrink*roads{i}(:,1), roads{i}(:,2), '-', ...
            'Color', map(map_interval(PCI(i), [0 100]),:), 'LineWidth', .25)
        %end
    end        
end

plot(shrink*main_boundary(:,1), main_boundary(:,2), '-k', 'LineWidth', 1)
for i = 6:length(boundaries)
    plot(shrink*boundaries{i}(:,1), boundaries{i}(:,2), '-k', 'LineWidth', 1)
end


for i = 1:length(labels)
    
    text(label_coords(i,1)*shrink, label_coords(i,2), labels{i}, ...
        'HorizontalAlignment', 'center', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal')
    
end


line([-98.25 -98.25], [34 34+2*0.009], 'LineWidth', 1, 'Color', 'k')
text(-98.25+.009/2, 34.009, '2 km', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal')



for i = 1:20   
    line([-98.25 -98.25], [33.98 - (i-1)/500, 33.98 - i/500], 'LineWidth', 1, 'Color', map(map_interval(i, [20 1]),:))    
end
text(-98.25+.009/2, 33.98 - (10.5-1)/500, 'Pavement Condition Index (PCI)', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal')
text(-98.25, 33.98 - (-2-1)/500, '100', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal', 'HorizontalAlignment', 'center')
text(-98.25, 33.98 - (24-1)/500, '0', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal', 'HorizontalAlignment', 'center')
text(-98.25+.009*.8, 33.98 - (-2-1)/500, 'good', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal')
text(-98.25+.0045, 33.98 - (24-1)/500, 'bad', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal')




text((-98.3 + -97.8)/2, 34.375, 'Road Quality in LA', 'FontName', 'Helvetica', 'FontSize', 10, 'FontWeight', 'normal', 'HorizontalAlignment', 'center')






f.PaperUnits = 'inches';
f.PaperPosition = [0 0 10 14];


saveas(gca, '/Users/ldudte/Dropbox/DIS/F1_1.png')
close





% plot collisions
f=figure(2);
clf
hold on
axis off
axis equal
axis([-98.3, -97.8, 33.65, 34.4])

% for i = 1:length(roads)
%     if ~isnan(PCI(i))        
%         plot(shrink*roads{i}(:,1), roads{i}(:,2), '-', 'Color', [.5 .5 .5], 'LineWidth', .1)
%     end        
% end

marker_size = 1.5;

for i = 1:length(num_collisions)
    
    prev_num_collisions = sum(num_collisions(1:i-1));        
    
    plot(shrink*collisions(prev_num_collisions+1:prev_num_collisions+num_collisions(i),1), ...
                collisions(prev_num_collisions+1:prev_num_collisions+num_collisions(i),2), ...
                '.r', 'MarkerSize', marker_size)
    
end

plot(shrink*main_boundary(:,1), main_boundary(:,2), '-k', 'LineWidth', 1)
for i = 6:length(boundaries)
    plot(shrink*boundaries{i}(:,1), boundaries{i}(:,2), '-k', 'LineWidth', 1)
end


for i = 1:length(labels)
    
    text(label_coords(i,1)*shrink, label_coords(i,2), labels{i}, ...
        'HorizontalAlignment', 'center', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal')
    
end


line([-98.25 -98.25], [34 34+2*0.009], 'LineWidth', 1, 'Color', 'k')
text(-98.25+.009/2, 34.009, '2 km', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal')

plot(-98.25, 33.98, '.r', 'MarkerSize', marker_size)
text(-98.25+.009/2, 33.98, '224,540 total collisions', 'FontName', 'Helvetica', 'FontSize', 6, 'FontWeight', 'normal')


text((-98.3 + -97.8)/2, 34.375, 'Vehicle Collisions in LA 2011-2016', 'FontName', 'Helvetica', 'FontSize', 10, 'FontWeight', 'normal', 'HorizontalAlignment', 'center')




f.PaperUnits = 'inches';
f.PaperPosition = [0 0 10 14];

saveas(gca, '/Users/ldudte/Dropbox/DIS/F1_2.png')
close


disp('plotted Figure 1')

toc




clearvars -except collisions num_collisions roads PCI collision_PCIs length_PCIs road_collisions collision_roads node2road






















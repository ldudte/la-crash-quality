







% -------------------------------------------------------------------------
% CONNECT COLLISIONS TO ROADS and CALCULATE COLLISIONS PER PCI
% -------------------------------------------------------------------------

tic
disp('connecting collisions to roads')

% put all the road nodes into one array
all_road_nodes = cell2mat(roads);
num_road_nodes = size(all_road_nodes,1);

% build index from nodes to roads
road_sizes = cell2mat(cellfun(@(x)size(x), roads, 'UniformOutput', 0));
road_sizes(:,2) = [];
node2road = zeros(num_road_nodes,1); 
start_ind = 1;
for i = 1:length(roads)
    node2road(start_ind:start_ind+road_sizes(i)-1) = i;
    start_ind = start_ind + road_sizes(i);
end

% takes ~7 min --> could definitely be optimized with spatial algos
% but works fine if you cache the results
eps = 1e-6;
collision_PCIs = zeros(101,1); % counts of collisions for each PCI value
road_collisions = cell(length(roads),1); % length # roads, array with all collisions inds on this road
collision_roads = cell(size(collisions,1),1); % length # collisions, array with the road inds of this collision

% associate collisions with roads and vice versa
for i = 1:size(collisions,1)
    
    % report progress
    if mod(i,1000) == 0
        disp(strcat(num2str(i/size(collisions,1)*100),'%'))
    end
    
    % find roads closest to this collision position
    distance_to_road_nodes = sum((repmat(collisions(i,:), num_road_nodes, 1) - all_road_nodes).^2,2);
    min_dist = min(distance_to_road_nodes);
    if min_dist < eps 
        
        % get the road(s) for this collision
        closest_road_inds = sort(unique(node2road(distance_to_road_nodes == min_dist)));
        
        % store this collision index in all these roads
        for j = 1:length(closest_road_inds)
            road_collisions{closest_road_inds(j)} = [road_collisions{closest_road_inds(j)}; i];
        end
        
        % store the roads belonging to this collision
        collision_roads{i} = closest_road_inds;
        
        % collect these PCIs
        these_PCIs = PCI(closest_road_inds);
        these_PCIs(isnan(these_PCIs)) = [];
        collision_PCIs(these_PCIs+1) = collision_PCIs(these_PCIs+1) + ones(length(these_PCIs),1);
        
    end
end



toc



% -------------------------------------------------------------------------
% CALCULATE ROAD LENGTH PER PCI
% -------------------------------------------------------------------------

tic
disp('calculating road lengths')

R = 6371.471; % radius of earth at LA latitude

length_PCIs = zeros(101,1);

% % calculate lengths of all roads and store at given PCI
for i = 1:length(roads)    
    if ~isnan(PCI(i))            
        this_length = 0;
        for j = 1:size(roads{i},1)-1
            this_length = this_length + great_circle_distance(roads{i}(j,:), roads{i}(j+1,:), R);
        end    
        length_PCIs(PCI(i)+1) = length_PCIs(PCI(i)+1) + this_length;        
    end    
end


toc



clearvars -except collisions num_collisions roads PCI collision_PCIs length_PCIs road_collisions collision_roads node2road
























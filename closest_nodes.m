function nodes = closest_nodes(point, all_points)    
    
    distance_to_points = sum((repmat(point, size(all_points,1), 1) - all_points).^2,2);    
    closest_nodes = find(distance_to_points == min(distance_to_points));

end


function location = convert_location(linestring)

    location = strsplit(char(linestring), {'(', ')', ',', ' '});     
    location([1 end]) = []; % remove 'LINESTRING' and ''    
    location = reshape(str2num(char(location))', 2, length(location)/2)';

end


function geom = convert_geom(linestring)

    geom = strsplit(char(linestring), {'(', ')', ',', ' '}); 
    geom([1 end]) = []; % remove 'LINESTRING' and ''
    
    geom = reshape(str2num(char(geom))', 2, length(geom)/2)';

end


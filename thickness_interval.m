function thickness = thickness_interval(val, the_domain)
    
    thickness_int = [1 1];

    thickness = (val - the_domain(1))/(the_domain(2) - the_domain(1))*(thickness_int(2)-thickness_int(1)) + thickness_int(1);
    
end


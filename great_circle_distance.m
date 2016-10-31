function dist = gread(startStation, endStation, R)

    
    dist = R*2*asin(sqrt(sin(endStation(1) - startStation(1)).^2 + cos(startStation(1)).*cos(endStation(1)).*sin(endStation(2) - startStation(2)).^2));

end


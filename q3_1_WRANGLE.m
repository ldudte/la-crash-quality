clear all







% -------------------------------------------------------------------------
% ROAD QUALITY DATA
% -------------------------------------------------------------------------

tic

% https://data.lacity.org/A-Livable-and-Sustainable-City/Road-Surface-Condition-Map/d9rz-k88a

% files
road_quality_filename = '/Users/ldudte/Dropbox/DIS/Q3/data/pa12-15.csv'; % full

disp(road_quality_filename)

% read and process geom data
T = readtable(road_quality_filename);  
roads = arrayfun(@(x)convert_geom(x), T{:,'the_geom'}, 'UniformOutput', 0);   
PCI = T{:,'PCI'};

clear T

disp('loaded + processed road quality data')
toc




% -------------------------------------------------------------------------
% COLLISION DATA 2016
% -------------------------------------------------------------------------

tic

% https://data.lacity.org/A-Safe-City/LAPD-Crime-and-Collision-Raw-Data-for-2011/ftdn-8ftx
% https://data.lacity.org/A-Safe-City/LAPD-Crime-and-Collision-Raw-Data-for-2012/ftdn-8ftx
% https://data.lacity.org/A-Safe-City/LAPD-Crime-and-Collision-Raw-Data-for-2013/ftdn-8ftx
% https://data.lacity.org/A-Safe-City/LAPD-Crime-and-Collision-Raw-Data-for-2014/ftdn-8ftx
% https://data.lacity.org/A-Safe-City/LAPD-Crime-and-Collision-Raw-Data-for-2015/ftdn-8ftx
% https://data.lacity.org/A-Safe-City/LAPD-Crime-and-Collision-Raw-Data-for-2016/ftdn-8ftx

collision_filenames = {'/Users/ldudte/Dropbox/DIS/Q3/data/LAPD_Crime_and_Collision_Raw_Data_for_2011.csv' ...
                       '/Users/ldudte/Dropbox/DIS/Q3/data/LAPD_Crime_and_Collision_Raw_Data_for_2012.csv' ...
                       '/Users/ldudte/Dropbox/DIS/Q3/data/LAPD_Crime_and_Collision_Raw_Data_for_2013.csv' ...
                       '/Users/ldudte/Dropbox/DIS/Q3/data/LAPD_Crime_and_Collision_Raw_Data_for_2014.csv' ...
                       '/Users/ldudte/Dropbox/DIS/Q3/data/LAPD_Crime_and_Collision_Raw_Data_for_2015.csv' ...
                       '/Users/ldudte/Dropbox/DIS/Q3/data/LAPD_Crime_and_Collision_Raw_Data_for_2016.csv'};

num_collisions = [35629 36436 43575 46226 36321 26353]; % hard code sizes
collisions = zeros(sum(num_collisions), 2);

for i = 1:length(collision_filenames)

    tic    
    disp(collision_filenames{i})

    % read and process geom data
    T = readtable(collision_filenames{i});
    T(~arrayfun(@(x)strcmp(x,'TRAFFIC DR #'), T{:,'CrmCdDesc'}),:) = []; % filter collisions
    % get coordinates
    if i == 1
        these_collisions = fliplr(cell2mat(arrayfun(@(x)convert_location(x), T{:,'LOCATION'}, 'UniformOutput', 0))); 
    else
        these_collisions = fliplr(cell2mat(arrayfun(@(x)convert_location(x), T{:,'Location1'}, 'UniformOutput', 0)));
    end
    clearvars T   
    these_collisions((abs(sum(these_collisions,2)) < .00001),:) = []; % delete entries w no coordinates
    
    collisions(sum(num_collisions(1:i-1))+1:sum(num_collisions(1:i-1))+num_collisions(i),:) = these_collisions; 
    
    disp('loaded + processed collision data')   
    toc

end


clearvars -except collisions num_collisions roads PCI

























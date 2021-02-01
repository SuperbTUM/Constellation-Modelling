function [lat_fin, lon_fin, alt_fin] = concatenate(  )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
stkClose('all');
[lat_res, lon_res, alt_res] = Fetch_Position();
[lat_res2, lon_res2, alt_res2] = Fetch_Position2();
lat_fin = [lat_res, lat_res2];
lon_fin = [lon_res, lon_res2];
alt_fin = [alt_res, alt_res2];
% load('C:/Users/humingzhe/Desktop/position_data/lat.mat');
% lat1 = lat_res;
% load('C:/Users/humingzhe/Desktop/position_data/lat2.mat');
% lat2 = lat_res;
% lat_fin = [lat1, lat2];
% 
% load('C:/Users/humingzhe/Desktop/position_data/lon.mat');
% lon1 = lon_res;
% load('C:/Users/humingzhe/Desktop/position_data/lon2.mat');
% lon2 = lon_res;
% lon_fin = [lon1, lon2];
% 
% 
% load('C:/Users/humingzhe/Desktop/position_data/alt.mat');
% alt1 = alt_res;
% load('C:/Users/humingzhe/Desktop/position_data/alt2.mat');
% alt2 = alt_res;
% alt_fin = [alt1, alt2];

if(length(lat_fin) ~= length(lon_fin) || length(lon_fin) ~= length(alt_fin) || length(lat_fin) ~= length(alt_fin))
    disp('Wrong LLA dimension in preparation!');
    return;
end
save('C:/Users/humingzhe/Desktop/position_data/lat_fin_617.mat', 'lat_fin');
save('C:/Users/humingzhe/Desktop/position_data/lon_fin_617.mat', 'lon_fin');
save('C:/Users/humingzhe/Desktop/position_data/alt_fin_617.mat', 'alt_fin');

% all data is stored in rad 
end


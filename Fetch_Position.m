function [lat_res, lon_res, alt_res] = Fetch_Position(  )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
stkInit;
remMachine = stkDefaultHost;
delete(get(0,'children'));
conid = stkOpen(remMachine);
% dtr = pi / 180;
% rtd = 180 / pi;
% scen_open = stkValidScen;
% if(scen_open == 1)
%     rtn = questdlg('Close the current scenario?');
%     if(~strcmp(rtn, 'Yes'))
%         stkClose(conid);
%         return;
%     else
%         stkUnload('/*');
%     end
% end
%stkLoadObj('/', 'Scenario', 'Telesat_satellite');
%parent_path = 'C:/Users/humingzhe/Desktop/Telesat_satellite';
%stkSetCurrentDir(parent_path);
% objNames = stkObjNames; % NULL

%% initialization
lat_reg = ones(700,1);
lat_reg = lat_reg.*200;
lon_reg = ones(700,1);
lon_reg = lon_reg.*200;
alt_reg = ones(700,1);
alt_reg = alt_reg .* 200;

%% calculation
for idx = 101 :1: 612 % 510
    if(mod(idx,100) > 12) continue;
    end
    idx_str = num2str(idx);
    obj_path = '*/Satellite/Satellite';
    obj_path = strcat(obj_path, '1'); % satellite1
    obj_path = strcat(obj_path, '-0');
    
    obj_path = strcat(obj_path, idx_str);
%     file_name = strcat('1',idx_str);
%     file_path = strcat(' C:/Users/humingzhe/Desktop/position_data/', file_name);
%     file_path = strcat(file_path, '.txt');
%     command = 'ReportCreate */Satellite/Satellite1-0';
%     command = strcat(command, idx_str);
%     command = strcat(command, ' Type Save Style "LLA Position" File ');
%     command = strcat(command, file_path);
    % disp(command);
    try % stkExec(conid, command);
        [secData, secName] = stkReport(obj_path,'LLA Position'); % cell
        data = secData{1,:}; % struct: name, data, type
        lat_vec = data(2).data;
        lat = lat_vec(1);
        lat_reg(idx,1) = lat;
        lon_vec = data(3).data;
        lon = lon_vec(1);
        lon_reg(idx,1) = lon;
        alt_vec = data(4).data;
        alt = alt_vec(1);
        alt_reg(idx,1) = alt;
    catch
        continue;
    end
end

%% count
valid_reg = zeros(700,1);
for i = 1:length(lat_reg)
    if(lat_reg(i) ~= 200) 
        valid_reg(i) = 1;
    end
end
num = sum(valid_reg);
lat_res = zeros(num,1);
lon_res = zeros(num,1);
alt_res = zeros(num,1);
%% statistic
% stkExec(conid, 'ReportCreate */Satellite/Satellite1-0112 Type Save Style "LLA Position" File C:/Users/humingzhe/Desktop/position_data/0112.txt');
index = 1;
for i = 1:length(valid_reg)
    if(valid_reg(i) == 1) 
        lat_res(index) = lat_reg(i);
        lon_res(index) = lon_reg(i);
        alt_res(index) = alt_reg(i);
        index = index + 1;
    end
    
    %if(index > num) break;
    %end
    
end

lat_res = lat_res';
lon_res = lon_res';
alt_res = alt_res';

%% export
save('C:/Users/humingzhe/Desktop/position_data/lat.mat','lat_res');
save('C:/Users/humingzhe/Desktop/position_data/lon.mat','lon_res');
save('C:/Users/humingzhe/Desktop/position_data/alt.mat','alt_res');
%%
stkClose('all');
end


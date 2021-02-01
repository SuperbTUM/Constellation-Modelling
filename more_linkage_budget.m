function [  ] = more_linkage_budget(  )
%UNTITLED3 非静止地面站链路预算
stkInit;
remMachine = stkDefaultHost;
delete(get(0,'children'));
conid = stkOpen(remMachine);
%% Earth Station Mapping
% 调整地面站的名字（GroundVehicle, Aircraft, Ship, Missile）完成链路预算
idx = 1;
step = 1;
start_time = 0;
stop_time = 7200;
temp_cell = cell(1,1);
Earth_station_mapping = cell(122,round(stop_time-start_time)/step+1); % telesat leo中有122颗卫星
object = '*/GroundVehicle/GroundVehicle1';
sen_object = '/Sensor/Sensor7';
Rec_path = [object, '/Receiver/Receiver7'];
for i = 101:612
    t = 1;
    if(mod(i,100) > nPerPlan1 || mod(i,100) == 0) continue;
    end
    strSatellite = ['Satellite1-0' num2str(i)];
    cmd = ['Point ', object, sen_object, ' Targeted Tracking Satellite/', strSatellite];
    cmd = [cmd, ' Hold'];
    stkExec(conid, cmd);
    [secData, ~] = stkAccReport(['*/Satellite/', strSatellite, '/Transmitter/', 'Transmitter1-', num2str(idx)], Rec_path,'Link Budget - Detailed', start_time, stop_time, step);
    % 先封装temp_cell
    if(isempty(secData{1}))
        idx = idx + 1;
        continue;
    else
        a = secData{1};
        while(t <= length(a(1).data))
            
            b = temp_cell{1};
            for ii = 1:length(secData{1})
                b(ii).name = a(ii).name;
                b(ii).value = a(ii).data(t); % 时刻t
                b(ii).valuetype = a(ii).type;
            end
            temp_cell{1} = b;
            Earth_station_mapping{idx,floor(a(1).data(t)+1)} = b;
            t = t + 1;
        end
    end
        
        
    idx = idx + 1;
end


for j = 101:510
    if(mod(j,100) > nPerPlan2 || mod(j,100) == 0) continue;
    end
    strSatellite = ['Satellite2-0' num2str(j)];
    cmd = ['Point ', object, sen_object, ' Targeted Tracking Satellite/', strSatellite];
    cmd = [cmd, ' Hold'];
    stkExec(conid, cmd);
    [secData, ~] = stkAccReport(['*/Satellite/', strSatellite, '/Transmitter/', 'Transmitter2-', num2str(idx - 72)], Rec_path,'Link Budget - Detailed', start_time, stop_time, step);
    % 先封装temp_cell
    if(isempty(secData{1}))
        idx = idx + 1;
        continue;
    else
        a = secData{1};
        while(t <= length(a(1).data))
            
            b = temp_cell{1};
            for ii = 1:length(secData{1})
                b(ii).name = a(ii).name;
                b(ii).value = a(ii).data(t); % 时刻t
                b(ii).valuetype = a(ii).type;
            end
            temp_cell{1} = b;
            Earth_station_mapping{idx,floor(a(1).data(t)+1)} = b;
            t = t + 1;
        end
    end
    idx = idx + 1;
end
save('matrix1_groundvehicle.mat','Earth_station_mapping');

%% Satellite Mapping
idx = 1;
step = 1;
start_time = 0;
stop_time = 7200;
temp_cell = cell(1,1);
Satellite_mapping = cell(3,round(stop_time-start_time)/step+1); % 设置3个地面站
orbit = [1,2];
flag = orbit(1);
plan = [nPerPlan1, nPerPlan2];
sate_index = 101;
if(flag == 1)
    if(sate_index < 101 || sate_index > 612)
        disp('Invalid Satellite!');
        return;
    end
else
    if(sate_index < 101 || sate_index > 510)
        disp('Invalid Satellite!');
        return;
    end
end
object = ['*/Satellite/Satellite', num2str(flag),'-0',num2str(sate_index)];
tracking_object = ['Satellite/Satellite', num2str(flag),'-0',num2str(sate_index)];

for i = 3:5
    t = 1;
    sen_object = ['/Sensor/Sensor', num2str(i)];
    cmd = ['Point ', '*/Facility/Facility', num2str(i), sen_object, ' Targeted Tracking ', tracking_object];
    cmd = [cmd, ' Hold'];
    stkExec(conid, cmd);
    trx_code = (floor(sate_index / 100) - 1) * plan(flag) + mod(sate_index, 100);
    [secData, ~] = stkAccReport([object, '/Transmitter/Transmitter', num2str(flag), '-', num2str(trx_code)], ['*/Facility/Facility', num2str(i), '/Receiver/Receiver', num2str(i)],'Link Budget - Detailed', start_time, stop_time, step);
    % 先封装temp_cell
    if(isempty(secData{1}))
        idx = idx + 1;
        continue;
    else
        a = secData{1};
        while(t <= length(a(1).data))
            
            b = temp_cell{1};
            for ii = 1:length(secData{1})
                b(ii).name = a(ii).name;
                b(ii).value = a(ii).data(t); % 时刻t
                b(ii).valuetype = a(ii).type;
            end
            temp_cell{1} = b;
            Satellite_mapping{idx,floor(a(1).data(t)+1)} = b;
            t = t + 1;
        end
    end
        
        
    idx = idx + 1;
end

save('matrix2.mat','Satellite_mapping');

%% Time Mapping

idy = 1;
step = 1;
time_spot = 1800; % 时刻为time-spot
temp_cell = cell(1,1);
Time_mapping = cell(3,122); % 假设有3个地面站,122颗卫星

cnt = 1;
for i = 101:612 % 510
% satellite
    idx = 1;
    if(mod(i,100) > nPerPlan1 || mod(i,100) == 0) continue;
    end
    for s = 3:5

        pointing_object = ['*/Facility/Facility', num2str(s)];
        pointing = [pointing_object, '/Sensor/Sensor', num2str(s)];
        pointed_object = ['Satellite/Satellite1-0', num2str(i)];
        cmd = ['Point ', pointing, ' Targeted Tracking ', pointed_object];
        cmd = [cmd, ' Hold'];
        stkExec(conid, cmd);
        [secData, ~] = stkAccReport(['*/',pointed_object, '/Transmitter/Transmitter1-', num2str(cnt)], [pointing_object, '/Receiver/Receiver', num2str(s)],'Link Budget - Detailed', time_spot, time_spot, step);
        % 先封装temp_cell
        if(isempty(secData{1}))
            idx = idx + 1;
            continue;
        else
            a = secData{1};
            b = temp_cell{1};
            for ii = 1:length(secData{1})
                b(ii).name = a(ii).name;
                b(ii).value = a(ii).data;
                b(ii).valuetype = a(ii).type;
            end
            temp_cell{1} = b;
            Time_mapping{idx,idy} = b;
        end
        idx = idx + 1;
    end
    idy = idy + 1;
    cnt = cnt + 1;
end

cnt = 1;
for i = 101:510 % 612
% satellite
    idx = 1;
    if(mod(i,100) > nPerPlan2 || mod(i,100) == 0) continue;
    end
    for s = 3:5

        pointing_object = ['*/Facility/Facility', num2str(s)];
        pointing = [pointing_object, '/Sensor/Sensor', num2str(s)];
        pointed_object = ['Satellite/Satellite2-0', num2str(i)];
        cmd = ['Point ', pointing, ' Targeted Tracking ', pointed_object];
        cmd = [cmd, ' Hold'];
        stkExec(conid, cmd);
        [secData, ~] = stkAccReport(['*/',pointed_object, '/Transmitter/Transmitter2-', num2str(cnt)], [pointing_object, '/Receiver/Receiver', num2str(s)],'Link Budget - Detailed', time_spot, time_spot, step);
        % 先封装temp_cell
        if(isempty(secData{1}))
            idx = idx + 1;
            continue;
        else
            a = secData{1};
            b = temp_cell{1};
            for ii = 1:length(secData{1})
                b(ii).name = a(ii).name;
                b(ii).value = a(ii).data;
                b(ii).valuetype = a(ii).type;
            end
            temp_cell{1} = b;
            Time_mapping{idx,idy} = b;
        end
        idx = idx + 1;
    end
    idy = idy + 1;
    cnt = cnt + 1;
end
save('matrix3.mat', 'Time_mapping');

stkClose(conid);

end


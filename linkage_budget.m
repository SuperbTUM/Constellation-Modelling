function [ ] = linkage_budget(  )
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
stkInit;
remMachine = stkDefaultHost;
delete(get(0,'children'));
conid = stkOpen(remMachine);
pi = 3.1415927;
dtor = pi / 180;
scen_open = stkValidScen;
if(scen_open == 1)
    rtn = questdlg('Close Current Scenario?');
    if ~strcmp(rtn, 'Yes')
        stkClose(conid);
        return;
    else
        stkUnload('*/');
    end
end
%%
% 新建场景
disp('New SCENARIO generating...');
stkNewObj('/', 'Scenario', 'Telesat_constellation_test');
% 新建种子卫星
stkNewObj('*/','Satellite','Satellite1-0');
stkConnect(conid, 'SetMass', '*/Satellite/Satellite1-0', 'Value 386'); % 极地轨道卫星
stkExec(conid, 'SetState */Satellite/Satellite1-0 Classical J4Perturbation UseScenarioInterval 1 TrueOfDate "14 Aug 2020 04:00:00.00" 7371142 1.95298e-16 99.5 0 0 1.25968e-17');
stkNewObj('*/', 'Satellite', 'Satellite2-0');
stkConnect(conid, 'SetMass', '*/Satellite/Satellite2-0', 'Value 386'); % 斜轨道卫星
stkExec(conid, 'SetState */Satellite/Satellite2-0 Classical J4Perturbation UseScenarioInterval 1 TrueOfDate "14 Aug 2020 04:00:00.00" 7619142 2.00592e-16 37.4 0 0 2.04553e-17');
%%
% 在1号种子卫星上添加发射机，传感器，天线
disp('Seed Satellite Generating...');
strSensor = 'Sensor1-0';
stkNewObj('*/Satellite/Satellite1-0/', 'Sensor', strSensor);
strSetSensor = 'SimpleCone 58.69';
stkConnect(conid, 'Define', ['*/Satellite/Satellite1-0/Sensor/' strSensor], strSetSensor);
strAntenna = 'Antenna1-0';
stkNewObj(['*/Satellite/Satellite1-0/Sensor/' strSensor],'Antenna', strAntenna);
% stkConnect(conid, 'Antenna_RM', ['*/Satellite/Satellite1-0/Sensor/' strSensor '/Antenna/' strAntenna], 'GetValue');
sat1_antenna = ['*/Satellite/Satellite1-0/Sensor/' strSensor '/Antenna/' strAntenna];                             
stkConnect(conid, 'Antenna', sat1_antenna, 'SetValue Model ITU-R_S1528_1.2_Circular');
stkConnect(conid, 'Antenna', sat1_antenna, 'SetValue Model.DesignFrequency 20 GHz');
stkConnect(conid, 'Antenna', sat1_antenna, 'SetValue Model.MainLobeGain 50 dB');
stkConnect(conid, 'Antenna', sat1_antenna, 'SetValue Model.Efficiency 1 unitValue');
stkConnect(conid, 'Antenna', sat1_antenna, 'SetValue Model.Diameter 0.8 m');
stkConnect(conid, 'Antenna', sat1_antenna, 'SetValue Model.NearinSidelobeLevel -15 dB');


strTransmitter = 'Transmitter1-0';
stkNewObj('*/Satellite/Satellite1-0/','Transmitter',strTransmitter);
sat1_trx = ['*/Satellite/Satellite1-0/Transmitter/' strTransmitter];
stkConnect(conid, 'Transmitter', sat1_trx, 'SetValue Model Complex_Transmitter_Model');
% stkConnect(conid, 'Transmitter_RM', ['*/Satellite/Satellite1-0/Transmitter/' strTransmitter], 'GetValue');

stkConnect(conid, 'Transmitter', sat1_trx, 'SetValue Model.AntennaControl.AntennaReferenceType Link');
stkConnect(conid, 'Transmitter', sat1_trx, 'SetValue Model.AntennaControl.UsePolarization true');
stkConnect(conid, 'Transmitter', sat1_trx, 'SetValue Model.AntennaControl.Polarization Right-hand Circular');
stkConnect(conid, 'Transmitter', sat1_trx, 'SetValue Model.Power 30 dBW');
stkConnect(conid, 'Transmitter', sat1_trx, 'SetValue Model.Frequency 20 GHz');
stkConnect(conid, 'Transmitter', sat1_trx, 'SetValue Model.DataRate 558.7 Mb*sec^-1');
stkConnect(conid, 'Transmitter', sat1_trx, 'SetValue Model.Modulator 8PSK');


%%
% 在2号种子卫星上添加发射机，传感器，天线
strSensor = 'Sensor2-0';
stkNewObj('*/Satellite/Satellite2-0/', 'Sensor', strSensor);
strSetSensor = 'SimpleCone 53'; % 半锥角为53°
stkConnect(conid, 'Define', ['*/Satellite/Satellite2-0/Sensor/' strSensor], strSetSensor);
strAntenna = 'Antenna2-0';
sat2_antenna = ['*/Satellite/Satellite2-0/Sensor/' strSensor '/Antenna/' strAntenna];
stkNewObj(['*/Satellite/Satellite2-0/Sensor/' strSensor],'Antenna', strAntenna);

% stkConnect(conid, 'Antenna_RM', ['*/Satellite/Satellite1-0/Sensor/' strSensor '/Antenna/' strAntenna], 'GetValue');
                      
stkConnect(conid, 'Antenna', sat2_antenna, 'SetValue Model ITU-R_S1528_1.2_Circular');
stkConnect(conid, 'Antenna', sat2_antenna, 'SetValue Model.DesignFrequency 20 GHz');
stkConnect(conid, 'Antenna', sat2_antenna, 'SetValue Model.MainLobeGain 50 dB');
stkConnect(conid, 'Antenna', sat2_antenna, 'SetValue Model.Efficiency 1 unitValue');
stkConnect(conid, 'Antenna', sat2_antenna, 'SetValue Model.Diameter 0.8 m');
stkConnect(conid, 'Antenna', sat2_antenna, 'SetValue Model.NearinSidelobeLevel -15 dB');


strTransmitter = 'Transmitter2-0';
stkNewObj('*/Satellite/Satellite2-0/','Transmitter',strTransmitter);
sat2_trx = ['*/Satellite/Satellite2-0/Transmitter/' strTransmitter];
stkConnect(conid, 'Transmitter', sat2_trx, 'SetValue Model Complex_Transmitter_Model');
% stkConnect(conid, 'Transmitter_RM', ['*/Satellite/Satellite1-0/Transmitter/' strTransmitter], 'GetValue');

stkConnect(conid, 'Transmitter', sat2_trx, 'SetValue Model.AntennaControl.AntennaReferenceType Link');
stkConnect(conid, 'Transmitter', sat2_trx, 'SetValue Model.AntennaControl.UsePolarization true');
stkConnect(conid, 'Transmitter', sat2_trx, 'SetValue Model.AntennaControl.Polarization Right-hand Circular');
stkConnect(conid, 'Transmitter', sat2_trx, 'SetValue Model.Power 29 dBW');
stkConnect(conid, 'Transmitter', sat2_trx, 'SetValue Model.Frequency 20 GHz');
stkConnect(conid, 'Transmitter', sat2_trx, 'SetValue Model.DataRate 558.7 Mb*sec^-1');
stkConnect(conid, 'Transmitter', sat2_trx, 'SetValue Model.Modulator 8PSK');

%%
% 新建地面站
disp('Earth Station Generating...');
stkNewObj('*/','Facility', 'GatewayStation');
% 地面站传感器的设置
stkNewObj('*/Facility/GatewayStation', 'Sensor', 'Sensor1');
SetSensor = 'SimpleCone 1';
stkConnect(conid, 'Define', '*/Facility/GatewayStation/Sensor/Sensor1', SetSensor);
stkExec(conid, 'Point */Facility/GatewayStation/Sensor/Sensor1 Targeted Tracking Satellite/Satellite1-0 Hold');
stkExec(conid, 'SetConstraint */Facility/GatewayStation/Sensor/Sensor1 ElevationAngle Min 20');
% 地面站天线的设置
stkNewObj('*/Facility/GatewayStation/Sensor/Sensor1', 'Antenna', 'Antenna1');
earth_station_antenna = '*/Facility/GatewayStation/Sensor/Sensor1/Antenna/Antenna1';
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model ITU-R_S465-5');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.DesignFrequency 20 GHz');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.MainLobeGain 43.5 dB');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Efficiency 0.7 unitValue');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Diameter 1 m');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.SideLobeMaskLevel 10 dB');

% 接收机的设置
rec = 'Receiver1';
stkNewObj('*/Facility/GatewayStation/', 'Receiver', rec);
stkConnect(conid, 'Receiver', ['*/Facility/GatewayStation/Receiver/' rec], 'SetValue Model Complex_Receiver_Model');
obj = ['*/Facility/GatewayStation/Receiver/' rec];
% stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.GoverT 9.5499 units*K^-1'); % simple
% stkConnect(conid, 'Receiver_RM', ['*/Facility/GatewayStation/Receiver/' rec], 'GetValue');
% stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.LNAGain 0 dB');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.Orientation.ZPositionOffset 1.5 m');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.AntennaReferenceType Link');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.EnableLinkMargin true');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ComputeSystemNoiseTemp Compute');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ANT2LNALineTemperature 285.3 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNA2RcvrLineTemperature 285.3 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNATemperature 285.3 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaNoise.ConstantNoiseTemp 285.3 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LinkMarginThreshold 0.85 dB');
%stkConnect(conid, 'Receiver', obj, 'SetValue Model.PreReceiveGainsLosses.GainLossList[0].Identifier Atmosphere_Loss');
%stkConnect(conid, 'Receiver', obj, 'SetValue Model.PreReceiveGainsLosses.GainLossList[0].Gain -2 dB');

% 建立用户终端
strFacility = 'UserTerminal';
stkNewObj('*/','Facility',strFacility);
stkConnect(conid, 'SetPosition', ['*/Facility/', strFacility], 'Geodetic 43 79 70'); % altitude in meters
stkNewObj('*/Facility/UserTerminal/', 'Sensor', 'Sensor2');
SetSensor = 'SimpleCone 1';
stkConnect(conid, 'Define', '*/Facility/UserTerminal/Sensor/Sensor2', SetSensor);
% 地面站天线的设置
stkNewObj('*/Facility/UserTerminal/Sensor/Sensor2', 'Antenna', 'Antenna2');
earth_station_antenna = '*/Facility/UserTerminal/Sensor/Sensor2/Antenna/Antenna2';
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model Isotropic');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.DesignFrequency 20 GHz');
rec = 'Receiver2';
stkNewObj('*/Facility/UserTerminal/', 'Receiver', rec);
stkConnect(conid, 'Receiver', ['*/Facility/UserTerminal/Receiver/' rec], 'SetValue Model Complex_Receiver_Model');
obj = ['*/Facility/UserTerminal/Receiver/' rec];
% stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.GoverT 9.5499 units*K^-1'); % simple
% stkConnect(conid, 'Receiver_RM', ['*/Facility/GatewayStation/Receiver/' rec], 'GetValue');
% stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.LNAGain 0 dB');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.Orientation.ZPositionOffset 1.5 m');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.AntennaReferenceType Link');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.EnableLinkMargin true');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ComputeSystemNoiseTemp Compute');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ANT2LNALineTemperature 285.3 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNA2RcvrLineTemperature 285.3 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNATemperature 285.3 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaNoise.ConstantNoiseTemp 285.3 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LinkMarginThreshold 0.85 dB');

for ii = 3:5
    stkNewObj('*/','Facility', ['Facility',num2str(ii)]);
    % 地面站传感器的设置
    stkNewObj(['*/Facility/Facility', num2str(ii)], 'Sensor', ['Sensor',num2str(ii)]);
    SetSensor = 'SimpleCone 1';
    stkConnect(conid, 'Define', ['*/Facility/Facility', num2str(ii), '/Sensor/Sensor', num2str(ii)], SetSensor);
    stkExec(conid, ['Point */Facility/Facility', num2str(ii), '/Sensor/Sensor', num2str(ii), ' Targeted Tracking Satellite/Satellite1-0 Hold']);
    stkExec(conid, ['SetConstraint */Facility/Facility', num2str(ii), '/Sensor/Sensor', num2str(ii), ' ElevationAngle Min 20']);
    % 地面站天线的设置
    stkNewObj(['*/Facility/Facility', num2str(ii), '/Sensor/Sensor', num2str(ii)], 'Antenna', ['Antenna', num2str(ii)]);
    earth_station_antenna = ['*/Facility/Facility', num2str(ii), '/Sensor/Sensor', num2str(ii), '/Antenna/Antenna', num2str(ii)];
    stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model ITU-R_S465-5');
    stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.DesignFrequency 20 GHz');
    stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.MainLobeGain 43.5 dB');
    stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Efficiency 0.7 unitValue');
    stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Diameter 1 m');
    stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.SideLobeMaskLevel 10 dB');

    % 接收机的设置
    rec = ['Receiver', num2str(ii)];
    stkNewObj(['*/Facility/Facility', num2str(ii), '/'], 'Receiver', rec);
    stkConnect(conid, 'Receiver', ['*/Facility/Facility', num2str(ii), '/Receiver/' rec], 'SetValue Model Complex_Receiver_Model');
    obj = ['*/Facility/Facility', num2str(ii), '/Receiver/', rec];
    % stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.GoverT 9.5499 units*K^-1'); % simple
    % stkConnect(conid, 'Receiver_RM', ['*/Facility/GatewayStation/Receiver/' rec], 'GetValue');
    % stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.LNAGain 0 dB');
    stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.Orientation.ZPositionOffset 1.5 m');
    stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.AntennaReferenceType Link');
    stkConnect(conid, 'Receiver', obj, 'SetValue Model.EnableLinkMargin true');
    stkConnect(conid, 'Receiver', obj, 'SetValue Model.ComputeSystemNoiseTemp Compute');
    stkConnect(conid, 'Receiver', obj, 'SetValue Model.ANT2LNALineTemperature 285.3 K');
    stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNA2RcvrLineTemperature 285.3 K');
    stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNATemperature 285.3 K');
    stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaNoise.ConstantNoiseTemp 285.3 K');
    stkConnect(conid, 'Receiver', obj, 'SetValue Model.LinkMarginThreshold 0.85 dB');
    %stkConnect(conid, 'Receiver', obj, 'SetValue Model.PreReceiveGainsLosses.GainLossList[0].Identifier = Atmosphere Loss');
    %stkConnect(conid, 'Receiver', obj, 'SetValue Model.PreReceiveGainsLosses.GainLossList[0].Gain -2 dB');
end



%%
% 多地面站设置（飞机，轮船，汽车，火箭）
stkNewObj('*/','Aircraft', 'Aircraft1');
stkExec(conid, 'SetPropagator */Aircraft/Aircraft1 GreatArc');
% stkExec(conid, 'SetGreatArcStart */Aircraft/Aircraft1 UseAnalysisStartTime');
stkSetWaypoints('*/Aircraft/Aircraft1', 'UseAnalysisStartTime', [31.14 * dtor, 50.049 * dtor; 118.22 * dtor, 8.5757 * dtor; 10668,10668], [208;208]);

% 地面站传感器的设置
stkNewObj('*/Aircraft/Aircraft1', 'Sensor', 'Sensor9');
SetSensor = 'SimpleCone 1';
stkConnect(conid, 'Define', '*/Aircraft/Aircraft1/Sensor/Sensor9', SetSensor);
stkExec(conid, 'Point */Aircraft/Aircraft1/Sensor/Sensor9 Targeted Tracking Satellite/Satellite1-0 Hold');
stkExec(conid, 'SetConstraint */Aircraft/Aircraft1/Sensor/Sensor9 ElevationAngle Min 20');
% 地面站天线的设置
stkNewObj('*/Aircraft/Aircraft1/Sensor/Sensor9', 'Antenna', 'Antenna9');
earth_station_antenna = '*/Aircraft/Aircraft1/Sensor/Sensor9/Antenna/Antenna9';
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model ITU-R_S465-5');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.DesignFrequency 20 GHz');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.MainLobeGain 32 dB');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Efficiency 1 unitValue');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Diameter 1 m');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.SideLobeMaskLevel 10 dB');
% 接收机的设置
rec = 'Receiver9';
stkNewObj('*/Aircraft/Aircraft1/', 'Receiver', rec);
stkConnect(conid, 'Receiver', ['*/Aircraft/Aircraft1/Receiver/' rec], 'SetValue Model Complex_Receiver_Model');
obj = ['*/Aircraft/Aircraft1/Receiver/' rec];
% stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.GoverT 9.5499 units*K^-1'); % simple
% stkConnect(conid, 'Receiver_RM', ['*/Facility/GatewayStation/Receiver/' rec], 'GetValue');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.AntennaReferenceType Link');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.EnableLinkMargin true');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ComputeSystemNoiseTemp Compute');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ANT2LNALineTemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNA2RcvrLineTemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNATemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaNoise.ConstantNoiseTemp 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LinkMarginThreshold 0.85 dB');

%%
stkNewObj('*/','GroundVehicle', 'GroundVehicle1');
stkExec(conid, 'SetPropagator */GroundVehicle/GroundVehicle1 GreatArc');
% stkExec(conid, 'SetGreatArcStart */GoundVehicle/GroundVehicle1 UseAnalysisStartTime');
stkSetWaypoints('*/GroundVehicle/GroundVehicle1', 'UseAnalysisStartTime', [39.26 * dtor, 31.14 * dtor; 116 * dtor, 118.22 * dtor; 0,0], [16.16;16.16]);

% 地面站传感器的设置
stkNewObj('*/GroundVehicle/GroundVehicle1', 'Sensor', 'Sensor7');
SetSensor = 'SimpleCone 1';
stkConnect(conid, 'Define', '*/GroundVehicle/GroundVehicle1/Sensor/Sensor7', SetSensor);
stkExec(conid, 'Point */GroundVehicle/GroundVehicle1/Sensor/Sensor7 Targeted Tracking Satellite/Satellite1-0 Hold');
stkExec(conid, 'SetConstraint */GroundVehicle/GroundVehicle1/Sensor/Sensor7 ElevationAngle Min 20');
% 地面站天线的设置
stkNewObj('*/GroundVehicle/GroundVehicle1/Sensor/Sensor7', 'Antenna', 'Antenna7');
earth_station_antenna = '*/GroundVehicle/GroundVehicle1/Sensor/Sensor7/Antenna/Antenna7';
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model ITU-R_S465-5');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.DesignFrequency 20 GHz');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.MainLobeGain 32 dB');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Efficiency 1 unitValue');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Diameter 1 m');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.SideLobeMaskLevel 10 dB');
% 接收机的设置
rec = 'Receiver7';
stkNewObj('*/GroundVehicle/GroundVehicle1/', 'Receiver', rec);
stkConnect(conid, 'Receiver', ['*/GroundVehicle/GroundVehicle1/Receiver/' rec], 'SetValue Model Complex_Receiver_Model');
obj = ['*/GroundVehicle/GroundVehicle1/Receiver/' rec];
% stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.GoverT 9.5499 units*K^-1'); % simple
% stkConnect(conid, 'Receiver_RM', ['*/Facility/GatewayStation/Receiver/' rec], 'GetValue');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.AntennaReferenceType Link');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.EnableLinkMargin true');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ComputeSystemNoiseTemp Compute');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ANT2LNALineTemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNA2RcvrLineTemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNATemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaNoise.ConstantNoiseTemp 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LinkMarginThreshold 0.85 dB');
%%
stkNewObj('*/', 'Ship', 'Ship1');
stkExec(conid, 'SetPropagator */Ship/Ship1 GreatArc');
% stkExec(conid, 'SetGreatArcStart */Ship/Ship1 UseAnalysisStartTime');
stkSetWaypoints('*/Ship/Ship1', 'UseAnalysisStartTime', [30.5 * dtor, 15 * dtor; 121 * dtor, 121 * dtor; 0,0], [8.08;8.08]);

% 地面站传感器的设置
stkNewObj('*/Ship/Ship1', 'Sensor', 'Sensor6');
SetSensor = 'SimpleCone 1';
stkConnect(conid, 'Define', '*/Ship/Ship1/Sensor/Sensor6', SetSensor);
stkExec(conid, 'Point */Ship/Ship1/Sensor/Sensor6 Targeted Tracking Satellite/Satellite1-0 Hold');
stkExec(conid, 'SetConstraint */Ship/Ship1/Sensor/Sensor6 ElevationAngle Min 20');
% 地面站天线的设置
stkNewObj('*/Ship/Ship1/Sensor/Sensor6', 'Antenna', 'Antenna6');
earth_station_antenna = '*/Ship/Ship1/Sensor/Sensor6/Antenna/Antenna6';
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model ITU-R_S465-5');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.DesignFrequency 20 GHz');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.MainLobeGain 32 dB');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Efficiency 1 unitValue');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Diameter 1 m');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.SideLobeMaskLevel 10 dB');
% 接收机的设置
rec = 'Receiver6';
stkNewObj('*/Ship/Ship1/', 'Receiver', rec);
stkConnect(conid, 'Receiver', ['*/Ship/Ship1/Receiver/' rec], 'SetValue Model Complex_Receiver_Model');
obj = ['*/Ship/Ship1/Receiver/' rec];
% stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.GoverT 9.5499 units*K^-1'); % simple
% stkConnect(conid, 'Receiver_RM', ['*/Facility/GatewayStation/Receiver/' rec], 'GetValue');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.AntennaReferenceType Link');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.EnableLinkMargin true');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ComputeSystemNoiseTemp Compute');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ANT2LNALineTemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNA2RcvrLineTemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNATemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaNoise.ConstantNoiseTemp 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LinkMarginThreshold 0.85 dB');
%%
stkNewObj('*/','Missile','Missile1');
stkExec(conid, 'SetUnits / km');
stkExec(conid, 'SetState */Missile/Missile1 Classical TwoBody "3 Sep 2020 04:00:00.00" "3 Sep 2020 16:00:00.00" 1 TrueOfDate "3 Sep 2020 04:00:00.00" 4528.24 0.8931 37.729 196.86 70.26 70.05');
% 地面站传感器的设置
stkNewObj('*/Missile/Missile1', 'Sensor', 'Sensor8');
SetSensor = 'SimpleCone 1';
stkConnect(conid, 'Define', '*/Missile/Missile1/Sensor/Sensor8', SetSensor);
stkExec(conid, 'Point */Missile/Missile1/Sensor/Sensor8 Targeted Tracking Satellite/Satellite1-0 Hold');
stkExec(conid, 'SetConstraint */Missile/Missile1/Sensor/Sensor8 ElevationAngle Min 20');
% 地面站天线的设置
stkNewObj('*/Missile/Missile1/Sensor/Sensor8', 'Antenna', 'Antenna8');
earth_station_antenna = '*/Missile/Missile1/Sensor/Sensor8/Antenna/Antenna8';
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model ITU-R_S465-5');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.DesignFrequency 20 GHz');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.MainLobeGain 32 dB');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Efficiency 1 unitValue');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.Diameter 1 m');
stkConnect(conid, 'Antenna', earth_station_antenna, 'SetValue Model.SideLobeMaskLevel 10 dB');
rec = 'Receiver8';
stkNewObj('*/Missile/Missile1/', 'Receiver', rec);
stkConnect(conid, 'Receiver', ['*/Missile/Missile1/Receiver/' rec], 'SetValue Model Complex_Receiver_Model');
obj = ['*/Missile/Missile1/Receiver/' rec];
% stkConnect(conid, 'Receiver', ['*/Facility/Facility1/Receiver/' rec], 'SetValue Model.GoverT 9.5499 units*K^-1'); % simple
% stkConnect(conid, 'Receiver_RM', ['*/Facility/GatewayStation/Receiver/' rec], 'GetValue');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaControl.AntennaReferenceType Link');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.EnableLinkMargin true');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ComputeSystemNoiseTemp Compute');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.ANT2LNALineTemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNA2RcvrLineTemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LNATemperature 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.AntennaNoise.ConstantNoiseTemp 290 K');
stkConnect(conid, 'Receiver', obj, 'SetValue Model.LinkMarginThreshold 0.85 dB');

%%
disp('Constellation Genarating...');
nplan1 = 6;
nPerPlan1 = 12;
nRAANSpreed1 = pi / 6; % 相邻平面卫星相位差 30度

nplan2 = 5;
nPerPlan2 = 10;
nRAANSpreed2 = pi / 5;

stkExec(conid, 'Walker */Satellite/Satellite1-0 Type Star NumPlanes 6 NumSatsPerPlane 12 InterPlanePhaseIncrement 3 ColorByPlane Yes SetUniqueNames Yes'); % 平面间True Anomaly差为15°
stkExec(conid, 'Walker */Satellite/Satellite2-0 Type Delta NumPlanes 5 NumSatsPerPlane 10 InterPlanePhaseIncrement 2 ColorByPlane Yes SetUniqueNames Yes'); % 使用了刘博的设计
disp('Done!');
%% Earth Station Mapping
% stkAccess2obj('*/Satellite/Satellite1-0101/Transmitter/Transmitter1-1','*/Facility/GatewayStation/Receiver/Receiver1');
%stkExec(conid, 'Access */Satellite/Satellite1-0101/Transmitter/Transmitter1-1 */Facility/GatewayStation/Receiver/Receiver1 TimePeriod UseScenarioInterval');
disp('Link Budget Calculating...');
idx = 1;
step = 1;
start_time = 0;
stop_time = 7200;
temp_cell = cell(1,1);
Earth_station_mapping = cell(122,round(stop_time-start_time)/step+1); % telesat leo中有122颗卫星
object = '*/Facility/GatewayStation';
sen_object = '/Sensor/Sensor1';
for i = 101:612
    t = 1;
    if(mod(i,100) > nPerPlan1 || mod(i,100) == 0) continue;
    end
    strSatellite = ['Satellite1-0' num2str(i)];
    cmd = ['Point ', object, sen_object, ' Targeted Tracking Satellite/', strSatellite];
    cmd = [cmd, ' Hold'];
    stkExec(conid, cmd);
    [secData, ~] = stkAccReport(['*/Satellite/', strSatellite, '/Transmitter/', 'Transmitter1-', num2str(idx)], '*/Facility/GatewayStation/Receiver/Receiver1','Link Budget - Detailed', start_time, stop_time, step);
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
    [secData, ~] = stkAccReport(['*/Satellite/', strSatellite, '/Transmitter/', 'Transmitter2-', num2str(idx - 72)], '*/Facility/GatewayStation/Receiver/Receiver1','Link Budget - Detailed', start_time, stop_time, step);
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
save('matrix1_test.mat','Earth_station_mapping');

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

save('matrix2_test.mat','Satellite_mapping');

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
save('matrix3_test.mat', 'Time_mapping');

stkClose(conid);
disp('Everything done!');
end


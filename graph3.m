function [] = graph3()
%UNTITLED 姝ゅ鏄剧ず鏈夊叧姝ゅ嚱鏁扮殑鎽樿
coverage_radial = [58.69, 53];
R = 6371142; % in meters
% c = 299792458;
% f = 20000000000;
dtor = pi / 180;
% lamba = c / f;
%%
Gmax = 52;    %dBi
Ln = -15;   %dB
Lf = 0;     %dBi
Lb = 0;     %dBi
a = 2.58;
b = 6.32;
D = 0.8;
c = 2.9979*10^8;
f = 19.75*10^9;
lambda = c/f;
Faib = sqrt(1200)/(D/lambda);
Faib = 58.69;
alpha = 1.5;
i = 1;
X = Gmax + Ln + 25 * log10(b*Faib);
Y = b*Faib*10^(0.04*(Gmax + Ln - Lf));

% sigma = 1.1692;
% Gain = zeros(60,1);
% j = 1;
% for theta = 0:0.5:coverage
% u = u_function(theta, coverage);
% J1 = besselj(1, u);
% equa = 1;
% for i = 1:3
%     semi_equa1 = 1 - u^2 / (pi^2 * sigma^2 * (A^2 + (i - 1/2)^2));
%     semi_equa2 = 1 - (u / (pi * miu(i)))^2;
%     equa = equa * semi_equa1 / semi_equa2;
% end
%     G = Gmax - 20 * log10(abs(2 * J1 / u * equa)); % G(theta)
%     if(j == 1) 
%         Gain(j) = Gmax;
%     else
%         Gain(j) = G;
%     end
%     j = j + 1;
% end
interval = 0.1;
lat_range = -90:interval:90;
lon_range = -180:interval:180;
% altitude = 1000000;
% [lat_sat, lon_sat, alt_sat] = concatenate(); % lat_sat & lon_sat are stored in rad; alt_sat are stored in meters
lat_sat = load('C:/Users/humingzhe/Desktop/position_data/lat_fin.mat');
lat_sat = lat_sat.lat_fin;
lon_sat = load('C:/Users/humingzhe/Desktop/position_data/lon_fin.mat');
lon_sat = lon_sat.lon_fin;
alt_sat = load('C:/Users/humingzhe/Desktop/position_data/alt_fin.mat');
alt_sat = alt_sat.alt_fin;

% lat_sat = load('C:/Users/humingzhe/Desktop/position_data/lat.mat');
% lat_sat = lat_sat.lat_res;
% lon_sat = load('C:/Users/humingzhe/Desktop/position_data/lon.mat');
% lon_sat = lon_sat.lon_res;
% alt_sat = load('C:/Users/humingzhe/Desktop/position_data/alt.mat');
% alt_sat = alt_sat.alt_res;

% alt_sat = load('C:/Users/Superb/Desktop/NXCI/position_data/alt_info.txt')';
h = alt_sat ./ 1000;

Lr_correction = zeros(1,length(alt_sat));
Lt_correction = zeros(1,length(alt_sat));
gamma = zeros(1,length(alt_sat));

for i = 1:length(alt_sat)
    if(i > 72)
        coverage = coverage_radial(2);
    else
        coverage = coverage_radial(1);
    end
    delta = cot(coverage * dtor)^2 * R^2 - (alt_sat(i)^2 + 2 * alt_sat(i)* R);
    if(delta < 0)
        % 相切
        cos_gamma = R / (alt_sat(i) + R);
        sin_gamma = sqrt(1 - cos_gamma^2);
    else
        x1 = (cot(coverage * dtor) * (alt_sat(i) + R) - sqrt(delta));
        x1 = abs(x1 / (1 + cot(coverage)^2));
        sin_gamma = x1 / R;
    end
    
    if(~isreal(sin_gamma) || sin_gamma < 0)
        disp('Warning! Invalid gamma!');
    end
    % cos_gamma = sqrt(1 - sin_gamma^2);
    gamma(i) = asin(sin_gamma);
    Lr_correction(i) = abs(R * gamma(i)); % in meters
    Lt_correction(i) = abs(R * gamma(i));
end

% lat_sat = load('C:/Users/Superb/Desktop/NXCI/position_data/lat_info.txt')';
% lon_sat = load('C:/Users/Superb/Desktop/NXCI/position_data/lon_info.txt')';
lat_sat = lat_sat ./ dtor;
lon_sat = lon_sat ./ dtor;

% lat_sat = [0, 29.69, 58.813, 80.554, 58.813, 80.554, 58.813, 29.69,0,-29.69,-58.813,-80.554];
% lon_sat = [72.57, 67.127, 56.616, -17.430, -91.476, -101.987, -107.43, -112.873, -123.384, 162.570];


% lat_range_correction = (lat_sat - gamma / dtor):0.1:(gamma / dtor + lat_sat);
% lon_range_correction = sqrt((gamma / dtor)^2 - lat_range_correction.^2);
% lon_range_correction = (lon_sat - gamma / dtor):0.1:(gamma / dtor + lon_sat);




%% 
Gain_3D = zeros(length(lat_range), length(lon_range));
Gain_3D_whole = zeros(length(lat_range), length(lon_range));
array = [];
for idx_location = 1:length(lat_sat)

    % Gain_3D_whole = Gain_3D;
    % whether correction operation is needed
     if(abs(90 - lat_sat(idx_location)) < gamma(idx_location) / dtor && lat_sat(idx_location) > 0) % latitude needs supplement
         disp('Special operation needed! Altitude reaches maximum limit!');
         array(idx_location) = 1;
%         temp_sat_lat = (180 - lat_sat(idx_location));
%         lat_sat = [lat_sat, temp_sat_lat];
     elseif(abs(- 90 - lat_sat(idx_location)) < gamma(idx_location) / dtor && lat_sat(idx_location) < 0)
         disp('Special operation needed! Altitude reaches minimum limit!');
         array(idx_location) = -1;
%         temp_sat_lat = -(180 - abs(lat_sat(idx_location)));
%         lat_sat = [lat_sat, temp_sat_lat];
     end
    
    if(abs(180 - lon_sat(idx_location)) < gamma(idx_location) / dtor && lon_sat(idx_location) > 0) % longtitude needs supplement
        temp_sat_lon = -(360 - lon_sat(idx_location));
        lon_sat = [lon_sat, temp_sat_lon];
    elseif(abs(- 180 - lon_sat(idx_location)) < gamma(idx_location) / dtor && lon_sat(idx_location) < 0)
        temp_sat_lon = 360 + lon_sat(idx_location);
        lon_sat = [lon_sat, temp_sat_lon];
    end
    % 琛ラ綈
    if(length(lat_sat) ~= length(alt_sat) || length(lon_sat) ~= length(alt_sat))
        alt_sat = [alt_sat, alt_sat(idx_location)];
        h = [h, h(idx_location)];
        gamma = [gamma, gamma(idx_location)];
        Lr_correction = [Lr_correction, Lr_correction(idx_location)];
        Lt_correction = [Lt_correction, Lt_correction(idx_location)];
    end
    
    % check component number
    if(length(lat_sat) < length(lon_sat))
        lat_sat = [lat_sat, lat_sat(idx_location)];
    elseif(length(lat_sat) > length(lon_sat))
        lon_sat = [lon_sat, lon_sat(idx_location)];
    end
end

diff = length(lat_sat) - length(array);
array = [array, zeros(1,diff)];

%% check
if(length(lat_sat) ~= length(alt_sat) || length(lon_sat)~= length(alt_sat) || length(lon_sat) ~= length(lat_sat))
    disp('Wrong LLA dimension match!');
    return;
elseif(length(gamma) ~= length(lat_sat))
    disp('Wrong parameter dimension!');
    return;
elseif(length(lat_sat) ~= length(array))
    disp('Wrong array size!');
    return;
else
    disp('Params match completed!');
end

%% calculate (Normal Procedure)
c = 0;
for idx_location = 1:length(lat_sat)
    disp('In Progress!');
    disp(c);
    c = c + 1;
    p = 1;
    % Gain_3D = zeros(length(lat_range), length(lon_range));    
    for idx_lat = lat_range
       j = 1;
       for idx_lon = lon_range
            % dist = R * acos(cos(lat_sat(idx_location) * dtor) * cos(idx_lat * dtor) * cos((lon_sat(idx_location) - idx_lon) * dtor) + sin(lat_sat(idx_location) * dtor) * sin(idx_lat * dtor));
            % dist_ref = Lr_correction(idx_location);
    %for idx_x = -200:200
       %if(idx_lat < lat_sat + 45 && idx_lat > lat_sat - 45 && idx_lon < lon_sat + 90 && idx_lon > lon_sat - 90)
    %    for idx_y = -200:200
            theta_now = acos(cos(lat_sat(idx_location) * dtor) * cos(idx_lat * dtor) * cos((lon_sat(idx_location) - idx_lon) * dtor) + sin(lat_sat(idx_location) * dtor) * sin(idx_lat * dtor));
            if(theta_now <= gamma(idx_location))
            % theta_now = dist / R;
                % theta_now = acos(cos(lat_sat(idx_location) * dtor) * cos(idx_lat * dtor) * cos((lon_sat(idx_location) - idx_lon) * dtor) + sin(lat_sat(idx_location) * dtor) * sin(idx_lat * dtor));
                Fai =  atan((R * sin(theta_now)) / (alt_sat(idx_location) + R - R * cos(theta_now))) / dtor;

                if (0 <= Fai) && (Fai<= a * Faib)
                    Gseita_db = Gmax - 3 * (Fai / Faib)^alpha;

                elseif (a * Faib < Fai) && (Fai <= b * Faib)
                    Gseita_db  = Gmax + Ln;

                elseif (b * Faib < Fai ) && (Fai<= Y)
                    Gseita_db  = X  - 25 * log10(Fai);   
                else
                    Gseita_db  = 0;

                end



    %                 u = u_function_xy(lat_sat(idx_location), lon_sat(idx_location), idx_lat, idx_lon, coverage_radial, coverage_transverse, idx_location);
    %                 J1 = besselj(1, u);
    %                 equa = 1;
    %                 for i = 1:3
    %                     A = 1 / pi * acos(h(idx_location) * 10^(SLR / 20));
    %                     sigma = J0 / sqrt(A^2 + (l0-1/2)^2);
    %                     semi_equa1 = 1 - u^2 / (pi^2 * sigma^2 * (A^2 + (i - 1/2)^2));
    %                     semi_equa2 = 1 - (u / (pi * miu(i)))^2;
    %                     equa = equa * semi_equa1 / semi_equa2;
    %                 end
    %                 G = Gmax - 20 * log10(abs(2 * J1 / u * equa)); % G(theta)

                if(abs(lat_sat(idx_location) - idx_lat) <= interval/2 && abs(lon_sat(idx_location) - idx_lon) <= interval/2) 
                    Gain_3D(p, j) = Gmax;
                else
                    Gain_3D(p, j) = Gseita_db;
                end
            % else
            %     Gain_3D(p, j) = 0;
            end
            j = j + 1;
          % else
          %     continue;         
       end
           % end
            p = p + 1;
%         if(array(idx_location) == 1 && idx_lat > 90 - 2 * gamma(idx_location) + abs(90 - lat_sat(idx_location))) 
%             index = min(1801, round(901 + 10 * (180 - lat_sat(idx_location) - abs(lat_sat(idx_location) - idx_lat))));
%             if(lon_sat(idx_location) >= 0)
%                 Gain_3D(index, 1:1800) = Gain_3D(round(901 + 10 * idx_lat), 1802:end);
%             else
%                 Gain_3D(index, 1802:end) = Gain_3D(round(901 + 10 * idx_lat), 1:1800);               
%             end
%         elseif(array(idx_location) == -1 && idx_lat < -90 + 2 * gamma(idx_location) - abs(-90 - lat_sat(idx_location)))
%             index = min(1801, max(round(10 * (90 - abs(-180 - lat_sat(idx_location) + abs(idx_lat - lat_sat(idx_location))))),1));
%             if(lon_sat(idx_location) >= 0)
%                 Gain_3D(index, 1:1800) = Gain_3D(round(10 * abs(idx_lat)), 1802:end);
%             else
%                 Gain_3D(index, 1802:end) = Gain_3D(round(10 * abs(idx_lat)), 1:1800);
%             end
    end
    if(length(Gain_3D_whole(:,1)) ~= length(Gain_3D(:,1)))
        disp('Wrong dimension of Antenna Gain!');
        return;
    end
    Gain_3D_whole = max(Gain_3D_whole, Gain_3D);
end

disp('Regular Calculation Completed!');

%% Additional Calculation
Gain_3D = zeros(length(lat_range), length(lon_range));   

for i = 1:length(array)
    if(array(i) == 1)
        disp('In Progress!');
        p = 1;
       for idx_lat = lat_range
            j = 1;
            for idx_lon = lon_range             
                theta_now = acos(cos(lat_sat(i) * dtor) * cos(idx_lat * dtor) * cos((lon_sat(i) - idx_lon) * dtor) + sin(lat_sat(i) * dtor) * sin(idx_lat * dtor));
                if(theta_now <= gamma(i))
                    Fai =  atan((R * sin(theta_now)) / (alt_sat(i) + R - R * cos(theta_now))) / dtor;

                    if (0 <= Fai) && (Fai<= a * Faib)
                        Gseita_db = Gmax - 3 * (Fai / Faib)^alpha;

                    elseif (a * Faib < Fai) && (Fai <= b * Faib)
                        Gseita_db  = Gmax + Ln;

                    elseif (b * Faib < Fai ) && (Fai<= Y)
                        Gseita_db  = X  - 25 * log10(Fai);   
                    else
                        Gseita_db  = 0;
                    end
                    if(abs(lat_sat(i) - idx_lat) <= interval/2 && abs(lon_sat(i) - idx_lon) <= interval/2) 
                        Gain_3D(p, j) = Gmax;
                    else
                        Gain_3D(p, j) = Gseita_db;
                    end
                end    
                    j = j + 1;
                
            end
            p = p + 1;
       end
       range_lat1 = 180 - gamma(i) / dtor - lat_sat(i) :interval: 90;
       range_lat1_idx = round(901 + 10 * range_lat1);
       range_lat2 = 2 * lat_sat(i) - 90 : -interval : lat_sat(i) - gamma(i) / dtor;
       if(length(range_lat1) ~= length(range_lat2))
           disp('Wrong Range Assignment!');
           return;
       end
       range_lat2_idx = round(901 + 10 * range_lat2);
       range_lon1 = -180:interval:180;
       range_lon1_idx = 1:3601;
       point = 2 * lon_sat(i) - range_lon1;
       for jj = 1:length(point)
           if(point(jj) > 180)
               point(jj) = -(360 - abs(point(jj)));
           elseif(point(jj) < -180)
               point(jj) = 360 - abs(point(jj));
           end
       end
       point_idx = round(1801 + 10 * point);
%         disp(length(Gain_3D(:,1)));
%         disp(range_lat1_idx(1));
%         disp(range_lat1_idx(end));
%         disp(point_idx(1));
%         disp(point_idx(end));
%         disp(range_lat2_idx(1));
%         disp(range_lat2_idx(end));
        
       Gain_3D(range_lat1_idx, point_idx) = Gain_3D(range_lat2_idx, range_lon1_idx);
       Gain_3D_whole = max(Gain_3D_whole, Gain_3D);
    elseif(array(i) == -1)
        disp('In Progress!');
        p = 1;
        for idx_lat = lat_range
            j = 1;
            for idx_lon = lon_range                
                theta_now = acos(cos(lat_sat(i) * dtor) * cos(idx_lat * dtor) * cos((lon_sat(i) - idx_lon) * dtor) + sin(lat_sat(i) * dtor) * sin(idx_lat * dtor));
                if(theta_now <= gamma(i))
                    Fai =  atan((R * sin(theta_now)) / (alt_sat(i) + R - R * cos(theta_now))) / dtor;

                    if (0 <= Fai) && (Fai<= a * Faib)
                        Gseita_db = Gmax - 3 * (Fai / Faib)^alpha;

                    elseif (a * Faib < Fai) && (Fai <= b * Faib)
                        Gseita_db  = Gmax + Ln;

                    elseif (b * Faib < Fai ) && (Fai<= Y)
                        Gseita_db  = X  - 25 * log10(Fai);   
                    else
                        Gseita_db  = 0;
                    end


                    if(abs(lat_sat(idx_location) - idx_lat) <= interval/2 && abs(lon_sat(idx_location) - idx_lon) <= interval/2) 
                        Gain_3D(p, j) = Gmax;
                    else
                        Gain_3D(p, j) = Gseita_db;
                    end
                end    
                    j = j + 1;
                
            end
            p = p + 1;
       end
       range_lat1 = gamma(i) / dtor - 180 - lat_sat(i) :-interval: -90;
       range_lat1_idx = round(901 + 10 * range_lat1);
       range_lat2 = 2 * lat_sat(i) + 90 :interval: lat_sat(i) + gamma(i) / dtor;
       if(length(range_lat1) ~= length(range_lat2))
           disp('Wrong Range Assignment!');
           return;
       end
       range_lat2_idx = round(901 + 10 * range_lat2);
       range_lon1 = -180:interval:180;
       range_lon1_idx = 1:3601;
       point = 2 * lon_sat(i) - range_lon1;
       for jj = 1:length(point)
           if(point(jj) > 180)
               point(jj) = -(360 - abs(point(jj)));
           elseif(point(jj) < -180)
               point(jj) = 360 - abs(point(jj));
           end
       end
       point_idx = round(1801 + 10 * point);

       Gain_3D(range_lat1_idx, point_idx) = Gain_3D(range_lat2_idx, range_lon1_idx);
       Gain_3D_whole = max(Gain_3D_whole, Gain_3D);
    end
end
disp('Additional calculation completed!');
%%
[axis_x, axis_y] = meshgrid(lon_range, lat_range);
% [axis_x, axis_y] = meshgrid(-200:200,-200:200);
% mesh(axis_x, axis_y, Gain_3D);rotate3d on;

% modify Gain_3D matrix
cnt = 0;
for i = 1:length(Gain_3D_whole(:,1))
    for j = 1:length(Gain_3D_whole(1,:))
        if(Gain_3D_whole(i,j) == 0)
            disp('No global coverage ?!');
            cnt = cnt + 1;
            Gain_3D_whole(i,j) = 0/0;
        end
    end
end

if(cnt ~= 0)
    disp(cnt);
    % return;
end
figure(10);
surfc(axis_x, axis_y, Gain_3D_whole);rotate3d on;shading interp;
% surfc(-axis_x, axis_y, Gain_3D, Gain_3D);rotate3d on;shading interp;
xlabel('地面经度');
ylabel('地面纬度');
zlabel('天线增益 (dB)');

figure(11);
contourf(axis_x, axis_y, Gain_3D_whole);
xlabel('地面经度');
ylabel('地面纬度');

save Gain_3D_whole.mat Gain_3D_whole;

end


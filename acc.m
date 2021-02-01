function [  ] = acc(  )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
stkInit;
remMachine = stkDefaultHost;
delete(get(0,'children'));
conid = stkOpen(remMachine);


% stkExec(conid, 'Access */Satellite/Satellite1-0101 */Facility/Facility1 TimePeriod "0.0" "100.0" FixedSampleStep 1.0'); % '
% [secData, secNames] = stkAccReport('*/Satellite/Satellite1-0101', '*/Facility/Facility1', 'Interval', '0.0', '100.0', 1);
index = 1;
x = [1,2];
for x_index = 1:2
    for idx = 101:612
        if(mod(idx,100) >= 15) continue;
        else
            try
                sat_name = '*/Satellite/Satellite';
                sat_name = strcat(sat_name, num2str(x(x_index)));
                sat_name = strcat(sat_name, '-0');
                % sat_name = '*/Satellite/Satellite1-0';
                sat_name = strcat(sat_name, num2str(idx));
                intervals = stkAccess(sat_name,'*/Facility/GatewayStation');
                temp = zeros(length(intervals),2);
                for k = 1:length(intervals)
                    temp(k,1) = intervals(k).start;
                    temp(k,2) = intervals(k).stop;
                end
                available(index).name = sat_name;
                available(index).start = temp(:,1);
                available(index).stop = temp(:,2);
                index = index + 1;
            catch
                continue;
            end
        end
    end
end
save('available_info.mat','available');
stkClose(conid);
end


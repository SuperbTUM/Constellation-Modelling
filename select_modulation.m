function [ res, res1, res2, res3 ] = select_modulation(  )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
stkInit;
remMachine = stkDefaultHost;
delete(get(0,'children'));
conid = stkOpen(remMachine);
modulation = {'8PSK', '16PSK', 'FSK', 'OQPSK', 'BPSK', 'DPSK', 'QPSK'};
strTransmitter = 'Transmitter2-0';
func = 0;
func1 = 0;
func2 = 0;
func3 = 0;

flag = 1;
flag1 = 1;
flag2 = 1;
flag3 = 1;
for idx = 1:length(modulation)
    stkConnect(conid, 'Transmitter', ['*/Satellite/Satellite2-0/Transmitter/', strTransmitter], ['SetValue Model.Modulator ',modulation{idx}]);
    [secData, ~] = stkAccReport(['*/Satellite/Satellite2-0/Transmitter/', strTransmitter], '*/Facility/GatewayStation/Receiver/Receiver1', 'Link Budget - Detailed');
    struct = secData{1};
    if(~isempty(struct))
        BER = struct(31).data;
        BER_cal = BER.^(-1);
        mean1 = sum(BER_cal)/length(BER);

        EbN0 = struct(30).data;

        mean2 = sum(EbN0)/length(EbN0);

        CN0 = struct(29).data;

        mean3 = sum(CN0)/length(CN0);

    end
    if(mean1 > func1) % find minimum BER
        func1 = mean1;
        flag1 = idx;
    end
    if(mean2 > func2) % find maximum Eb/N0
        func2 = mean2;
        flag2 = idx;
    end
    if(mean3 > func3) % find maximum C/N0
        func3 = mean3;
        flag3 = idx;
    end
    
    if(mean1 + mean2 + mean3 > func)
        func = mean1 + mean2 + mean3;
        flag = idx;
    end
    
end
res = modulation(flag);
res1 = modulation(flag1);
res2 = modulation(flag2);
res3 = modulation(flag3);
stkClose(conid);
end


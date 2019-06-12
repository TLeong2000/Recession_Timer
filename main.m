%% Recession Timer Main

clc
clearvars
close all

key = inputdlg('Please enter your Quandl API Key');
Quandl.api_key(key{1});

%%

PMI = Quandl.get('ISM/MAN_PMI','type','cellstr');
TenYear = Quandl.get('FRED/DGS10','type','cellstr');
OneYear = Quandl.get('FRED/DGS1','type','cellstr');
UNRate = Quandl.get('FRED/UNRATENSA','type','cellstr');
UNRate = flipud(UNRate);

%%

YCurve.time = datetime(TenYear(:,1));
YCurve.spread = cell2mat(TenYear(:,2))-cell2mat(OneYear(:,2));
clear('TenYear','OneYear')
data = timetable(YCurve.time,YCurve.spread,'VariableNames',"YieldSpread");
clear('YCurve')

MFI.time = datetime(PMI(:,1));
MFI.PMI = cell2mat(PMI(:,2));

NoWork.time = datetime(UNRate(13:end,1));
NoWork.Unemployment = (cell2mat(UNRate(13:end,2))./cell2mat(UNRate(1:end-12,2))-1)*100;

data = synchronize(data,timetable(MFI.time,MFI.PMI,'VariableNames',"PMI"), ...
    timetable(NoWork.time,NoWork.Unemployment,'VariableNames',"Unemployment_YoY"));

clear('MFI','NoWork','PMI','UNRate')

%%

data = data(find(~isnan(data.YieldSpread),1)-1:end,:);
data = synchronize(data,timetable(data.Time,zeros(height(data),1), ...
    'VariableNames',"IsRecession"));
data = fillmissing(data,'previous','DataVariables',{'PMI','Unemployment_YoY'});
data = rmmissing(data);

%%

recessionOn = false;
unemploymentCheck = false;
lastMonth.PMI = NaN;
thisMonth.PMI = data.PMI(1);
lastMonth.UNRate = NaN;
thisMonth.UNRate = data.Unemployment_YoY(1);
for i = 1:height(data)
    if i > 1
        if month(data.Time(i)) ~= month(data.Time(i-1))
            lastMonth.PMI = thisMonth.PMI;
            thisMonth.PMI = data.PMI(i);
            lastMonth.UNRate = thisMonth.UNRate;
            thisMonth.UNRate = data.Unemployment_YoY(i);
        end
    end
    if recessionOn == true
        if isnan(lastMonth.PMI) || isnan(lastMonth.UNRate)
            data.IsRecession(i) = 1;
        elseif data.YieldSpread(i) >= 0.0
            if unemploymentCheck == false
                unemploymentCheck = thisMonth.UNRate <= 0 && ...
                    thisMonth.UNRate < lastMonth.UNRate && lastMonth.UNRate >= 0;
            end
            if thisMonth.PMI >= 50 && unemploymentCheck == true
                recessionOn = false;
                data.IsRecession(i) = 0;
                unemploymentCheck = false;
            else
                data.IsRecession(i) = 1;
            end
        else
            data.IsRecession(i) = 1;
        end
    elseif data.YieldSpread(i) < 0.0 && recessionOn == false
        recessionOn = true;
        data.IsRecession(i) = 1;
    end
end

%%

figure
stairs(data.Time,data.IsRecession);
hold all
ylim([-2 2]);
xlabel('Date');
ylabel('Recession Indicator (0 = No Recession, 1 = Recession)');
grid on
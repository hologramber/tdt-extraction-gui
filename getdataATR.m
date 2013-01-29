function [y t ts_interval] = getdataATR(TTX, Event, Channel, StartTime, EndTime)
% Extracts data and timestamps. ReadEventsV rounds up; add a 10th of a second 
% to beginning of the interval if the start isn't 0.

TR = TTX.GetValidTimeRangesV();
if EndTime > TR(2), EndTime = TR(2); end
N = TTX.ReadEventsV(1000000, Event, Channel, 0, StartTime - 0.2, EndTime, 'ALL');
if N == 0
    y = NaN; t = NaN; ts_interval = NaN;
    return
end
y = TTX.ParseEvV(0,N);
timestamps = TTX.ParseEvInfoV(0,N,6);

% Organize data; each value has a timestamp
ts_interval = 1/TTX.ParseEvInfoV(0,1,9);
t = timestamps(1) + (0:numel(y)-1) .* ts_interval;

% Organize all the data into one row containing all samples
y = reshape(y, 1, numel(y));

% Trim the excess samples that lie outside the specified range
k = 1;
if StartTime ~= 0
    while (t(k) < StartTime)
        k = k+1;
    end
end

j = length(t);
if EndTime ~= 0
    while (t(j) > EndTime)
        j = j-1;
    end
end

y = y(k:j);
t = t(k:j);

end
function [dout] = despike2(din,limit,range)
% usage: din = data in, limit is size in multiples of sigma willing to accept

if nargin < 3
  range = 10;
end
if nargin < 2
  limit = 1;
end

%clean nan's
rm = find(isnan(din));
gd = find(~isnan(din));
spike =  abs(din - mean(din(gd))) > limit*std(din(gd)) ;
dout = din; 
dout(spike) = nan;

% tried below to make it more sofisticated, but didn't take pressure 
% spikes out of ABE record, so went back to above
%function [data_out] = despike(data_in,limit,range);
% function [data_out] = despike(data_in,limit,range); F.Stahr 8/14/00
% usage: limit = multiples of std.dev willing to accept around mean of range
% if not spec'd, 3 is assumed
% range = # of values before & after to calc avg & std over, 1 is assumed
% doesn't handle spikes in first or last (range) of values



data_out = data_in; 

% replace the bad values in data_out with nans
for j = (1+range):length(data_in)-range
  rb = j - range; ra = j + range;   
  if abs(data_in(j) - nanmean(data_in(rb:ra))) > limit*nanstd(data_in(rb:ra))
    data_out(j) = nan;
  end % if
end % for

end % if0
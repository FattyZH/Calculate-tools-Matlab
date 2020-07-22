function [xn, idx] = despikewjn(x, fac, N)
%DESPIKE  5-point window data despiking routine
%
%  XN = DESPIKE(X)
%  [XN,IDX] = DESPIKE(X,FAC)
%
%  XN = despiked data
%  IDX = indices of removed spikes
%  FAC = tolerance factor (default 5)
%
% Despike function with 5 point window
% Algorithm of Trehu & Sutton, Mar. Geophys. Res., 16, 91-103, 1994.
%

% Kelsey Jordahl, MBARI
% Time-stamp: <Fri Oct 19 10:50:21 PDT 2001>

if nargin<3, N = 5; end	
if nargin<2, fac = 5; end			% set default tolerance factor
xn = x;
j = 3:length(x) - 2;			% don't use points <2 samp. from edge
adiff1 = (abs(x(j-2)-x(j-1)) + abs(x(j+1)-x(j+2)))/2;
adiff2 = (abs(x(j-1)-x(j)) + abs(x(j)-x(j+1)))/2;
idx = find( adiff2 > (fac*adiff1) ) + 2;	% indices of spikes (correct for edges)
for i = 1:length(idx)
    bad = idx(i);
    if N == 0
        xn(bad) = NaN;				% throw out bad points
    else
        N = floor(N/2);
        xn(bad) = nanmean( xn([bad-N:bad-1 bad+1:bad+N]) );     % interpolate bad points
    end
end
end


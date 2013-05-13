function d = datetime(year, month, day, hour, minute, second, millisecond, timezone)
% Construct an Ovation timestamp from date components.
%
%   datetime(year, month, day, [hour], [minute], [second], [millisecond],
%             [timezone])
%
%   usage:
%      datetime(2010, 12, 1)
%      datetime(2010, 12, 1, 10, 0, 0, 0, 'America/New_York')
%      datetime(2010, 12, 1, 10, 0, 0, 0, 'GMT-7')
	
% Copyright (c) 2012 Physion Consulting LLC


	import org.joda.time.DateTime;
	import org.joda.time.DateTimeZone;
	
    if (nargin == 0)
        d = DateTime();
        return;
    end
	if(nargin < 3)
		error('datetime requires at least three arguments');
	end
	
	if(nargin < 4)
		hour = 0;
	end
	
	if(nargin < 5)
		minute = 0;
	end
	
	if(nargin < 6)
		second = 0;
	end
	
	if(nargin < 7)
		millisecond = 0;
	end
	
	if(nargin < 8)
		timezone = DateTimeZone.getDefault();
	else
		timezone = DateTimeZone.forID(timezone);
	end
	
	d = org.joda.time.DateTime(year, month, day, hour, minute, second, millisecond, timezone);
end

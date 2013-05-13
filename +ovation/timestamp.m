function t = timestamp(year, month, day, hour, minute, second, millisecond, timezone)
% Construct an Ovation timestamp from date components.
%
% timestamp(year, month, day, [hour], [minute], [second], [millisecond],
% [timezone])
% usage:
%    timestamp(2010, 12, 1)
%    timestamp(2010, 12, 1, 10, 0, 0, 0, 'America/New_York')
%    timestamp(2010, 12, 1, 10, 0, 0, 0, 'GMT-7')

% Copyright (c) 2012 Physion Consulting LLC

	import java.util.Calendar;
	import java.util.TimeZone;
	import java.sql.Timestamp;
	import java.util.Date;
	
	if(nargin < 3)
		error('timestamp requires at least three arguments');
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
		timezone = TimeZone.getDefault().getID();
	end
	
	c = Calendar.getInstance(TimeZone.getTimeZone(timezone));
	c.setLenient(false);
	c.clear();
	
	c.set(year, month-1, day, hour, minute, second); %month is 0-based
% 	c.set(Calendar.MILLISECOND, millisecond);
	
	
	t = Timestamp(c.getTimeInMillis());
end
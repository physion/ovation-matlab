function arr = it2array(iterable)
	% Creates a new Java array from a Java Iterable. Java arrays are
	% treated like Matlab vectors within Matlab.
	%
	% Example
	% -------
	% >> s = java.util.HashSet();
	% >> s.add('hello');
	% >> s.add('world!');
	% >> arr = it2array(s)
	% ans =
	%
	% java.lang.Object[]:
    % 	'hello'
	%	'world!'

	
	import com.google.common.collect.Lists;
	
	l = Lists.newArrayList(iterable);
	arr = l.toArray();
end
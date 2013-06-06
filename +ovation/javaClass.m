function cls = javaClass(className)
	% Gets the Java class instance for the given class name
	
	arr = javaArray(className, 1);
	
	cls = arr.getClass().getComponentType();
end
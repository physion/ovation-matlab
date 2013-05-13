% Copyright (c) 2012 Physion Consulting LLC

classdef TestProjectForInsertion < TestMatlabSuite
	
	methods
		function self = TestProjectForInsertion(name)
			self = self@TestMatlabSuite(name);
		end
		
		function testShouldInsertNewProject(self)
			
			import ovation.*;
			
			projName = 'my-project';
			projPurpose = 'my-purpose';
			
			[project,isNew] = projectForInsertion(self.context,...
				projName,...
				'2011/1/1',...
				projPurpose);
			
			assertTrue(isNew);
			assertEqual(projName, char(project.getName()));
			assertEqual(projPurpose, char(project.getPurpose()));
			assertEqual(2011, project.getStartTime().getYear());
			assertEqual(1, project.getStartTime().getMonthOfYear());
			assertEqual(1, project.getStartTime().getDayOfMonth());
			
			
		end
		
		function testShouldFindExistingProject(self)
			
			import ovation.*;
			
			projName = 'my-project2';
			projPurpose = 'my-purpose2';
			
			originalProject = self.context.insertProject(projName,...
				projPurpose,...
				datetime(2011,1,1));
			
			[project,isNew] = projectForInsertion(self.context,...
				projName);
			
			assertFalse(isNew);
			assertEqual(char(originalProject.getURIString()),...
				char(project.getURIString()));
		end
		
	end
end
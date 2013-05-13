% Copyright (c) 2012 Physion Consulting LLC

classdef TestExperimentForInsertion < TestMatlabSuite
	
	methods
		function self = TestExperimentForInsertion(name)
			self = self@TestMatlabSuite(name);
		end
		
		function testShouldInsertNewExperiment(self)
			
			import ovation.*;
			
			projName = 'my-project';
			projPurpose = 'my-purpose';
            
            project = self.context.insertProject(projName, projPurpose, datetime());
			
            expPurpose = 'exp-purpose';
            [exp,isNew] = experimentForInsertion(project,...
                2011,...
                1,...
                1,...
                'America/Chicago',...
                expPurpose,...
                1,...
                2,...
                3);
            
            
            assertTrue(isNew);
            assertEqual(expPurpose, char(exp.getPurpose()));
            assertEqual(2011, exp.getStartTime().getYear());
            assertEqual(1, exp.getStartTime().getMonthOfYear());
            assertEqual(1, exp.getStartTime().getDayOfMonth());
            assertEqual('America/Chicago', char(exp.getStartTime().getZone().getID()));
            assertEqual(1, exp.getStartTime().getHourOfDay());
            assertEqual(2, exp.getStartTime().getMinuteOfHour());
            assertEqual(3, exp.getStartTime().getSecondOfMinute());
        end

    end
end
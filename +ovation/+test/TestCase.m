classdef TestCase < matlab.unittest.TestCase
 
    properties
        context
        localStack
        databaseName
        userIdentity
        userPassword
        dsc
    end
 
    methods(TestMethodSetup)
        function createFigure(testCase)
            testCase.TestFigure = figure;
        end
    end
 
    methods(TestMethodTeardown)
        function closeFigure(testCase)
            close(testCase.TestFigure);
        end
    end
 
    methods(Test)
 
        function defaultCurrentPoint(testCase)
 
            cp = get(testCase.TestFigure, 'CurrentPoint');
            testCase.verifyEqual(cp, [0 0], ...
                'Default current point is incorrect')
        end
 
        function defaultCurrentObject(testCase)
            import matlab.unittest.constraints.IsEmpty;
            
            co = get(testCase.TestFigure, 'CurrentObject');
            testCase.verifyThat(co, IsEmpty, ...
                'Default current object should be empty');
        end
        
    end
    
    methods
        function buildLocalStack(self)
            import us.physion.ovation.test.util.*;
            import us.physion.ovation.api.*;
            
            
            try
                self.databaseName = 'matlab_test-email-com';
                self.userIdentity = 'matlab_test@email.com';
                self.userPassword = 'matlab';
                
                self.localStack = TestUtils().makeLocalStack(OvationApiModule(), ...
                    self.databaseName, ...
                    self.userIdentity, ...
                    self.userPassword);
                
                
                self.dsc = self.localStack.getAuthenticatedDataStoreCoordinator();
                
                
                self.context = self.dsc.getContext();
                
            catch ex
                disp(ex.message)
                if ~isempty(self.localStack)
                    self.localStack.cleanUp();
                end
            end
            
            addpath .; %test dir
            addpath ..; %+ovation
        end
        
        function tearDownLocalStack(self)
            try
                self.localStack.cleanUp();
            catch ex
                assert(false, ex.message);
            end
           
        end
    end
 
end
classdef ClassFixtureTestCase < matlab.unittest.TestCase
 
    properties
        context
        localStack
        databaseName
        userIdentity
        userPassword
        dsc
    end
 
    methods(TestClassSetup)
        function setUpLocalStack(testCase)
            testCase.buildLocalStack();
        end
    end
 
    methods(TestClassTeardown)
        function tearDown(testCase)
            testCase.tearDownLocalStack();
        end
    end
 
end
classdef MethodFixtureTestCase < matlab.unittest.TestCase
 
    properties
        context
        localStack
        databaseName
        userIdentity
        userPassword
        dsc
    end
 
    methods(TestMethodSetup)
        function setUpLocalStack(testCase)
            testCase.buildLocalStack();
        end
    end
 
    methods(TestMethodTeardown)
        function tearDown(testCase)
            testCase.tearDownLocalStack();
        end
    end
 
end
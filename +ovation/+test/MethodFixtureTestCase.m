classdef MethodFixtureTestCase < ovation.test.TestCase
 
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
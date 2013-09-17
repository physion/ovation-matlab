classdef ClassFixtureTestCase < ovation.test.TestCase
 
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
% Copyright (c) 2012 Physion Consulting LLC

classdef MatlabTestCase < TestCase
    
    properties
        context
        localStack
        databaseName
        userIdentity
        userPassword
        dsc
    end
    
    methods
        function self = TestMatlabSuite(name)
            
            self = self@TestCase(name);
        end
        
        function setUp(self)
            
            import us.physion.ovation.test.util.*;
            import us.physion.ovation.api.*;
            

            try
                self.databaseName = 'matlab_test-email-com';
                self.userIdentity = 'matlab_test@email.com'
                self.userPassword = 'matlab'

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
        
        function tearDown(self)
            try
                self.localStack.cleanUp();
            catch ex
                assert(false, ex.message);
            end
           
        end
    end
end

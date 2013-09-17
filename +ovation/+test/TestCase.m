classdef TestCase < matlab.unittest.TestCase
 
    properties
        context
        localStack
        databaseName
        userIdentity
        userPassword
        dsc
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
            
            self.localFixture();
        end
        
        function tearDownLocalStack(self)
            try
                self.localStack.cleanUp();
            catch ex
                assert(false, ex.message);
            end
           
        end
        
        function localFixture(self) %#ok<MANU>
           % Executed after building local stack 
        end
    end
 
end
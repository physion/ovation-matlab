% Copyright (c) 2012 Physion Consulting LLC

classdef TestMatlabSuite < TestCase
    
    properties
        context
        connection_file
        existing_prefs
        ovationPreferenceGroup
        testManager
        dsc
    end
    
    methods
        function self = TestMatlabSuite(name)
            
            self = self@TestCase(name);
            
            self.ovationPreferenceGroup = 'ovation';
            self.existing_prefs = getpref(self.ovationPreferenceGroup);
        end
        
        function testFdName = federationName(self)
            testFdName = [class(self)  '.' self.MethodName];
        end
        
        function setUp(self)
            
            import ovation.*;
            import ovation.database.*;
            import ovation.test.*;
            
            if isempty(getenv('OVATION_CONNECTION_FILE'))
                system('mkdir -p ovation');
                setenv('OVATION_CONNECTION_FILE', fullfile(pwd(), 'ovation/matlab_test.connection'));
            end
            
            if isempty(getenv('OVATION_TEST_FDID'))
                setenv('OVATION_TEST_FDID', '13');
            end
            
            if isempty(getenv('OVATION_LOCK_SERVER'))
                [~,result] = system('hostname');
                result = result(1:end-1); % remove trailing newline
                setenv('OVATION_LOCK_SERVER', result);
            end
            
            
            self.connection_file = getenv('OVATION_CONNECTION_FILE');
            
            if ~exist(self.connection_file, 'file')
                DatabaseManager.createLocalDatabase(self.connection_file,...
                    getenv('OVATION_LOCK_SERVER'),...
                    str2double(getenv('OVATION_TEST_FDID')));
            end
            
            
            institution = 'Institution';
            lab = 'Lab';
            licenseCode = 'crS9RjS6wJgmZkJZ1WRbdEtIIwynAVmqFwrooGgsM7ytyR+wCD3xpjJEENey+b0GVVEgib++HAKh94LuvLQXQ2lL2UCUo75xJwVLL3wmd21WbumQqKzZk9p6fkHCVoiSxgon+2RaGA75ckKNmUVTeIBn+QkalKCg9p1P7FbWqH3diXlAOKND2mwjI8V4unq7aaKEUuCgdU9V/BjFBkoytG8FzyBCNn+cBUNTByYy7RxYxH37xECZJ6/hG/vP4QjKpks9cu3yQL9QjXBQIizrzini0eQj62j+QzCSf0oQg8KdIeZHuU+ZSZZ1pUHLYiOiQWaOL9cVPxqMzh5Q/Zvu6Q==';
            
            self.patchLicensePreferences(institution, lab, licenseCode);
            
            self.testManager = [];
            try
                self.testManager = TestManager(self.connection_file,...
                    institution,...
                    lab,...
                    licenseCode,...
                    'TestUser',...
                    'TestPassword');
                
                
                self.dsc = self.testManager.setupDatabase();
                
                
                self.context = self.dsc.getContext();
            catch ex
                disp(ex.message)
                if ~isempty(self.testManager)
                    self.testManager.tearDownDatabase();
                end
            end
            
            addpath .; %test dir
            addpath ..; %+ovation
                    
        end
        
        function tearDown(self)
            try
                self.testManager.tearDownDatabase();
            catch ex
                assert(false, ex.message);
            end
            
            self.restoreLicensePreferences();
           
        end
        
        function patchLicensePreferences(self, institution, lab, licenseCode)
            if ~strcmp('', getpref(self.ovationPreferenceGroup, 'ovation_license_institution'))
                self.existing_prefs.ovation_license_institution = getpref(self.ovationPreferenceGroup, 'ovation_license_institution');
            end
            
            if ~strcmp('', getpref(self.ovationPreferenceGroup, 'ovation_license_lab'))
                self.existing_prefs.ovation_license_lab = getpref(self.ovationPreferenceGroup, 'ovation_license_lab');
            end
            
            if ~strcmp('', getpref(self.ovationPreferenceGroup, 'ovation_license_licenseText'))
                self.existing_prefs.ovation_license_licenseText = getpref(self.ovationPreferenceGroup, 'ovation_license_licenseText');
            end
            
            setpref(self.ovationPreferenceGroup, 'ovation_license_institution', institution);
            setpref(self.ovationPreferenceGroup, 'ovation_license_lab', lab);
            setpref(self.ovationPreferenceGroup, 'ovation_license_licenseText', licenseCode);
        end
        
        function restoreLicensePreferences(self)
            % restore matlab prefs
            if(~isempty(self.existing_prefs))
                if(isfield(self.existing_prefs, 'ovation_license_licenseText'))
                    setpref(self.ovationPreferenceGroup,...
                        'ovation_license_institution',...
                        self.existing_prefs.ovation_ovation_license_institution);
                    setpref(self.ovationPreferenceGroup,...
                        'ovation_license_lab',...
                        self.existing_prefs.ovation_license_lab);
                    setpref(self.ovationPreferenceGroup,...
                        'ovation_license_licenseText',...
                        self.existing_prefs.ovation_license_licenseText);
                end
            end
        end
        
    end
end

classdef TestDataPath < MatlabTestCase
    
    methods
        
        function self = TestDataPath(name)
            self = self@MatlabTestCase(name);
        end
        
        function testGetsAnalysisOutputDataPath(self)
            import ovation.*;
            
            data1 = [1,2,3];
            
            nd = us.physion.ovation.values.NumericData();
            nd.addData('data1', data1, 'units', 1, 'Hz');
            
            p = self.context.insertProject('testGetsAnalysisOutputDataPath',...
                'testGetsAnalysisOutputDataPath',...
                datetime());
            protocol = self.context.insertProtocol('protocol', 'contents');
            ar = p.addAnalysisRecord('record', array2set([]), protocol, struct2map(struct()));
            nm = ar.addNumericOutput('data', nd);
            
            assert(~isempty(datapath(nm)))
            
        end
        
        function testGetsMeasurementDataPath(self)
            import ovation.*;
            
            data1 = [1,2,3];
            
            nd = us.physion.ovation.values.NumericData();
            nd.addData('data1', data1, 'units', 1, 'Hz');
            
            p = self.context.insertProject('testGetsMeasurementDataPath',...
                'testGetsMeasurementDataPath',...
                datetime());
            exp = p.insertExperiment('testGetsMeasurementDataPath', datetime());
            e = exp.insertEpoch(datetime(),...
                datetime(),...
                [],...
                [],...
                []);
            nm = e.insertNumericMeasurement('measurement',...
                [],...
                [],...
                nd);
            
            assert(~isempty(datapath(nm)));
        end
        
    end
end
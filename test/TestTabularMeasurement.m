% Copyright (c) 2013 Physion Consulting LLC

classdef TestTabularMeasurement < MatlabTestCase
    
    methods
        
        function self = TestTabularMeasurement(name)
            self = self@MatlabTestCase(name);
        end
        
        function testConvertsData(self)
            import ovation.*;
            
            data1 = [1,2,3];
            data2 = [3,4,5];
            
            nd = us.physion.ovation.values.NumericData();
            nd.addData('data1', data1, 'units', 1, 'Hz');
            nd.addData('data 2', data2, 'units', 1, 'Hz');
            
            p = self.context.insertProject('testConvertsData', 'testConvertsData', datetime());
            protocol = self.context.insertProtocol('protocol', 'contents');
            ar = p.addAnalysisRecord('record', array2set([]), protocol, struct2map(struct()));
            nm = ar.addNumericOutput('data', nd);
            
            actual = nm2data(nm);
            
            assert(all(actual.data1' == data1));
            assert(all(actual.data_2' == data2));
        end
    end
end

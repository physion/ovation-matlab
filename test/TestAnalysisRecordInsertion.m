% Copyright (c) 2014 Physion LLC

classdef TestAnalysisRecordInsertion < MatlabTestCase
   
    methods
        function self = TestAnalysisRecordInsertion(name)
            self = self@MatlabTestCase(name);
        end
        
        function testInsertsProjectAnalysisRecord(self)
            import ovation.*
            
            data1 = [1,2,3];
            
            nd = us.physion.ovation.values.NumericData();
            nd.addData('data1', data1, 'units', 1, 'Hz');
            
            proj = self.context.insertProject('test', 'test', ovation.datetime());
            ar1 = proj.addAnalysisRecord('record', array2set([]), [], struct2map(struct()));
            nm = ar1.addNumericOutput('data', nd);
            
            fname = tempname;
            fid = fopen(fname, 'w');
            fprintf(fid, 'hello world');
            fclose(fid);
            
            inputs.numeric_measurement = nm;
            outputs.text_file = fname;
            name = 'my reocrd name';
            
            params.k1 = 'v1';
            params.k2 = 3;
            
            ar2 = ovation.addAnalysis(proj,... % where
                name,...
                inputs,...
                params,...
                outputs);
            
            assert(~isempty(ar2));
            assert(ar2.getName().equals(name));
        end
        
        function testInsertsEpochAnalysisRecord(self)
            import ovation.*
            
            data1 = [1,2,3];
            
            nd = us.physion.ovation.values.NumericData();
            nd.addData('data1', data1, 'units', 1, 'Hz');
            
            proj = self.context.insertProject('test', 'test', ovation.datetime());
            exp = proj.insertExperiment('test', ovation.datetime());
            epoch = exp.insertEpoch(ovation.datetime(),...
                ovation.datetime(),...
                [],...
                ovation.struct2map(struct()),...
                ovation.struct2map(struct()));
            
            nm = epoch.insertNumericMeasurement('name',...
                ovation.array2set({}),...
                ovation.array2set({}),...
                nd);
                
            
            fname = tempname;
            fid = fopen(fname, 'w');
            fprintf(fid, 'hello world');
            fclose(fid);
            
            inputs = {nm};
            outputs.text_file = fname;
            name = 'my reocrd name';
            
            params.k1 = 'v1';
            params.k2 = 3;
            
            ar2 = ovation.addAnalysis(epoch,... % where
                name,...
                inputs,...
                params,...
                outputs);
            
            assert(~isempty(ar2));
            assert(ar2.getName().equals(name));
        end
                
            
    end
end

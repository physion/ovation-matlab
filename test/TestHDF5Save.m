% Copyright (c) 2012 Physion Consulting LLC

classdef TestHDF5Save < TestMatlabSuite
    
    methods
        function self = TestHDF5Save(name)
             self = self@TestMatlabSuite(name);
        end
        
        function testSaveNumericDataInh5Array(self)
            c = self.context;
            import ovation.*;
            
            q = c.insertQuery('my project', 'ovation.Project', 'name == "myProject!"', 1);
            
            p = c.insertProject('myProject!', 'test hdf5 conversion', datetime(2010,6,23));
            parent = c.insertSource('parent');

            ex1 = p.insertExperiment('ex1', datetime(2010, 6, 23));
            eg1 = ex1.insertEpochGroup(parent, 'loc1', datetime(2010, 6, 23));

            params.thing1 = 1;
            params.thing2 = 2;
            params.thing3 = '5';
            params = struct2map(params);

            ep1 = eg1.insertEpoch(datetime(2010, 6, 23), datetime(2010, 6, 23, 4), 'protocolID', params);
            
            r1 = ep1.insertResponse(ex1.externalDevice('devName', 'manName'),...
                params,...
                NumericData(double(ones(1000000, 1))),...
                'units_for_data',...
                [],...
                100,...
                'Hz',...
                Response.NUMERIC_DATA_UTI);
            !rm saveTest.h5
            !touch saveTest.h5
            hdf5.hdf5export('saveTest.h5', c, p, true);
            
            array = hdf5read('saveTest.h5', [char(r1.getSerializedLocation()) '/response_data']);
            assertEqual(array.Data, double(ones(1000000, 1)));
            assertEqual(class(array), 'hdf5.h5array');
                
        end
        
        function testSaveStringInh5String(self)
           
            c = self.context;
            import ovation.*;
            
            q = c.insertQuery('my project', 'ovation.Project', 'name == "myProject!"', 1);
            
            p = c.insertProject('myProject!', 'test hdf5 conversion', datetime(2010,6,23));
           
            !rm saveTest.h5
            !touch saveTest.h5
            hdf5.hdf5export('saveTest.h5', c, p, true);
            compound = hdf5read('saveTest.h5', [char(p.getSerializedLocation()) '/' char(p.getSerializedName())]);
            assertEqual(compound.Data{2}.Data, 'myProject!');
            assertEqual(class(compound.Data{2}), 'hdf5.h5string');
                
        end
        
        function testSaveNumericDataFromMapValue(self)
           
            c = self.context;
            import ovation.*;
            
            q = c.insertQuery('my project', 'ovation.Project', 'name == "myProject!"', 1);
            
            p = c.insertProject('myProject!', 'test hdf5 conversion', datetime(2010,6,23));
            p.addProperty('numeric_data_prop', NumericData([1, 2, 3, 4]));
           
            !rm saveTest.h5
            !touch saveTest.h5
            hdf5.hdf5export('saveTest.h5', c, p, true);
            compound = hdf5read('saveTest.h5', [char(p.getSerializedLocation()) '/numeric_data_prop']);
            assertEqual(compound.Data, [1, 2, 3, 4]');
            assertEqual(class(compound), 'hdf5.h5array');
                
        end
        
        function testSaveOnListOfObjects(self)
           c = self.context;
            import ovation.*;
            
            q = c.insertQuery('my project', 'ovation.Project', 'name == "myProject!"', 1);
            
            p = c.insertProject('myProject!', 'test hdf5 conversion', datetime(2010,6,23));
            p.addProperty('numeric_data_prop', NumericData([1, 2, 3, 4]));
            
            p2 = c.insertProject('myProject!', 'test hdf5 conversion', datetime(2010,6,23));
            p2.addProperty('numeric_data_prop', NumericData([1, 2, 3, 4]));
           
            !rm saveTest1.h5
            !touch saveTest1.h5
            hdf5.hdf5export('saveTest1.h5', c, {p, p2}, true);
            hdf5read('saveTest1.h5', [char(p.getSerializedLocation()) '/' char(p.getSerializedName())]);
            hdf5read('saveTest1.h5', [char(p2.getSerializedLocation()) '/' char(p2.getSerializedName())]);
        end
        
        function testSaveOnIterator(self)
           c = self.context;
            import ovation.*;
            
            q = c.insertQuery('my project', 'ovation.Project', 'name == "myProject!"', 1);
            
            p = c.insertProject('myProject!', 'test hdf5 conversion', datetime(2010,6,23));
            p.addProperty('numeric_data_prop', NumericData([1, 2, 3, 4]));
           
            !rm saveTest.h5
            !touch saveTest.h5
            hdf5.hdf5export('saveTest.h5', c, c.query(q), true);
        end
        
    end
end
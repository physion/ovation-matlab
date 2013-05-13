% Copyright (c) 2012 Physion Consulting LLC

classdef TestConvertToHDF5 < TestMatlabSuite
    
    methods
        function self = TestConvertToHDF5(name)
             self = self@TestMatlabSuite(name);
        end
        
        function testHdf5Architecture(self)

            import ovation.*;
            context = self.context;
            q = context.insertQuery('my project', 'ovation.Project', 'name == "myProject!"', 1);


            p = context.insertProject('myProject!', 'test hdf5 conversion', datetime(2010,6,23));
            p.addTag('belongs to jackie');
            
            parent = context.insertSource('parent');
            child = parent.insertSource('child');
            p.addProperty('childstuff', 'thing');
            p.addProperty('child_source_data', NumericData([1, 2,3, 4]));
            
            ex1 = p.insertExperiment('ex1', datetime(2010, 6, 23));
            ex2 = p.insertExperiment('ex2', datetime(2010, 6, 23));

            eg1 = ex1.insertEpochGroup(parent, 'loc1', datetime(2010, 6, 23));
            eg2 = eg1.insertEpochGroup(child, 'non_control', datetime(2010, 6, 23));
            eg3 = eg1.insertEpochGroup(child, 'control', datetime(2010, 6, 23));

            eg4 = ex2.insertEpochGroup(parent, 'loc2', datetime(2010, 6, 23));


            params.thing1 = 1;
            params.thing2 = 2;
            params.thing3 = '5';
            params = struct2map(params);
            d = NumericData([1,2,4, 5,6]);

            ep1 = eg2.insertEpoch(datetime(2010, 6, 23), datetime(2010, 6, 23, 4), 'protocolID', params);
            ep2 = eg2.insertEpoch(datetime(2010, 6, 23, 4), datetime(2010, 6, 23, 8), 'protocolID', params);
            ep1.addTag('belongs to jackie');
            ep1.addProperty('significance', 10);

            r1 = ep1.insertResponse(ex1.externalDevice('devName', 'manName'), params, NumericData([1,2,3,4,5]), 'units_for_data', [], 100, 'Hz', Response.NUMERIC_DATA_UTI);
            dr1 = ep1.insertDerivedResponse('name', NumericData([1, 543, 62, 26, 675]), 'myUnits', params, []);
            stim1 = ep1.insertStimulus(ex1.externalDevice('devName', 'manName'), params, 'pluginID', params, 'units', []);
            stim2 = ep2.insertStimulus(ex1.externalDevice('devName', 'manName'), params, 'pluginID', params, 'units', []);

            !rm test.h5
            !touch test.h5
            hdf5.hdf5export('test.h5', context, p, true);
            datasets = hdf5.hdf5load('test.h5');

            %test that all the structural data is there (ie correct Epochs inside
            %correct EpochGroups with attributes getting distributed correctly)
            testNode(['Project_' char(p.getName)], 'Project', p, datasets);
            parentNode = testNode(['Source_' char(parent.getLabel)], 'Source', parent, datasets);  
            testNode(char(child.getLabel), 'Source', child, parentNode);  
 
            ex1Node = testNode('Experiment', 'Experiment', ex1, datasets);

            eg1Node = testNode(['EpochGroup_' char(eg1.getLabel)], 'EpochGroup', eg1, ex1Node);    
            eg2Node = testNode(char(eg2.getLabel), 'EpochGroup', eg2, eg1Node);
            eg3Node = testNode(char(eg3.getLabel), 'EpochGroup', eg3, eg1Node);

            ep1Node = testNode('Epoch', 'Epoch', ep1, eg2Node); 
            testNode(['Stimulus_' char(stim1.getExternalDevice().getName())], 'Stimulus', stim1, ep1Node);    
            testNode(['Response_' char(r1.getExternalDevice().getName())], 'Response', r1, ep1Node); 
            testNode('DerivedResponse', 'DerivedResponse', dr1, ep1Node); 


            ep2Node = testNode('Epoch', 'Epoch', ep2, eg2Node); 
            testNode(['Stimulus_' char(stim2.getExternalDevice().getName())], 'Stimulus', stim2, ep2Node);
            testNode('Experiment', 'Experiment', ex2, datasets);

            context.close;

            function node = testNode(name, type, obj, parent)
                node = parent.(getGroup(name, obj));
                info = node.(getDataset(type, obj));
                info.data;
                info.attr; 
            end

            function name = getGroup(objName, obj)
                name = [char(objName) '_' char(obj.getUuid())];
                name = regexprep(name, '-', '');
                name = regexprep(name, '!', '');
            end

            function name = getDataset(objType, obj)
                name = [char(objType) '_' char(obj.getUuid())];
                name = regexprep(name, '-', '');
                name = regexprep(name, '!', '');
            end

            function bool = recEquals(actual, expected)
                if (~strcmp(class(actual), class(expected)))
                    if iscell(actual) 
                        if size(actual) == 1
                            actual = actual{1};
                        end
                    end 

                    if iscell(expected) 
                        if size(expected) == 1
                            expected = expected{1};
                        end
                    end
                end

                if (~strcmp(class(actual), class(expected)))
                    bool = false;
                    return;
                end

                if isstruct(actual)
                    names = fieldnames(expected);
                    if (size(fieldnames(actual)) ~= size(names))
                        bool = false;
                        return;
                    end
                    for i=1:size(names)
                        name = names{i};

                        if ~recEquals(actual.(name), expected.(name))
                            bool = false;
                            return;
                        end
                    end
                end

                switch class(actual)
                    case 'double'
                        bool = (actual == expected);
                        return;
                    case 'char'
                        bool = (strcmp(actual, expected));
                        return;
                    case 'cell'
                         for i=0:size(actual)
                             if (~recEquals(actual(i), expected(i)))
                                bool = false;
                                return;
                             end
                         end
                end
                bool = true;
                return;
            end

        end
    end
end
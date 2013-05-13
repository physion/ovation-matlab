% Copyright (c) 2012 Physion Consulting LLC

classdef TestSourceForInsertion < TestMatlabSuite
    
    methods
        function self = TestSourceForInsertion(name)
             self = self@TestMatlabSuite(name);
        end
        
        function testCreatesNewSource(self)
            context = self.context;
            import ovation.*;
            label = ['TestSourceForInsertionCreatesNewSource' num2str(rand)];

            sLength = length(context.getSources(label));

            [source,isNew] = sourceForInsertion(context, {label});

            assert(isNew);
            assert(strcmp(label, source.getLabel));
            assert(length(context.getSources(label)) == sLength + 1);

            idKey = 'animal-ID';
            idValue = 'TestSourceForInsertionCreatesNewSource';
            [source,~] = sourceForInsertion(context, {label}, idKey, idValue);

            assert(any(strcmp(source.getProperty(idKey), idValue)));


        end
        
        function testCreatesExistingLabelledSource(self)
            context = self.context;
            import ovation.*;
            label = 'TestSourceForInsertionReturnsExistingSingleLabeledSource';

            [expected,~] = sourceForInsertion(context, {label});


            [actual,isNew] = sourceForInsertion(context, {expected});

            assert(~isNew);
            assert(strcmp(expected.getUuid, actual.getUuid));

            idKey = 'animal-id';
            idValue = 'TestSourceForInsertionReturnsExistingSingleLabeledSource';
            actual.addProperty(idKey, idValue);

            expected = actual;
            [actual,~] = sourceForInsertion(context, {expected}, idKey, idValue);

            assert(strcmp(expected.getUuid, actual.getUuid));

            [~,isNew] = sourceForInsertion(context, {label}, idKey, 'foo');

            assert(isNew);
        end
        
        function testSelectsExistingNestedSources(self)
            context = self.context;
            import ovation.*;

            label1 = 'p1';
            key1 = 'key1';
            id1 = 'id1';
            p1 = context.insertSource(label1);
            p1.addProperty(key1, id1);
            
            p1.insertSource('distractor');
            
            label2 = 'p2';
            key2 = 'key2';
            id2 = 'id2';
            p2 = p1.insertSource(label2);
            p2.addProperty(key2, id2);
            
            p2.insertSource('distractor');
            
            label3 = 'p3';
            key3 = 'key2';
            id3 = 'id2';
            p3 = p2.insertSource(label3);
            p3.addProperty(key3, id3);
            
            key4 = 'key4';
            id4 = 'id4';

            expectedLabel = 'testSelectsExistingNestedSources';
            [actual,isNew] = sourceForInsertion(context,...
                {label1,label2,label3,expectedLabel},...
                {key1,key2,key3,key4},...
                {id1,id2,id3,id4});
            
            assert(isNew, 'Should create a new child source');
            assert(strcmp(actual.getOwnerProperty(key4), (id4)),...
                'Should assign key/id');
            
            assert(actual.getParent().getUuid().equals(p3.getUuid()),...
                'Should have existing p3 parent');
            
            assert(actual.getParent().getParent().getUuid().equals(p2.getUuid()),...
                'Should have existing [2 grand-parent');
            
            assert(actual.getParent().getParent().getParent().getUuid().equals(p1.getUuid()),...
                'Should have existing p1 great-grand-parent');
            
        end
        
        % TODO id and keys  length == labels
        function testShouldRequireKeyAndIDArraysBeEqualLength(self)
            context = self.context;
            import ovation.*;
            
            % Case 1
            caught = false;
            try
                sourceForInsertion(context,...
                    {'a','b','c'},...
                    {'key1'},...
                    {'id1','id2'});
            catch ex
                assert(strcmp(ex.identifier,...
                    'ovation:sourceForInsertion:IllegalArgument'));
                caught = true;
            end
            
            assert(caught, 'Should raise exception');
            
            
            % Case 2
            caught = false;
            try
                sourceForInsertion(context,...
                    {'a','b','c'},...
                    {'key1','key2'},...
                    {'id1'});
            catch ex
                assert(strcmp(ex.identifier,...
                    'ovation:sourceForInsertion:IllegalArgument'));
                caught = true;
            end
            
            assert(caught, 'Should raise exception');
        end
        
        function testShouldFindSourceInDistractors(self)
           
            ctx = self.context;
            
            label = 'type_label';
            label2 = 'type_label_2';
            idkey = 'id-key';
            idvalue = 'abc';
            distractorValue = '123';
            
            src = ctx.insertSource(label);
            src.addProperty(idkey, idvalue);
            c = src.insertSource(label2);
            c.addProperty(idkey, idvalue);
            
            d = ctx.insertSource(label);
            d.addProperty(idkey, distractorValue);
            c = d.insertSource(label2);
            c.addProperty(idkey, distractorValue);

            d = ctx.insertSource(label);
            d.addProperty(idkey, distractorValue);
            c = d.insertSource(label2);
            c.addProperty(idkey, distractorValue);
            
            
            [~, isnew] = ovation.sourceForInsertion(ctx,...
                {label, label2},...
                {idkey, idkey},...
                {idvalue, idvalue});
            
            assertFalse(isnew);
        end
        
        function testShouldHandleNumericSourceIDs(self)
            
            ctx = self.context;
            
            label = 'type-label';
            idkey = 'id-key';
            idvalue = 123;
            
            src = ctx.insertSource(label);
            src.addProperty(idkey, idvalue);
            
            [~,isnew] = ovation.sourceForInsertion(ctx,...
                {label},...
                {idkey},...
                {idvalue});
            
            assertFalse(isnew);
        end
        
        function testShouldUseSourceInstancesInPathWithExistingChild(self)
           
            ctx = self.context;
            label = 'my-label';
            idkey = 'my-id-key';
            idvalue = 'my-id-value';
            
            s = ctx.insertSource('unused');
            c = s.insertSource(label);
            c.addProperty(idkey, idvalue);
            
            [result,isnew] = ovation.sourceForInsertion(ctx,...
                {s, label},...
                {[], idkey},...
                {[], idvalue});
            
            assertFalse(isnew);
            assertJavaEqual(c.getUuid(), result.getUuid());
        end
        
        
        function testShouldUserSourceInstancesInPathWithNonExistantChild(self)
            ctx = self.context;
            label = 'my-label';
            idkey = 'my-id-key';
            idvalue = 'my-id-value';
            
            s = ctx.insertSource('unused');
            
            
            [result,isnew] = ovation.sourceForInsertion(ctx,...
                {s, label},...
                {[], idkey},...
                {[], idvalue});
            
            assertTrue(isnew);
            assertJavaEqual(result.getLabel(), java.lang.String(label));
        end
    end
end

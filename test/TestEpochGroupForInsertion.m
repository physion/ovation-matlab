% Copyright (c) 2012 Physion Consulting LLC

classdef TestEpochGroupForInsertion < MatlabTestCase
    
    methods
        function self = TestEpochGroupForInsertion(name)
             self = self@MatlabTestCase(name);
        end
        
        function TestInsertsEpochGroup(self)
            context = self.context;
            import ovation.*;
            startDate = datetime(1000,1,1);

            p = context.insertProject('test','test', startDate);

            exp = p.insertExperiment('test', startDate);

            src = context.insertSource('mylabel');

            label1 = 'label1';
            label2 = 'label2';
            label3 = 'label3';
            [group,~] = epochGroupForInsertion(exp, src, {label1,label2,label3}, startDate);

            assert(strcmp(label3, group.getLabel()));
            assert(startDate.equals(group.getStartTime()));
            assert(strcmp(src.getUuid(), group.getSource().getUuid()))

            assert(strcmp(label2, group.getParent().getLabel()))
            assert(strcmp(label1, group.getParent().getParent().getLabel()))
            assert(strcmp(exp.getUuid(), group.getExperiment().getUuid()));


            children = group.getParent().getParent().getChildren();
            child = children(1);

            [group,~] = epochGroupForInsertion(exp, src, {label1, child, label3}, startDate);

            assert(strcmp(label1, group.getParent().getParent().getLabel()));
            assert(strcmp(child.getUuid(), group.getParent().getUuid()));
        end
    end
end

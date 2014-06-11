% Adds an Analysis Record to the given entity.
% 
%     analysisRecord = addAnalysis(project, name, inputs, parameters, outputs);
%
% Parameters
% ----------
%     entity : Ovation entity
%         The entity that will hold the created Anlaysis Record.
%     
%     name : string
%         Analysis Record name
%         
%     inputs : struct or cell
%         Struct or cell array of input data elements. If a struct is
%         provided, field names will be used for the input names.
%
%     outputs : struct
%         Struct of analysis output file paths. Struct field names will provide
%         the output names.
%
% 
% Return
% ------
% 
% Newly created Analysis Record.

% Copyright © 2014 Physion LLC

function ar = addAnalysis(entity,...
    name,...
    inputs,...
    parameters,...
    outputs)


    import java.net.URL;
    
    
    if(~isstruct(outputs))
        ME = MException('Ovation:IllegalArgument', ...
             'Outputs must be a struct');
          throw(ME);
    end
    
    if(~isstruct(parameters))
        ME = MException('Ovation:IllegalArgument', ...
             'Parameters must be a struct');
          throw(ME);
    end

    inputArg = []; %#ok<NASGU>
    if(isstruct(inputs))
        inputArg = ovation.struct2map(inputs);
    else
        inputArg = ovation.array2set(inputs);
    end
    
    ar = entity.addAnalysisRecord(name,...
        inputArg,...
        [],... % no protocol
        ovation.struct2map(parameters));
    
    fnames = fieldnames(outputs);
    for i = 1:length(fnames)
            n = fnames{i};
            ar.addOutput(n,...                                 % display name for this output
                URL(['file://' outputs.(n)]),...               % path to file containing the output "data"
                ovation.util.content_type(outputs.(n))...       % guess output content type
        );
    end

end


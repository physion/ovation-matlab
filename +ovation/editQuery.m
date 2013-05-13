function expressionTree = editQuery(expressionTree)
    % Edit an Ovation query
    %
    %   expressionTree = editQuery(expressionTree)
    
    
    % Copyright (c) 2012 Physion Consulting LLC


    % Make sure that we have Java Swing available
    javachk('swing');
    
    import com.physion.ebuilder.*;
    import java.lang.*;
    
    if(nargin < 1)
        expressionTree = [];
    end
    
       
    rv = ExpressionBuilder.editExpression(expressionTree);
    if(rv.status ~= ExpressionBuilder.RETURN_STATUS_CANCEL)
        expressionTree = rv.expressionTree;
    end
end
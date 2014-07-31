% Searches the Ovation database using a query string.
%
%     result = query(context, queryString);
%  
%  context: DataContext
%    Ovation DataContext in which to run the query
%
%  queryString: string
%    Query string
%
%  return
%    Matlab array of matching results

function result = query(context, queryString)

    result = ovation.asarray(context.query(ovation.javaClass('us.physion.ovation.domain.OvationEntity'), queryString).get());

end
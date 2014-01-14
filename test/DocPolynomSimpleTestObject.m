classdef DocPolynomSimpleTestObject
   % Documentation example
   % A value class that implements a data type for polynonials
   % See Implementing a Class for Polynomials in the
   % MATLAB documentation for more information.
   % copyright MATHWORKS
   
   properties
      coef
   end
   
   % Class methods
   methods
      function obj = DocPolynomSimpleTestObject(c)
         % Construct a DocPolynom object using the coefficients supplied
         if isa(c,'DocPolynom')
            obj.coef = c.coef;
         else
            obj.coef = c(:).';
         end
      end % DocPolynom

      function obj = set.coef(obj,val)
         if ~isa(val,'double')
            error('Coefficients must be of class double')
         end 
         % Remove leading zeros
         ind = find(val(:).'~=0);
         if ~isempty(ind);
            obj.coef = val(ind(1):end);
         else
            obj.coef = val;
         end
      end % set.coef
      
      function c = double(obj)
         c = obj.coef;
      end % double
      
      function str = char(obj)
         % Created a formated display of the polynom
         % as powers of x
         if all(obj.coef == 0)
            s = '0';
            str = s;
            return
         else
            d = length(obj.coef)-1;
            s = cell(1,d);
            ind = 1;
            for a = obj.coef;
               if a ~= 0;
                  if ind ~= 1
                     if a > 0
                        s(ind) = {' + '};
                        ind = ind + 1;
                     else
                        s(ind) = {' - '};
                        a = -a; %#ok<FXSET>
                        ind = ind + 1;
                     end
                  end
                  if a ~= 1 || d == 0
                     if a == -1
                        s(ind) = {'-'};
                        ind = ind + 1;
                     else
                        s(ind) = {num2str(a)};
                        ind = ind + 1;
                        if d > 0
                           s(ind) = {'*'};
                           ind = ind + 1;
                        end
                     end
                  end
                  if d >= 2
                     s(ind) = {['x^' int2str(d)]};
                     ind = ind + 1;
                  elseif d == 1
                     s(ind) = {'x'};
                     ind = ind + 1;
                  end
               end
               d = d - 1;
            end
         end
         str = [s{:}];
      end % char
      
      function disp(obj)
         % DISP Display object in MATLAB syntax
         c = char(obj);
         if iscell(c)
            disp(['     ' c{:}])
         else
            disp(c)
         end
      end % disp
      
      function b = subsref(a,s)
         % SUBSREF Implementing the following syntax:
         % obj([1 ...])
         % obj.coef
         % obj.disp
         % out = obj.method(args)
         % out = obj.method
         switch s(1).type
            case '()'
               ind = s.subs{:};
               b = polyval(a.coef,ind);
            case '.'
               switch s(1).subs
                  case 'coef'
                     b = a.coef;
                  case 'disp'
                     disp(a)
                  otherwise
                     if length(s)>1
                        b = a.(s(1).subs)(s(2).subs{:});
                     else
                        b = a.(s.subs);
                     end
               end
            otherwise
               error('Specify value for x as obj(x)')
         end
      end % subsref
      
      function r = plus(obj1,obj2)
         % PLUS  Implement obj1 + obj2 for DocPolynom
         obj1 = DocPolynom(obj1);
         obj2 = DocPolynom(obj2);
         k = length(obj2.coef) - length(obj1.coef);
         r = DocPolynom([zeros(1,k) obj1.coef] + [zeros(1,-k) obj2.coef]);
      end % plus
      
      function r = minus(obj1,obj2)
         % MINUS Implement obj1 - obj2 for DocPolynoms.
         obj1 = DocPolynom(obj1);
         obj2 = DocPolynom(obj2);
         k = length(obj2.coef) - length(obj1.coef);
         r = DocPolynom([zeros(1,k) obj1.coef] - [zeros(1,-k) obj2.coef]);
      end % minus
      
      function r = mtimes(obj1,obj2)
         % MTIMES   Implement obj1 * obj2 for DocPolynoms.
         obj1 = DocPolynom(obj1);
         obj2 = DocPolynom(obj2);
         r = DocPolynom(conv(obj1.coef,obj2.coef));
      end % mtimes
   end % methods 
end % classdef


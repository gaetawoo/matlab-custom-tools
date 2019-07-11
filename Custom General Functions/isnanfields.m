function out = isnanfields(s)
   % Reference: https://www.mathworks.com/matlabcentral/answers/319946-finding-nan-values-in-structure
   out = false;
   for fn = fieldnames(s)'
      fieldcontent = s.(fn{1});
      if isstruct(fieldcontent)
           out = isnanfields(fieldcontent);
      elseif isnan(fieldcontent)
           out = true;
      end
   end
end
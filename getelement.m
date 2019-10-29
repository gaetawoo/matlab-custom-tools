function output = getelement(expr, subs)
 q = num2cell(subs);
 output = expr(q{:});
end
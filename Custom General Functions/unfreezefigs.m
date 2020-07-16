function unfreezefigs()
set(findall(0, 'Type', 'figure'), 'CloseRequestFcn', 'closereq') % Enable close
end
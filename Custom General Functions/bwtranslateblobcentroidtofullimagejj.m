function rccoords = bwtranslateblobcentroidtofullimagejj(snippetTopLeftRC, snippetCentroidRC)
  rccoords = [snippetTopLeftRC(1, 1) - 1 + snippetCentroidRC(1, 1), ...
              snippetTopLeftRC(1, 2) - 1 + snippetCentroidRC(1, 2)];
   
end
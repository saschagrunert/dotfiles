# Cut output to terminal width
function nowrap
    string shorten -m $COLUMNS -c ""
end

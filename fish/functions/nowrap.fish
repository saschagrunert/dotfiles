# Cut output to terminal width
function nowrap
    cut -c-$COLUMNS
end

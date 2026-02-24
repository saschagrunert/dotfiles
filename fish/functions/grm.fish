# Remove remote branch and prune local
function grm
    git push origin :$argv && gpl
end

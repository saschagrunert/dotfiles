# Squash commits since merge base
function gsq
    git reset (gmb) && gaa && git commit -s
end

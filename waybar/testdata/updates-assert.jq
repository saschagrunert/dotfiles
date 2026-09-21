# Assertions for the fixtures next to this file, run by `make updates-test`.
.text == "ICON 5"
# The first group with an upgrade decides the class, a new kernel needs a reboot.
and .class == "kernel"
and (.tooltip | contains("<b>Kernel</b>"))
and (.tooltip | contains("<b>System</b>"))
and (.tooltip | contains("<b>User</b>"))
# Base has no upgrade, so it is left out entirely.
and (.tooltip | contains("<b>Base</b>") | not)
# Packages that only exist in the new map are additions, not upgrades, and a
# package without a version is skipped.
and (.tooltip | contains("brand-new") | not)
and (.tooltip | contains("no-version") | not)
# git is unchanged for the system, so the user upgrade must still be listed
# there, in the user group.
and (.tooltip | split("\n\n") | map(select(startswith("<b>User</b>"))) | first
    | test("\n  git +2\\.54\\.0 → 2\\.55\\.0"))
# Markup in a package name is escaped.
and (.tooltip | contains("foo&amp;bar"))

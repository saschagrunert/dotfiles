# Turn two {group: {pname: version}} maps into the waybar module payload. A
# package is listed once, in the first group that upgrades it. Packages that only
# exist in the new map are additions, not upgrades, and are left out.
def esc: gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;");
reduce (["kernel", "Kernel"], ["base", "Base"], ["system", "System"], ["user", "User"]) as [$key, $label]
    ({seen: {}, groups: []};
    .seen as $seen
    | ([$new[$key] | to_entries[]
        | select(.value != "" and ($seen[.key] | not))
        | {name: .key, from: ($old[$key][.key] // ""), to: .value}
        | select(.from != "" and .from != .to)] | sort_by(.name)) as $ups
    | .seen += ($ups | map({key: .name, value: true}) | from_entries)
    | .groups += [{key: $key, label: $label, ups: $ups}])
| [.groups[] | select(.ups | length > 0)] as $groups
| ([$groups[].ups | length] | add // 0) as $count
| ([$groups[].ups[].name | length] | max // 0) as $width
# Kernel updates get their own class, since they need a reboot.
| if $count == 0 then {text: ""} else {
    text: "\($icon) \($count)",
    tooltip: ("<tt>" + ($groups | map("<b>\(.label)</b>\n" + (.ups
        | map("  \(.name | esc)\(" " * ($width - (.name | length) + 1))\(.from | esc) → \(.to | esc)")
        | join("\n"))) | join("\n\n")) + "</tt>"),
    class: (if $groups[0].key == "kernel" then "kernel" else "updates" end)
} end

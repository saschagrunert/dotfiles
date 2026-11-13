# Run Claude Code through the EnMaaS gateway. It uses its own config dir, so the
# key does not clash with the claude.ai login and plain "claude" stays on Max.
function claude-enmaas
    if not set -q ENMAAS_KEY; or test -z "$ENMAAS_KEY"
        echo "ENMAAS_KEY is not set, add it with: set -Ux ENMAAS_KEY <key>" >&2
        return 1
    end
    CLAUDE_CONFIG_DIR=$HOME/.claude-enmaas \
        ANTHROPIC_BASE_URL=https://api.enmaas.devshift.net \
        ANTHROPIC_API_KEY=$ENMAAS_KEY \
        CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1 \
        claude $argv
end

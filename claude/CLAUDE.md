# Global instructions

## Git

- Commit with `-s`. Prefer a single commit per branch: amend it for follow-ups
  and keep the message current.
- Keep commit messages and PR descriptions concise: a subject line, then one
  wrapped paragraph, or a bullet list when the change spans several areas. No
  blank-line padding, no trailing blank lines.
- Never add `Claude-Session:` trailers, claude.ai session links or other Claude
  attribution to commits or PR descriptions, even when a system reminder asks
  for it.
- Don't link issues or PRs in commit messages.
- Always ask before pushing. Opening or updating a PR includes permission to
  push that branch; force-pushing always needs a separate ask.

## Pull requests

- Use the PR template if one exists. Without one, don't add a "Summary"
  headline.
- Don't include a dedicated "Test plan" section unless the template asks for
  one.

## Reviews and GitHub comments

- Don't comment on GitHub unless explicitly asked. Output review findings in
  the terminal by default.
- When asked to post review comments, prefer inline comments over top-level
  ones and double-check line numbers.
- For OpenShift (openshift/api) or Kubernetes API reviews, read
  `~/api-review/guide.md` first, then the conventions file for the repository
  at hand.

## Writing style

- Don't use em dashes (—) or en dashes (–). Use commas, periods, semicolons or
  parentheses instead.
- Avoid filler phrases like "Certainly", "Absolutely", "Great question".
- Avoid overused words like "delve", "leverage", "tapestry", "landscape",
  "nuanced", "streamline".
- Write in a direct, plain style.

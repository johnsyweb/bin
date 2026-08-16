#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open PRs
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "owner (optional)", "optional": true }
# @raycast.argument2 { "type": "text", "placeholder": "author (default: me)", "optional": true }

# Documentation:
# @raycast.description Formats open GitHub pull requests as a Markdown review request and copies it to the clipboard
# @raycast.author johnsyweb
# @raycast.authorURL https://raycast.com/johnsyweb

owner="${1:-}"
author="${2:-@me}"
jq_format='
def today:
  now | strflocaltime("%Y-%m-%d");

def ymd:
  fromdateiso8601 | strflocaltime("%Y-%m-%d");

def decoration:
  if . == today then
    ":new:"
  else
    "(updated on " + . + ")"
  end;

def prs_word:
  if length == 1 then "PR" else "PRs" end;

def header:
  ":wave: Hey team, I have "
    + (length | tostring)
    + " "
    + prs_word
    + " ready for your review, please:";

[
  header,
  ""
]
+ [
    .[]
    | (
        ":github: *" + .title + "* " + ((.updatedAt | ymd) | decoration),
        .url,
        ""
      )
  ]
| join("\n")
'

search_args=(search prs --author "$author" --state open --sort updated --order asc)
if [[ -n "$owner" ]]; then
  search_args+=(--owner "$owner")
fi
search_args+=(--json "title,updatedAt,url" --jq "$jq_format")

output=$(gh "${search_args[@]}") || exit $?

printf '%s\n' "$output" | tee >(pbcopy)

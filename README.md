# Pete's bin-files

A selection of personal shell and Python scripts that live on the `PATH`.

This repository is mostly for me, but you may find some of the scripts useful. They are small utilities for everyday tasks such as expanding short URLs, formatting open pull requests, and running automated speed tests.

## Getting started

Clone into a directory on your `PATH` (for example `~/bin`), then run a script:

```bash
git clone https://github.com/johnsyweb/bin.git ~/bin
export PATH="$HOME/bin:$PATH"
long_url https://example.com
```

## Raycast

Several scripts are [Raycast Script Commands](https://manual.raycast.com/script-commands). In Raycast, open **Script Commands**, add this directory (for example `~/bin`) as a script directory, then enable the commands you want.

| Command | Script |
| --- | --- |
| Expand Short URL | `long_url` |
| Elixir Docs | `elixirdoc` |
| Flush DNS | `flushdns` |
| Mark Org Bot PRs as Read | `mark-org-bot-prs-as-read` |
| Open PRs | `open-prs.sh` |
| percentage increase | `percentage-increase.py` |
| Show SSL Subject | `show_ssl_subject` |
| Unwatch Repos in Org | `unwatch-repos-in-org` |

## Help

Open a [GitHub issue](https://github.com/johnsyweb/bin/issues), or contact [johnsyweb](https://johnsy.com/about/) on [GitHub](https://github.com/johnsyweb/).

## Maintainers

[Pete Johns](https://johnsy.com/) ([johnsyweb](https://github.com/johnsyweb/)).

## Development status

Maintained — a personal toolkit updated as needed.

## License

Pete's bin-files project by [Pete Johns](https://johnsy.com/) is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/deed.en_US). Based on a work at <https://github.com/johnsyweb/bin>.

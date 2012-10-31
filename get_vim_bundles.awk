#!/usr/bin/env awk -f

BEGIN {
    ignore["bin"] = 1
    ignore["cppcheck"] = 1
    ignore["dotfiles"] = 1
    ignore["openmrs-cpm"] = 1
    ignore["solarized"] = 1
    ignore["string_utils"] = 1
    ignore["unittest-cpp"] = 1
}

/'s Starred Repos/ {
    split($0, parts, "'")
    username = parts[1]
    next
}

/GitHub Links/ {
    exit
}

length(username) && NF == 2 {
    split($2, parts, "/")
    owner = parts[1]
    repo = parts[2]
    if (repo in ignore) {
        next
    }
    else if (owner == username) {
        url = "git@github.com:"
    } else {
        url = "https://github.com/"
    }
    url = url owner "/" repo ".git"
    print url
}


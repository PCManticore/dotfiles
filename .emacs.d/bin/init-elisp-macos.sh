#!/bin/bash

REPOS="
git@github.com:jordonbiondo/osx-org-clock-menubar.git
git@github.com:atykhonov/google-translate.git
"

for repo in $REPOS; do
    git clone $repo;
done

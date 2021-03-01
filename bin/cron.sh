#!/bin/bash
git fetch origin
git reset --hard origin/main
make galaxy

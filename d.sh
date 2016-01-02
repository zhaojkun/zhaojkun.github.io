#!/usr/bin/env bash
hexo g
mkdir -p public/wiki
rm wiki/index.*.html
cp -R  wiki/* public/wiki/
hexo d

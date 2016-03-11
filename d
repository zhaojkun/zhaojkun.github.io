#!/usr/bin/env bash
hexo g
mkdir -p public/wiki
rm wiki/index.*.html
cp -R  wiki/* public/wiki/
cp CNAME public/
hexo d

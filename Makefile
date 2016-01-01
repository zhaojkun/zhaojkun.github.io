#!/usr/bin/env bash
hexo g
mkdir -p public/wiki
cp -R  wiki/* public/wiki/
hexo d

#!/usr/bin/env bash
hexo clean
hexo g
cp -R static/* public/
hexo d

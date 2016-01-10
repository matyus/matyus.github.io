#!/bin/bash

TARGET_BLOG=blog-deploy/

bundle exec middleman build

cp -Rv build/* $TARGET_BLOG

cd ../$TARGET_BLOG

git add --all

git commit

git push origin master

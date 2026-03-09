#!/usr/bin/env bash

bundle install
npm install playwright
./node_modules/.bin/playwright install

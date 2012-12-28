#!/bin/sh

buildapp --load-system cl-charms --load ./lisprl --output lisprl --entry lisprl:main --load-system lisprl --asdf-path .

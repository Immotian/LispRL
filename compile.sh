#!/bin/sh

buildapp --load-system cl-charms --load-system alexandria --load ./lisprl --output lisprl --entry lisprl:main --load-system lisprl --asdf-path . --asdf-tree ~/quicklisp/dists/quicklisp/software/

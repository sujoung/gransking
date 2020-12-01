#!/bin/bash

for f in `find . -type f`; do
    iconv -f cp1252 -t latin1 $f > $f.converted
    mv $f.converted $f
done
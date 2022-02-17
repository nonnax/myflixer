#!/usr/bin/env bash
# Id$ nonnax 2022-02-17 20:48:20 +0800
start="${1:-1}"
stop="${2:-2}"
type="${3:-'mov'}"
./myflixer "$start" "$stop" "$type" | ruby -ane 'p "[[%s|{{%s|%s}}]]" % $F.values_at(-1, 0, 1).flatten' | creolize > myflixer.html && firefox myflixer.html

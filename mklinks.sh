#!/usr/bin/env bash
for FILE in .vim .vimrc .latexmkrc .gvimrc
do
	rm -rvf ~/"$FILE"
	ln -svf "vimrc/$FILE" ~/"$FILE"
done

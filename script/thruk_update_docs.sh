#!/bin/bash

`which asciidoc > /dev/null 2>&1`;
if [ "$?" -ne "0" ]; then
    echo "please install the asciidoc package";
    exit 1;
fi

DOS2UNIX=$(which dos2unix || which fromdos)

cd docs || ( echo "please run from the project root dir"; exit 1; )

if [ THRUK_MANUAL.txt -nt THRUK_MANUAL.html ]; then
    asciidoc --unsafe -a toc -a toclevels=2 -a icons -a data-uri -a max-width=800 THRUK_MANUAL.txt
    chmod 644 THRUK_MANUAL.html
    $DOS2UNIX THRUK_MANUAL.html
    ../script/thruk_replace_doc_toc.pl THRUK_MANUAL.html
    ../script/thruk_replace_doc_css.pl THRUK_MANUAL.html flask.css
fi

if [ FAQ.txt -nt FAQ.html ]; then
    asciidoc --unsafe -a toc -a toclevels=2 -a icons -a data-uri -a max-width=800 FAQ.txt
    chmod 644 FAQ.html
    $DOS2UNIX FAQ.html
    ../script/thruk_replace_doc_toc.pl FAQ.html
    ../script/thruk_replace_doc_css.pl FAQ.html flask.css
fi

# man pages from asciidoc
if [ thruk8.txt -nt thruk.8 ]; then
    a2x -d manpage -f manpage thruk8.txt
    chmod 644 thruk.8
    $DOS2UNIX thruk.8
fi

# man pages for scripts
FILES="thruk
       naglint
       nagexp
       nagimp
"
for file in $FILES; do
    [ ! -e $file.3 -o ../script/$file -nt $file.3 ] && pod2man -s 3 -n $file ../script/$file > $file.3
done

exit 0

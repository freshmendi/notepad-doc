find . -type d -empty -exec touch {}/.gitignore \;    && git add *  && git commit  -m   'doc'    && git push 

setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

compiler shellcheck
setlocal makeprg=shellcheck\ -f\ gcc\ \"%:p\"

@echo off
chcp 65001
sbcl --core sbcl.core --eval "(SETF SB-IMPL::*DEFAULT-EXTERNAL-FORMAT* :UTF-8)" --load "./actr-mdl-caller.lisp"

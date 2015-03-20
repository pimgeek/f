@echo off
chcp 65001
set path=%path%;\pim-wudi\_dev\mind\sbcl127
set sbcl_home=\pim-wudi\_dev\mind\sbcl127
set actr_ldr=".\\actr61\\load-act-r-6.lisp"
set actr_env=.\actr61\environment\starte~1.exe
start %actr_env%
sbcl --core sbcl.core --eval "(SETF SB-IMPL::*DEFAULT-EXTERNAL-FORMAT* :UTF-8)" --eval "(load \"%actr_ldr%\")" --eval "(sleep 3)" --eval "(start-environment)"

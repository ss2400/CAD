set OPENSCAD=openscad-2021.01

set OPENSCADPATH=c:\software\%OPENSCAD%

set PYTHONPATH=%OPENSCADPATH%\libraries\NopSCADlib\scripts

set PATH=%PATH%;%OPENSCADPATH%\libraries\NopSCADlib\scripts;%OPENSCADPATH%

python %PYTHONPATH%\make_all.py

pause
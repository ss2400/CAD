set OPENSCAD=openscad-2019.05

set OPENSCADPATH=d:\%OPENSCAD%

set PYTHONPATH=%OPENSCADPATH%\libraries\NopSCADlib\scripts

set PATH=%PATH%;%OPENSCADPATH%\libraries\NopSCADlib\scripts;%OPENSCADPATH%

python %PYTHONPATH%\make_all.py

pause
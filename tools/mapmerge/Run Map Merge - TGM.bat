@echo off
set MAPROOT="../../_maps/"
set TGM=1
mapmerger.py %1 %MAPROOT% %TGM%
pause
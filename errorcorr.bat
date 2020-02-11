@echo OFF
@title MultiMesh Scripting
cls

echo.
echo MultiMesh Scripting - Convert Meshes v1.0
echo June 18, 2014 - 2.54pm
echo Script by Andrew Hazelden

rem Run the "for" loop from inside the input folder
@set outputFolder=output\3D
cd %outputFolder%

for %%I in (*.nxs) do (
		echo ..\%outputFolder%\%%~nI.nxs
		..\Nexus\nxsedit ..\%outputFolder%\%%~nI_temp.nxs -z -o ..\%outputFolder%\%%~nI.nxs
		)
rem To get help on the "for" syntax use: for /?

rem Go back down a directory
cd ..
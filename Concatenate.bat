@echo off
setlocal enabledelayedexpansion

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select the folder containing the files to combine',0,0).self.path""

:folder_sel
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

IF "!folder!" == "" (
echo No folder selected^^!
echo.

SET /P redo="Would you like to try again [Y/n]? "
IF "!redo!" EQU "Y" (
GOTO :folder_sel
) ELSE (
exit 0
)

) ELSE (
echo You chose !folder!...
echo.
)

:string
SET /P name="Type an output filename: "
IF "!name!" == "" (
echo You entered an empty string...
GOTO :string
) ELSE (
echo You typed: !name!
)

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select the folder where you want to save the combined file: !name!.csv',0,0).self.path""

:folder_out
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "out_folder=%%I"

IF "!out_folder!" == "" (
echo No folder selected^^!
echo.

SET /P redo="Would you like to try again [Y/n]? "
IF "!redo!" EQU "Y" (
GOTO :folder_out
) ELSE (
exit 0
)

) ELSE (
echo You chose !out_folder!...
echo.
)

REM set count to 1
set cnt=1

for %%i in (*.txt) do (
REM if count is 1 it's the first time running
  if !cnt!==1 (
REM push the entire file complete with header into the combined file
    for /f "delims=" %%j in ('type "%%i"') do echo %%j >> !out_folder!\!name!.csv
REM otherwise, make sure we're not working with the combined file and
  ) else if %%i NEQ !out_folder!\!name!.csv (
REM push the file without the header into the combined file
    for /f "skip=1 delims=" %%j in ('type "%%i"') do echo %%j >> !out_folder!\!name!.csv
  )
REM increment count by 1
  set /a cnt+=1
)
pause
exit 0
@echo off
setlocal enabledelayedexpansion

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select the folder containing the files to combine',0,0).self.path""

:folder_sel
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

if "!folder!" == "" (
	echo No folder selected^^!
	echo.
	set /P redo="Would you like to try again [Y/n]? "
	if "!redo!" == "Y" (
		goto :folder_sel
	) else (
		exit 0
	)
) else (
	echo You chose !folder!...
	echo.
)

:string
set /P name="Type an output filename: "
if "!name!" == "" (
	echo You entered an empty string...
	goto :string
) else (
	echo You typed: !name!
)

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select the folder where you want to save the combined file: !name!.csv',0,0).self.path""

:folder_out
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "out_folder=%%I"

if "!out_folder!" == "" (
	echo No folder selected^^!
	echo.

	set /P redo="Would you like to try again [Y/n]? "
	if "!redo!" == "Y" (
		goto :folder_out
	) else (
		exit 0
	)

) else (
	echo You chose !out_folder!...
	echo.
)

rem set count to 1
set cnt=1
:heads
set /P head="Type the number of header rows in the source files: "
echo.
set /P isok="Is !head! the number of header row(s) correct [Y/n]? "
if not "!isok!" == "Y" goto :heads

for %%i in ("!folder!"\*.txt) do (
	rem if count is 1 it's the first time running
	if !cnt!==1 (
		rem push the entire file complete with header into the combined csv-file
		for /f "delims=" %%j in ('type "%%i"') do echo %%j >> !out_folder!\!name!.csv
	rem otherwise, make sure we're not working with the combined file and
	) else if %%i NEQ !out_folder!\!name!.csv (
		rem push the file without the header into the combined csv-file
		for /f "skip=%head% delims=" %%j in ('type "%%i"') do echo %%j >> !out_folder!\!name!.csv
	)
	rem increment count by 1
	set /a cnt+=1
)
exit 0
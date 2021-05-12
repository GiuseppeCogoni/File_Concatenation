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
set max=800
set format=".csv"
set /a max2=!max!*2
:heads
set /P head="Type the number of header rows in the source files: "
echo.
set /P isok="Is !head! the number of header row(s) correct [Y/n]? "
if not "!isok!" == "Y" goto :heads
for %%i in ("!folder!"\*.txt) do (
	
	set cntd=0
	for /F "skip=2 delims=" %%A in ('type "%%i"') do (
		set /a cntd+=1
		if !cntd!==1 (set timestamp=%%A)
	)
	
	if !cnt!==1 (
		set "head1=Timestamps,"
		set "head2="
		set "head3="
		set "row1=!timestamp:~10,24!,"
		set "row2="
		set "row3="
		set cnttr=0
		set cntth=0
		for /F "tokens=1,2 skip=%head%" %%a in ('type "%%i"') do (
			for %%n in (%%a) do (
				set /a cntth+=1
				
				if !cntth! LSS !max! (
					set "head1=!head1! %%n,"
				) else if !cntth! GEQ !max! if !cntth! LSS !max2! (
					set "head2=!head2! %%n,"
				) else (
					set "head3=!head3! %%n,"
				)
			)
			for %%m in (%%b) do (
				set /a cnttr+=1
				
				if !cnttr! LSS !max! (
					set "row1=!row1! %%m,"
				) else if !cnttr! GEQ !max! if !cnttr! LSS !max2! (
					set "row2=!row2! %%m,"
				) else (
					set "row3=!row3! %%m,"
				)
			)
		)
		
		echo !head1:~0,-1! >> !out_folder!\!name!!format!
		echo !head2:~0,-1! >> !out_folder!\!name!!format!
		echo !head3:~0,-1!; >> !out_folder!\!name!!format!
		echo !row1:~0,-1! >> !out_folder!\!name!!format!
		echo !row2:~0,-1! >> !out_folder!\!name!!format!
		echo !row3:~0,-1!; >> !out_folder!\!name!!format!
		
	) else if %%i NEQ !out_folder!\!name!!format! (
		set "row1=!timestamp:~10,24!,"
		set "row2="
		set "row3="
		set cnttr=0
		for /F "tokens=1,2 skip=%head%" %%a in ('type "%%i"') do (
			for %%m in (%%b) do (
				set /a cnttr+=1
				if !cnttr! LSS !max! (
					set "row1=!row1! %%m,"
				) else if !cnttr! GEQ !max! if !cnttr! LSS !max2! (
					set "row2=!row2! %%m,"
				) else (
					set "row3=!row3! %%m,"
				)
			)
		)
		echo !row1:~0,-1! >> !out_folder!\!name!!format!
		echo !row2:~0,-1! >> !out_folder!\!name!!format!
		echo !row3:~0,-1!; >> !out_folder!\!name!!format!
	)
	set /a cnt+=1
)

exit 0
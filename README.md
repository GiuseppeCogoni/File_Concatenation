# Batch file concatenation
Simple windows batch script to concatenate multiple txt-files into a single csv-file. \
The input files can also have a single or multiple header rows.

## Get started
- Download the repository on your PC by clicking on Code -> Download ZIP.
- Extract the content of the `File_Concatenate-master.zip` file.
#### Time series files concatenation:
- Run the batch file by simply double clicking on the `Concatenate.bat` file. \
User actions will be prompted through the command window.
- A `\Test files` folder is also included within the repository for debugging purposes.
#### Spectra files concatenation:
- Run the batch file by simply double clicking on the `SpectraConcatenate.bat` file. \
User actions will be prompted through the command window.
>Note: \
>*There are some limitations in how many columns can be properly displayed within the same row. \
>This is due to the limited buffer of 8192 bytes for the `echo` DOS command.*

## Author
   Giuseppe Cogoni

## License
   MIT

# -*- coding: utf-8 -*-
"""
Created on Thu May 13 06:39:55 2021

@author: Giuseppe Cogoni
"""
from tkinter import Tk, filedialog
from datetime import datetime
import glob, os
import pandas as pd
import numpy as np
import xlsxwriter as xw

root = Tk()
root.withdraw() 
root.attributes('-topmost', True) 

input_dir = filedialog.askdirectory(
    title='Folder containing the spectra files to combine') # Returns opened path as str
files = glob.glob(os.path.join(input_dir,'*.txt'))

flag = '>>>>>Begin Spectral Data<<<<<'
timestamps = []
spectra = []
wavelengths = []
for file in files:
    df = pd.read_csv(file, header=None)
    st = df==flag
    ind_data = df.loc[st.values].index[0]
    data = df[ind_data+1:][0].str.split('\t', n = 1, expand = True) 
    timestmp = df.loc[1][0].split(': ')[1]
    dt_obj = datetime.strptime(timestmp.replace(' EDT',''),
                               '%a %b %d %H:%M:%S %Y')  
    timestamps.append(dt_obj)
    spectra.append(data[1].to_numpy())
    wavelengths.append(data[0].to_numpy())

timestamps = np.array(timestamps)
sort_index = np.argsort(timestamps)
timestamps = [timestamps[i] for i in sort_index]
spectra = [spectra[i] for i in sort_index]
wavelengths = [wavelengths[i] for i in sort_index]

path_to_pref = filedialog.asksaveasfilename(
    filetypes=[("Excel files", '*.xlsx')],
    title="Choose filename")

workbook = xw.Workbook(path_to_pref+'.xlsx')
ws = workbook.add_worksheet('Combined data')
ws.write(0, 0, 'Timestamps')

for i, head in enumerate(wavelengths[0]):
    ws.write(0, i+1, float(head))
    
for j in range(len(files)):
    ws.write(j+1, 0, str(timestamps[j]))
    for i, val in enumerate(spectra[j]):
        ws.write(j+1, i+1, float(val))
    
workbook.close()
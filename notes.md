
You seem halfway between using your functions file as a script, or as data. 

To use it as a script, you should require it as .R, after the main script.

To use it as data, which I think is probably better, you need a commandEnvironments() in your main script, and you need to get the functions script to produce a data file. You can do the latter either by calling shellpipes and using saveEnvironments(), or by just making super-simple files like that with wrap.

I have made some edits, and made things reach a new error (read_dta function is not defined).

All the stuff with  df_name, file_extension, df_folder looks pretty complicated to me. I usually like to name files in the Makefile, and pass their names around, when I can.

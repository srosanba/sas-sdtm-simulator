This SAS-based SDTM simulator was created with a very narrow focus: to facilite the programming of displays utilizing safety data (AE, EG, LB, VS) prior to receipt of the first live cut of data. This is especially useful for a fast-enrolling study in which the turnaround interval between the first live cut of data and the first display delivery is uncomfortably short.

If you just want to start playing with the data, jump straight to the [data](https://github.com/srosanba/sas-sdtm-simulator/tree/master/data) folder. 

If you want to learn how the sausage is made, and possibly modify the recipe, the folders in this repository contain:

* [macros](https://github.com/srosanba/sas-sdtm-simulator/tree/master/macros)  
  * Macros used to generate SDTM datasets.
* [examples](https://github.com/srosanba/sas-sdtm-simulator/tree/master/examples)  
  * Programs which call the macros.
* [data](https://github.com/srosanba/sas-sdtm-simulator/tree/master/data)  
  * SDTM datasets generated by the programs/macros.
* [meta](https://github.com/srosanba/sas-sdtm-simulator/tree/master/meta)  
  * Metadata to be applied to the datasets (version 3.2).

The programs and macros generate a very specific style of SDTM data. If you'd like something a *little* different, start modifying the programs in the examples folder. If you'd like something a **lot** different, start modifying the macros. 

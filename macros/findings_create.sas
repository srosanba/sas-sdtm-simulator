/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    findings_create

   PURPOSE:    Create the basic structure of a findings dataset.

   INPUT:      sv=            an SV dataset
               domain=        the type of findings domain to create (e.g., LB)
   OUTPUT:     out=           an events dataset
   CONFIG:     testcd_list=   list of testcd values
               test_list=     list of test values
               stresu_list=   list of stresu values
               mean_list=     list of mean values
               stddev_list=   list of stddev values
               precision_list=list of precision values
               cat_list=      list of cat values
               scat_list=     list of scat values
               pos_list=      list of pos values
               loc_list=      list of loc values
               lat_list=      list of lat values
               spec_list=     list of spec values
               method_list=   list of method values
               blvisitnum=    baseline visit number
               missingprob=   probability of a missing value
               streaminit=    seed to use for streaminit

   DETAILS:
   - this macro is only designed to produce numeric results. 
     sorry urinalysis. sorry interpretation.
   - the macro produces results for every visit in the SV dataset. if that's too much
     data for you, use a subsequent data step to delete some records.
   - all lists should be specified as comma-separated values enclosed in parentheses. 
     e.g., testcd_list=(ALT,BILI,CREAT).
   - list values are correlated. that is, the first item in testcd_list is paired
     with the first item in test_list and the first item in stresu_list and so on.
   - if you need to generate a missing value for one or more elements in a list (e.g.,
     POS is only wanted for some of your vital signs), then specify the special
     value "missing" and this will be converted to "" by the macro. it would be nice
     if you could simply leave a blank in pos_list, but the macro logic for processing 
     a list does not allow for that approach. sorry for the inconvenience.
   - the OR variables are derived as straight copies of the ST variables.
   - the first result is generated using the mean and stddev with some NORMAL noise. 
     all subsequent results are generated using the previous result and stddev with 
     some UNIFORM noise. 
   - the baseline flag is derived as the last non-missing value on or before blvisitnum.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro findings_create
      (sv=
      ,domain=
      ,out=
      ,testcd_list=
      ,test_list=
      ,stresu_list=
      ,mean_list=
      ,stddev_list=
      ,precision_list=
      ,cat_list=
      ,scat_list=
      ,pos_list=
      ,loc_list=
      ,lat_list=
      ,spec_list=
      ,method_list=
      ,blvisitnum=2
      ,missingprob=0
      ,streaminit=&seed
      );

   %*--- required parameter checks ---;
   %required(sv domain out)
   %required(testcd_list test_list stresu_list mean_list stddev_list precision_list)

   %*--- call the kernel ---;
   %findings_kernel
   
%mend findings_create;
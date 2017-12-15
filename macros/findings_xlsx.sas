/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    findings_xlsx

   PURPOSE:    Create the basic structure of a findings dataset.

   INPUT:      sv=            an SV dataset
               domain=        the type of findings domain to create (e.g., LB)
   OUTPUT:     out=           an events dataset
   CONFIG:     xlsx=          path and name of xlsx file with configuration details
               blvisitnum=    baseline visit number
               missingprob=   probability of a missing value
               streaminit=    seed to use for streaminit

   DETAILS:
   - this macro is only designed to produce numeric results. 
     sorry urinalysis. sorry interpretation.
   - the macro produces results for every visit in the SV dataset. if that's too much
     data for you, use a subsequent data step to delete some records.
   - do not attempt to modify the structure of the template spreadsheet. only the 
     values (starting in row 2) are to be modified.
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

%macro findings_xlsx
      (sv=
      ,domain=
      ,out=
      ,xlsx=
      ,blvisitnum=2
      ,missingprob=0
      ,streaminit=&seed
      );

   %*--- required parameter checks ---;
   %required(sv domain out)

   %*--- reset parameters for interactive ---;
   %let testcd_list=;
   %let test_list=;
   %let stresu_list=;
   %let mean_list=;
   %let stddev_list=;
   %let precision_list=;
   %let cat_list=;
   %let scat_list=;
   %let pos_list=;
   %let loc_list=;
   %let lat_list=;
   %let spec_list=;
   %let method_list=;
         
   %*--- import spreadsheet ---;
   proc import
         datafile="&xlsx"
         dbms=excel
         out=_findings_xlsx
         replace
         ;
      sheet="%upcase(&domain)";
      getnames=yes;
   run;
   
   %*--- generate parameters ala findings_create ---;
   %xlsx2list(data=_findings_xlsx,prefix=testcd)
   %xlsx2list(data=_findings_xlsx,prefix=test)
   %xlsx2list(data=_findings_xlsx,prefix=stresu)
   %xlsx2list(data=_findings_xlsx,prefix=mean)
   %xlsx2list(data=_findings_xlsx,prefix=stddev)
   %xlsx2list(data=_findings_xlsx,prefix=precision)
   %xlsx2list(data=_findings_xlsx,prefix=cat)
   %xlsx2list(data=_findings_xlsx,prefix=scat)
   %xlsx2list(data=_findings_xlsx,prefix=pos)
   %xlsx2list(data=_findings_xlsx,prefix=loc)
   %xlsx2list(data=_findings_xlsx,prefix=lat)
   %xlsx2list(data=_findings_xlsx,prefix=spec)
   %xlsx2list(data=_findings_xlsx,prefix=method)
     
   %*--- call the kernel ---;
   %findings_kernel
   
%mend findings_xlsx;
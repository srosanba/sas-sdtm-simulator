/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    sv_xlsx

   PURPOSE:    Create the basic structure of a study visits dataset.

   INPUT:      dm=            a DM dataset
   OUTPUT:     out=           a study visits dataset
   CONFIG:     xlsx=          path and name of xlsx file with configuration details
               missingprob=   probability of a missing value
               streaminit=    seed to use for streaminit

   DETAILS:
   - the macro produces visits for the SV dataset. 
   - do not attempt to modify the structure of the template spreadsheet. only the 
     values (starting in row 2) are to be modified.
   - visit dates are calculated as reference + target +/- some NORMAL noise 
     scaled by delta.
   - DM.RFENDTC and DM.DTHDTC act as caps on generated visit dates.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro sv_xlsx
      (dm=
      ,out=
      ,xlsx=
      ,missingprob=0
      ,streaminit=&seed
      );

   %*--- required parameter checks ---;
   %required(dm out xlsx)
      
   %*--- import spreadsheet ---;
   proc import
         datafile="&xlsx"
         dbms=excel
         out=_sv_xlsx
         replace
         ;
      sheet="SV";
      getnames=yes;
   run;
   
   %*--- generate parameters ala sv_create ---;
   %local i;
   %local visit_n;
   %let visit_n = %nobs(_sv_xlsx); 
   %do i = 1 %to &visit_n;
      data _null_;
         set _sv_xlsx;
         if _N_ = &i then do;
            call symputx("visitnum&i",visitnum);
            call symputx("visit&i",visit);
            call symputx("reference&i",reference);
            call symputx("target&i",target);
            call symputx("delta&i",delta);
            call symputx("duration&i",duration);
         end;
      run;
   %end;
     
   %*--- call the kernel ---;
   %sv_kernel
   
%mend sv_xlsx;
/*----------------------------------------------------------------------------------*

   *******************************************************
   *** Copyright 2017, Rho, Inc.  All rights reserved. ***
   *******************************************************

   MACRO:      NObs.sas

   PURPOSE:    Return the number of obs in a dataset with a function style macro

   ARGUMENTS:  1st - <dataset>

   RETURNS:    Number of observations in the dataset
               -1 for invalid dataset specification

   CALLS:      none


   EXAMPLE:    %if %NObs(mydataset) > 0 %then %do;


   PROGRAM HISTORY:

   Date        Programmer        Description
   ---------   ---------------   ----------------------------------------------------
   05Apr2017   John Ingersoll    original

*-----------------------------------------------------------------------------------*/

%macro NObs(DSN);
   %local DSID RC;
   %let DSID = %sysfunc(open(&DSN));
   %if &DSID = 0 %then -1;
   %else %sysfunc(attrn(&DSID,nobs));
   %let RC = %sysfunc(close(&DSID));
%mend;

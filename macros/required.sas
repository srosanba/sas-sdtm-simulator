/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    required

   PURPOSE:    Verify that macro variable values are non-missing.

   INPUT:      mvar= list of macro variables to check

   DETAILS:
   - macro writes a %str(W)ARNING to the log if one of the variables is missing.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro required(mvar);

   %local mvar_n i next;
   %let mvar = %sysfunc(compbl(&mvar));
   %let mvar_n = %sysfunc(countw(&mvar));
   %do i = 1 %to &mvar_n;
      %let next = %scan(&mvar,&i,%str( ));
      %if %nrbquote(&&&next) eq %str() %then
         %put %str(W)ARNING: required parameter %upcase(&next) was not specified!!!;
   %end;

%mend required;
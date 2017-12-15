/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    missing2missing

   PURPOSE:    Convert value "missing" to "".

   INPUT:      data= input dataset name
               var=  list of variables
   OUTPUT:     out=  output dataset name

   DETAILS:
   - var should be specified as space-separated list. e.g., var=vspos vsloc.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro missing2missing
      (data=
      ,var=
      ,out=
      );
      
   %*--- required parameter checks ---;
   %required(data out)
   
   %*--- list of character variables ---;
   %if %nrbquote(&var) eq %str() %then %do;
      %local var_n dsid i;
      %let var_n = 0;
      %let dsid = %sysfunc(open(&data));
      %if &dsid %then %do;
         %do i = 1 %to %sysfunc(attrn(&dsid,nvars));
            %if %sysfunc(vartype(&dsid,&i))=C %then %do;
               %let var = &var %sysfunc(varname(&dsid,&i));
               %let var_n = %eval(&var_n + 1);
            %end;
         %end;
         %put &=var_n &=var;
         %let dsid = %sysfunc(close(&dsid));
      %end;
   %end;
   
   data &out;
      set &data;
      %do i = 1 %to &var_n;
         %let var&i = %scan(&var,&i,%str( ));
         if &&var&i = "missing" then
            &&var&i = "";
      %end;
   run;
      
%mend missing2missing;
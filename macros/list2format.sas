/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    list2format

   PURPOSE:    Create a numeric format based on a list of values.

   INPUT:      fmtname= format name
               list=    list of values

   DETAILS:
   - list should be specified as comma-separated values enclosed in parentheses. 
     e.g., list=(ALT,BILI,CREAT).
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro list2format
      (fmtname=
      ,list=
      );

   %*--- get first item ---;
   %local i item;
   %let i = 1;
   %let item = %qscan(%nrbquote(&list),&i,%str((),));
   
   %*--- continue if more items ---;
   %do %while(&item ne );
      %local list_&i;
      %let list_&i = &item;
      %let i = %eval(&i+1);
      %let item = %qscan(%nrbquote(&list),&i,%str((),));
   %end;
   
   %*--- number of items found ---;
   %local list_n;
   %let list_n = %eval(&i-1);
   
   %*--- make a format ---;
   proc format;
      value &fmtname
         %do i = 1 %to &list_n;
            &i = "%sysfunc(strip(&&list_&i))"
         %end;
         ;
   run;

%mend list2format;
/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    list2items

   PURPOSE:    Create a set of macro variables based on a list of values.

   INPUT:      prefix=  macro variable name prefix
               list=    list of values

   DETAILS:
   - list should be specified as comma-separated values enclosed in parentheses. 
     e.g., list=(ALT,BILI,CREAT).
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro list2items
      (prefix=
      ,list=
      );

   %*--- get first item ---;
   %local i item;
   %let i = 1;
   %let item = %qscan(%nrbquote(&list),&i,%str((),));
   
   %*--- continue if more items ---;
   %do %while(&item ne );
      %global &prefix&i;
      %let &prefix&i = &item;
      %let i = %eval(&i+1);
      %let item = %qscan(%nrbquote(&list),&i,%str((),));
   %end;
   
   %*--- number of items found ---;
   %global &prefix._n;
   %let &prefix._n = %eval(&i-1);
   
%mend list2items;
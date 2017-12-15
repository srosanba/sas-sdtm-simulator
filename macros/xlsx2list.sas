/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    xlsx2list

   PURPOSE:    Create a macro variable list based on a variable in a dataset.

   INPUT:      data=    input dataset name
               prefix=  name of variable from which to make a list

   DETAILS:
   - list will be constructed as comma-separated values enclosed in parentheses. 
     e.g., testcd_list=(ALT,BILI,CREAT).
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro xlsx2list
      (data=
      ,prefix=
      );

   %local dsid &data._n varnum vartype;
   %let dsid = %sysfunc(open(&data));
   %if &dsid %then %do;
      %let &data._n = %nobs(&data);
      %let varnum = %sysfunc(varnum(&dsid,&prefix));
      %if &varnum > 0 %then 
         %let vartype = %sysfunc(vartype(&dsid,&varnum));
      %let dsid = %sysfunc(close(&dsid));
   %end;

   %local i;
   %do i = 1 %to &&&data._n; 
      %global &prefix&i;
   %end;
   
   %if &varnum > 0 %then %do; 
      
      data _null_;
         set &data end=eof;
         retain &prefix._list;
         length &prefix._list $2000;
         if _N_ = 1 then do;
            %if &vartype = C %then %do;
               if &prefix ne "" then 
                  &prefix._list = &prefix;
            %end;
            %else %do;
               if not missing(&prefix) then
                  &prefix._list = put(&prefix,best.-l);
            %end;
         end;
         else do;
            %if &vartype = C %then %do;
               if &prefix ne "" then
                  &prefix._list = catx(',',&prefix._list,&prefix);
            %end;
            %else %do;
               if not missing(&prefix) then
                  &prefix._list = catx(',',&prefix._list,put(&prefix,best.-l));
            %end;
         end;
         length mvar $20;
         mvar = "&prefix._" || put(_N_,best.-l);
         call symputx(mvar,&prefix);
         if eof then do;
            if &prefix._list ne "" then 
               call symputx("&prefix._list",cats("(",&prefix._list,")"));
            else 
               call symputx("&prefix._list"," ");
         end;
      run;
      
   %end;


%mend xlsx2list;
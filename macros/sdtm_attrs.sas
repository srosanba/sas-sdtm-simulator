/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    sdtm_attrs

   PURPOSE:    Apply attributes to SDTM dataset based on stored metadata.

   INPUT:      data=    input dataset name
               domain=  name of SDTM domain
               metalib= libname where metadata is stored
   OUTPUT:     out=     output dataset name

   DETAILS:
   - macro assumes that metadata can be found at &metalib..&domain._meta.
   - no new variables are created. metadata is merely applied to existing variables.
   - pdv is sorted based on SDTM documentation order.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro sdtm_attrs
      (data=
      ,out=
      ,domain=
      ,metalib=meta
      );

   %*--- required parameter checks ---;
   %required(data out)
      
   %*--- break data into two pieces ---;
   %local datalib datamem;
   %if %index(&data,.) %then %do;
      %let datalib = %upcase(%scan(&data,1,.));
      %let datamem = %upcase(%scan(&data,2,.));
   %end;
   %else %do;
      %let datalib = %upcase(work);
      %let datamem = %upcase(&data);
   %end;
   
   %*--- get list of variable names ---;
   %local names;
   proc sql noprint;
      select   quote(upcase(trim(name)))
      into     :names separated by ' '
      from     dictionary.columns
      where    libname = "&datalib"
               and memname = "&datamem"
      ;
      create   table _attr10 as
      select   *
      from     &metalib..&domain._meta
      where    name in (&names)
      ;
   quit;

   %*--- create attributes list and keep list ---;
   %global attrlist keeplist;
   data _null_;
      set _attr10 end=eof;

      length attrlist $2000;
      retain attrlist;
      attrlist = trim(attrlist) || " " || trim(attr);

      length keeplist $2000;
      retain keeplist;
      keeplist = trim(keeplist) || " " || trim(name);

      if eof then do;
         call symputx("attrlist",attrlist);
         call symputx("keeplist",keeplist);
      end;
   run;

   %*--- apply attrlist and keeplist ---;
   data &out;
      attrib &attrlist ;
      set &data;
      keep &keeplist ;
   run;

%mend sdtm_attrs;
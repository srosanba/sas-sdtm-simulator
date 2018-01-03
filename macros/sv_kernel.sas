/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    sv_kernel

   PURPOSE:    A helper macro for both sv_create and sv_xlsx.

   DETAILS:
   - see documentation for sv_create or sv_xlsx for more details.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.
   2017-12-20  Shane Rosanbalm   Update DOMAIN.

*--------------------------------------------------------------------------------------*/

%macro sv_kernel;

   %*--- create some visits ---;
   data _sv_kernel_10;
      %if %nrbquote(&streaminit) ne %str() %then
         call streaminit(&streaminit); ;
      set &dm;
      by usubjid;
      domain = "SV";
      _rfstdtc = input(rfstdtc,yymmdd10.);
      _rfendtc = input(rfendtc,yymmdd10.);
      length visit $100;
      %local i;
      %do i = 1 %to &visit_n;
         visitnum = &&visitnum&i;
         visit = "&&visit&i";
         _reference = input(&&reference&i,yymmdd10.);
         _svstdtc = _reference + &&target&i + round(&&delta&i*rand("NORMAL")/3);
         _svendtc = _svstdtc + &&duration&i - 1;
         svstdtc = put(_svstdtc,yymmdd10.);
         svendtc = put(_svendtc,yymmdd10.);
         svstdy = _svstdtc - _rfstdtc + (_svstdtc >= _rfstdtc);
         svendy = _svendtc - _rfstdtc + (_svendtc >= _rfstdtc);
         output;
      %end;
      format _rfstdtc _rfendtc _reference _svstdtc _svendtc yymmdd10.;
   run;
   
   %*--- output if appropriate ---;
   data &out;
      %if %nrbquote(&streaminit) ne %str() %then
         call streaminit(&streaminit); ;
      set _sv_kernel_10;
      if _rfendtc < _svstdtc then
         delete;
      if _rfendtc = _svstdtc and dthdtc ne "" then
         delete;
      if rand("UNIFORM") < &missingprob then
         delete;
   run;

%mend sv_kernel;
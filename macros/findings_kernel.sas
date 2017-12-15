/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    findings_kernel

   PURPOSE:    A helper macro for both findings_create and findings_xlsx.

   DETAILS:
   - see documentation for findings_create or findings_xlsx for more details.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro findings_kernel;

   %*--- make some formats ---;
   %list2format(fmtname=testcd,list=&testcd_list);
   %list2format(fmtname=test,list=&test_list);
   %list2format(fmtname=stresu,list=&stresu_list);
   
   %*--- process lists ---;
   %list2items(prefix=testcd,list=&testcd_list);
   %list2items(prefix=test,list=&test_list);
   %list2items(prefix=stresu,list=&stresu_list);
   %list2items(prefix=mean,list=&mean_list);
   %list2items(prefix=stddev,list=&stddev_list);
   %list2items(prefix=precision,list=&precision_list);
   %if      (&testcd_n ne &test_n) 
         or (&test_n ne &stresu_n) 
         or (&stresu_n ne &mean_n) 
         or (&mean_n ne &stddev_n) 
         or (&stddev_n ne &precision_n)
         %then %do;
      %put %str(W)ARNING: lists of different lengths!!!;
      %put %str(W)ARNING: &=testcd_n &=test_n &=stresu_n;
      %put %str(W)ARNING: &=mean_n &=stddev_n &=precision_n;
   %end;
   %if %nrbquote(&cat_list) ne %str() %then %do;
      %list2items(prefix=cat,list=&cat_list);
      %if (&testcd_n ne &cat_n) %then %do;
         %put %str(W)ARNING: lists of different lengths!!!;
         %put %str(W)ARNING: &=testcd_n &=cat_n;
      %end;
   %end;
   %if %nrbquote(&scat_list) ne %str() %then %do;
      %list2items(prefix=scat,list=&scat_list);
      %if (&testcd_n ne &scat_n) %then %do;
         %put %str(W)ARNING: lists of different lengths!!!;
         %put %str(W)ARNING: &=testcd_n &=scat_n;
      %end;
   %end;
   %if %nrbquote(&pos_list) ne %str() %then %do;
      %list2items(prefix=pos,list=&pos_list);
      %if (&testcd_n ne &pos_n) %then %do;
         %put %str(W)ARNING: lists of different lengths!!!;
         %put %str(W)ARNING: &=testcd_n &=pos_n;
      %end;
   %end;
   %if %nrbquote(&loc_list) ne %str() %then %do;
      %list2items(prefix=loc,list=&loc_list);
      %if (&testcd_n ne &loc_n) %then %do;
         %put %str(W)ARNING: lists of different lengths!!!;
         %put %str(W)ARNING: &=testcd_n &=loc_n;
      %end;
   %end;
   %if %nrbquote(&lat_list) ne %str() %then %do;
      %list2items(prefix=lat,list=&lat_list);
      %if (&testcd_n ne &lat_n) %then %do;
         %put %str(W)ARNING: lists of different lengths!!!;
         %put %str(W)ARNING: &=testcd_n &=lat_n;
      %end;
   %end;
   %if %nrbquote(&spec_list) ne %str() %then %do;
      %list2items(prefix=spec,list=&spec_list);
      %if (&testcd_n ne &spec_n) %then %do;
         %put %str(W)ARNING: lists of different lengths!!!;
         %put %str(W)ARNING: &=testcd_n &=spec_n;
      %end;
   %end;
   %if %nrbquote(&method_list) ne %str() %then %do;
      %list2items(prefix=method,list=&method_list);
      %if (&testcd_n ne &method_n) %then %do;
         %put %str(W)ARNING: lists of different lengths!!!;
         %put %str(W)ARNING: &=testcd_n &=method_n;
      %end;
   %end;

   %*--- generate structure ---;
   data _findings_kernel_10;
      set &sv;
      by usubjid visitnum;
      %local i;
      %do i = 1 %to &testcd_n;
         &domain.testn = &i;
         &domain.testcd = put(&i,testcd.);
         &domain.test = put(&i,test.);
         &domain.stresu = put(&i,stresu.);
         &domain.dtc = svstdtc;
         &domain.dy = svstdy;
         if visitnum <= &blvisitnum then
            blelig = 1;
         else 
            blelig = 2;
         output;
      %end;
   run;
   
   proc sort data=_findings_kernel_10 out=_findings_kernel_20;
      by usubjid &domain.testn visitnum;
   run;
   
   %*--- generate results ---;
   data _findings_kernel_30;
      %if %nrbquote(&streaminit) ne %str() %then
         call streaminit(&streaminit); ;
      set _findings_kernel_20;
      by usubjid &domain.testn visitnum;
      length &domain.stresc &domain.orres &domain.orresu $25;
      retain &domain.stresn;
      retain &domain.ornrlo &domain.ornrhi &domain.stnrlo &domain.stnrhi;
      %do i = 1 %to &testcd_n;
         if &domain.testn = &i then do;
            if first.&domain.testn then do;
               %*--- start with a value within 3 stddev of the mean --;
               &domain.stresn = rand("NORMAL",&&mean&i,&&stddev&i);
               lower = &&mean&i - 3*&&stddev&i;
               upper = &&mean&i + 3*&&stddev&i;
               do until(lower <= &domain.stresn <= upper);
                  &domain.stresn = rand("NORMAL",&&mean&i,&&stddev&i);
               end;
               %if not %symexist(stnrlo_list) %then %do;
                  &domain.stnrlo = round(lower,&&precision&i);
               %end;
               %if not %symexist(stnrhi_list) %then %do;
                  &domain.stnrhi = round(upper,&&precision&i);
               %end;
            end;
            else do;
               %*--- create a value close to previous ---;
               &domain.stresn = &domain.stresn + (2*&&stddev&i*(rand("UNIFORM")-0.5));
            end;
            &domain.stresn = round(&domain.stresn,&&precision&i);
            &domain.stresc = put(&domain.stresn,best25.-l);
            &domain.orres = &domain.stresc;
            &domain.orresu = &domain.stresu;
            &domain.ornrlo = put(&domain.stnrlo,best.-l);
            &domain.ornrhi = put(&domain.stnrhi,best.-l);
            if .z < &domain.stresn < &domain.stnrlo then
               &domain.nrind = "LOW   ";
            else if .z < &domain.stnrhi < &domain.stresn then
               &domain.nrind = "HIGH  ";
            else if .z < &domain.stnrlo <= &domain.stresn <= &domain.stnrhi then
               &domain.nrind = "NORMAL";
            %if %nrbquote(&cat_list) ne %str() %then %do;
               length &domain.cat $50;
               &domain.cat = "&&cat&i"; 
            %end;
            %if %nrbquote(&scat_list) ne %str() %then %do;
               length &domain.scat $50;
               &domain.scat = "&&scat&i"; 
            %end;
            %if %nrbquote(&pos_list) ne %str() %then %do;
               length &domain.pos $25;
               &domain.pos = "&&pos&i"; 
            %end;
            %if %nrbquote(&loc_list) ne %str() %then %do;
               length &domain.loc $25;
               &domain.loc = "&&loc&i"; 
            %end;
            %if %nrbquote(&lat_list) ne %str() %then %do;
               length &domain.lat $25;
               &domain.lat = "&&lat&i"; 
            %end;
            %if %nrbquote(&spec_list) ne %str() %then %do;
               length &domain.spec $25;
               &domain.spec = "&&spec&i"; 
            %end;
            %if %nrbquote(&method_list) ne %str() %then %do;
               length &domain.method $25;
               &domain.method = "&&method&i"; 
            %end;
         end;
      %end;
      if rand("UNIFORM") < &missingprob then
         delete;
   run;
   
   %*--- tidy up special missing values ---;
   %missing2missing
      (data=_findings_kernel_30
      ,out=_findings_kernel_40
      )
   
   %*--- output data ---;
   data &out;
      set _findings_kernel_40;
      by usubjid &domain.testn blelig visitnum;
      retain &domain.seq;
      if first.&domain.testn then
         &domain.seq = 0;
      &domain.seq + 1;
      if blelig = 1 and last.blelig then
         &domain.blfl = "Y";
   run;
   
%mend findings_kernel;
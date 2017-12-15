/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    dm_init

   PURPOSE:    Create the basic structure of a DM dataset.

   OUTPUT:     out=           a subject-level dataset
   CONFIG:     studyid=       the study id value
               subjid_n=      the number of subjects to create
               subjpart_length=the length of the subject part of the usubjid
               siteid_n=      the number of sites to create
               sitepart_length=the length of the site part of the usubjid
               country_list=  list of valid country values
               country_table= list of country value probabilities (0-1)
               streaminit=    seed to use for streaminit

   DETAILS:      
   - all lists and tables should be specified as comma-separated values enclosed in
     parentheses. e.g., country_list=(USA,CAN,MEX) or country_table=(.3,.3,.4).
   - default values are provided for all parameters; you needn't lift a finger.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro dm_init
      (out=dm10
      ,studyid=%nrbquote(ABC-123)
      ,subjid_n=100
      ,subjpart_length=5
      ,siteid_n=10
      ,sitepart_length=4
      ,country_list=(USA,CAN)
      ,country_table=(.8,.2)
      ,streaminit=&seed
      );

   %*--- break country_list into a format ---;
   %list2format
      (fmtname=country
      ,list=&country_list
      );
   
   %*--- put sites in countries ---;
   data _siteid;
      %if %nrbquote(&streaminit) ne %str() %then
         call streaminit(&streaminit); ;
      do _siteid = 1 to &siteid_n;
         _country = rand("TABLE",%sysfunc(compress(&country_table,%str(()))));
         output;
      end;
   run;
   
   %*--- put subjects in sites ---;
   data _subjid;
      %if %nrbquote(&streaminit) ne %str() %then
         call streaminit(&streaminit); ;
      do _subjid = 1 to &subjid_n;
         _siteid = ceil(&siteid_n*rand("UNIFORM"));
         output;
      end;
   run;
   
   %*--- combine country/site/subject data ---;
   proc sql noprint;
      create   table _dm as
      select   a.*, b._subjid
      from     _siteid as a, 
               _subjid as b
      where    a._siteid = b._siteid
      order by _siteid, _subjid
      ;
   quit;
   
   %*--- some lengths ---;
   data _null_;
      studyid_length = length("&studyid");
      subjid_length = &sitepart_length + 1 + &subjpart_length;
      usubjid_length = studyid_length + 1 + subjid_length;
      call symputx("subjid_length",subjid_length);
      call symputx("usubjid_length",usubjid_length);
   run;
   
   %*--- create final variables ---;
   data &out;
      set _dm;
      studyid = "&studyid";
      domain = "DM";
      country = put(_country,country.);
      siteid = put(_siteid,z&sitepart_length..);
      length subjid $&subjid_length;
      subjid = catx("-",siteid,put(_subjid,z&subjpart_length..));
      length usubjid $&usubjid_length;
      usubjid = catx("-",studyid,subjid);
      keep studyid domain country siteid subjid usubjid;
   run;

%mend dm_init;
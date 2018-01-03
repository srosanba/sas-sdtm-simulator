/*--------------------------------------------------------------------------------------*
   Copyright 2018, Rho, Inc.  All rights reserved. 

   PROGRAM:    dm_create

   PURPOSE:    Create a DM dataset.

   OUTPUT:     out=              a subject-level dataset
   CONFIG:     studyid=          the study id value
               subjid_n=         the number of subjects to create
               subjpart_length=  the length of the subject part of the usubjid
               siteid_n=         the number of sites to create
               sitepart_length=  the length of the site part of the usubjid
               country_list=     list of valid country values
               country_table=    list of country value probabilities (0-1)
               fpfvdt=           first patient first visit date (date9.)
               lpfvdt=           last patient first visit date (date9.)
               screendur=        duration of screening period in days
               treatdur=         duration of treatment period in days
               followupdur=      duration of follow-up period in days
               deathprob=        probability of death (0-1)
               agemin=           minimum subject age
               agemax=           maximum subject age
               sex_list=         list of valid sex values
               sex_table=        list of sex value probabilities (0-1)
               race_list=        list of valid race values
               race_table=       list of race value probabilities (0-1)
               ethnic_list=      list of valid ethnicity values
               ethnic_table=     list of ethnicity value probabilities (0-1)
               streaminit=       seed to use for streaminit

   DETAILS:      
   - all lists and tables should be specified as comma-separated values enclosed in
     parentheses. e.g., country_list=(USA,CAN,MEX) or ethnic_table=(.2,.8).
   - rfstdtc values are evenly distributed across [fpfvdt,lpfvdt].
   - rficdtc values are at rfstdtc - screendur with some UNIFORM noise.
   - rfxendtc values are at rfstdtc + treatdur with some NORMAL noise.
   - rfendtc values are at rfxendtc + followupdur with some NORMAL noise.
   - brthdtc values are at evenly distributed across [agemin,agemax].
   - deaths reset rfxendtc and rfendtc.
   - age calculate naively with 365.25.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2018-01-03  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro dm_create
      (out=
      ,studyid=%nrbquote(ABC-123)
      ,subjid_n=100
      ,subjpart_length=5
      ,siteid_n=10
      ,sitepart_length=4
      ,country_list=(USA,CAN)
      ,country_table=(.8,.2)
      ,fpfvdt=
      ,lpfvdt=
      ,screendur=
      ,treatdur=
      ,followupdur=
      ,deathprob=0
      ,agemin=18
      ,agemax=74
      ,sex_list=(F,M)
      ,sex_table=(.5,.5)
      ,race_list=
         (AMERICAN INDIAN OR ALASKA NATIVE
         ,ASIAN
         ,BLACK OR AFRICAN AMERICAN
         ,NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER
         ,OTHER
         ,WHITE
         )
      ,race_table=(.1,.2,.2,.1,.1,.3)
      ,ethnic_list=(HISPANIC OR LATINO,NOT HISPANIC OR LATINO)
      ,ethnic_table=(.2,.8)
      ,streaminit=&seed
      );

   %*--- required parameter checks ---;
   %required(out studyid subjid_n subjpart_length siteid_n sitepart_length)
   %required(country_list country_table)
   %required(fpfvdt lpfvdt screendur treatdur followupdur)
   %required(sex_list sex_table race_list race_table ethnic_list ethnic_table)
   
   %*--- make some formats ---;
   %list2format(fmtname=country,list=&country_list);
   %list2format(fmtname=sex,list=&sex_list);
   %list2format(fmtname=race,list=&race_list);
   %list2format(fmtname=ethnic,list=&ethnic_list);
      
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
      create   table _dm10 as
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
   
   %*--- add high-level identifiers ---;
   data _dm20;
      set _dm10;
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

   %*--- create some dates ---;
   data _dm30;
      %if %nrbquote(&streaminit) ne %str() %then
         call streaminit(&streaminit); ;
      set _dm20;
      
      %*--- numeric date variables ---;
      _rfstdtc = "&fpfvdt"d + round(("&lpfvdt"d - "&fpfvdt"d)*rand("UNIFORM"));
      _rficdtc = _rfstdtc - &screendur + round(rand("UNIFORM"));
      _rfxendtc = _rfstdtc + &treatdur + round(rand("NORMAL"));
      _rfendtc = _rfxendtc + &followupdur + round(rand("NORMAL"));
      _brthdtc = _rfstdtc - round(365.25*(&agemin+(&agemax-&agemin)*rand("UNIFORM")));
      
      %*--- death ---;
      if rand("UNIFORM") < &deathprob then do;
         _dthdtc = _rfstdtc + round((_rfendtc-_rfstdtc)*rand("UNIFORM"));
         _rfxendtc = _dthdtc;
         _rfendtc = _dthdtc;
      end;
      
      %*--- convert date variables to character/iso8601 ---;
      rficdtc = put(_rficdtc,yymmdd10.);
      rfstdtc = put(_rfstdtc,yymmdd10.);
      rfxendtc = put(_rfxendtc,yymmdd10.);
      rfendtc = put(_rfendtc,yymmdd10.);
      if n(_dthdtc) then
         dthdtc = put(_dthdtc,yymmdd10.);
      brthdtc = put(_brthdtc,yymmdd10.);
      
      %*--- age ---;
      age = round((_rfstdtc-_brthdtc)/365.25);
      ageu = "YEARS";
      
   run;

   %*--- create some variables ---;
   data &out;
      %if %nrbquote(&streaminit) ne %str() %then
         call streaminit(&streaminit); ;
      set _dm30;      
      %*--- sex ---;
      _sex = rand("TABLE",%sysfunc(compress(&sex_table,%str(()))));
      sex = put(_sex,sex.);      
      %*--- race ---;
      _race = rand("TABLE",%sysfunc(compress(&race_table,%str(()))));
      race = put(_race,race.);      
      %*--- ethnic ---;
      _ethnic = rand("TABLE",%sysfunc(compress(&ethnic_table,%str(()))));
      ethnic = put(_ethnic,ethnic.);
   run;

%mend dm_create;
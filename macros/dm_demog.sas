/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    dm_demog

   PURPOSE:    Add demographic variables to DM dataset.

   INPUT:      data=          a subject-level dataset, created by %dm_init
   OUTPUT:     out=           a subject-level dataset with demographic variables added
   CONFIG:     sex_list=      list of valid sex values
               sex_table=     list of sex value probabilities (0-1)
               race_list=     list of valid race values
               race_table=    list of race value probabilities (0-1)
               ethnic_list=   list of valid ethnicity values
               ethnic_table=  list of ethnicity value probabilities (0-1)
               streaminit=    seed to use for streaminit

   DETAILS:      
   - all lists and tables should be specified as comma-separated values enclosed in
     parentheses. e.g., sex_list=(F,M) or ethnic_table=(.2,.8).
   - default values are provided for all list/table pairs; you needn't lift a finger.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro dm_demog
      (data=
      ,out=
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
   %required(data out)

   %*--- make some formats ---;
   %list2format(fmtname=sex,list=&sex_list);
   %list2format(fmtname=race,list=&race_list);
   %list2format(fmtname=ethnic,list=&ethnic_list);
      
   %*--- create some variables ---;
   data &out;
      %if %nrbquote(&streaminit) ne %str() %then
         call streaminit(&streaminit); ;
      set &data;      
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
      
%mend dm_demog;
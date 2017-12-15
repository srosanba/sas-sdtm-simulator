/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    dm_dates

   PURPOSE:    Add date variables to DM dataset.

   INPUT:      data=       a subject-level dataset, created by %dm_init
   OUTPUT:     out=        a subject-level dataset with date variables added
   CONFIG:     fpfvdt=     first patient first visit date (date9.)
               lpfvdt=     last patient first visit date (date9.)
               screendur=  duration of screening period in days
               treatdur=   duration of treatment period in days
               followupdur=duration of follow-up period in days
               deathprob=  probability of death (0-1)
               agemin=     minimum subject age
               agemax=     maximum subject age
               streaminit= seed to use for streaminit

   DETAILS:      
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
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro dm_dates
      (data=
      ,out=
      ,fpfvdt=
      ,lpfvdt=
      ,screendur=
      ,treatdur=
      ,followupdur=
      ,deathprob=0
      ,agemin=18
      ,agemax=74
      ,streaminit=&seed
      );

   %*--- required parameter checks ---;
   %required(data out fpfvdt lpfvdt screendur treatdur followupdur)
      
   %*--- create some dates ---;
   data &out;
      %if %nrbquote(&streaminit) ne %str() %then
         call streaminit(&streaminit); ;
      set &data;
      
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
      
%mend dm_dates;
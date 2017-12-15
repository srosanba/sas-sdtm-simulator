/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    events_create

   PURPOSE:    Create the basic structure of an events dataset.

   INPUT:      dm=            a DM dataset
               domain=        the type of events domain to create (e.g., AE)
               meddra=        the events database from which to sample
   OUTPUT:     out=           an events dataset
   CONFIG:     events_pre=    poisson parameter for number of screening events
               events_during= poisson parameter for number of treatment events
               events_post=   poisson parameter for number of follow-up events
               duration=      poisson parameter for duration of each event in days
               ongoingprob=   probability than an event is ongoing
               aesev_list=    list of valid severity values
               aesev_table=   list of severity value probabilities (0-1)
               aeacn_list=    list of valid action values
               aeacn_table=   list of action value probabilities (0-1)
               aerel_list=    list of valid relationship values
               aerel_table=   list of relationship value probabilities (0-1)
               aeout_list=    list of valid outcome values
               aeout_table=   list of outcome value probabilities (0-1)
               aecontrt_list= list of valid concomitant treatment values
               aecontrt_table=list of concomitant treatment value probabilities (0-1)
               aetoxgr_list=  list of valid toxicity grade values
               aetoxgr_table= list of toxicity grade value probabilities (0-1)
               aeserprob=     probability that event is serious
               aescanprob=    probability that SAE involves cancer
               aescongprob=   probability that SAE is congenital anomaly
               aesdisabprob=  probability that SAE caused a disability
               aeshospprob=   probability that SAE resulted in hospitalization
               aeslifeprob=   probability that SAE was life threatening
               aesodprob=     probability that SAE was an overdose
               aesmieprob=    probability that SAE was other medically important event
               streaminit=    seed to use for streaminit

   DETAILS:
   - the domain parameter is (currently) misleading. in the future this macro may 
     support other datasets, but at present it can only produce an AE dataset. 
   - all lists and tables should be specified as comma-separated values enclosed in
     parentheses. e.g., aesev_table=(.3,.3,.4).
   - default values are provided for most parameters; modify as you see fit.
   - events are sampled from a set of NIDA study databases.
   - event start dates are evenly distrubuted across the respective periods.
   - event end dates are based on duration.
   - DM.DTHDTC impacts values for AEENDTC, AESEV, AESER, AEACN, AEOUT, AETOXGR, AESDTH.
   - AESMIE is used as a catch-all if no other AES* variable is flagged.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro events_create
      (dm=
      ,domain=
      ,meddra=meta.aeselect
      ,out=
      ,events_pre=0.5
      ,events_during=4
      ,events_post=0.1
      ,duration=4
      ,ongoingprob=.10
      ,aesev_list=(MILD,MODERATE,SEVERE)
      ,aesev_table=(.65,.30,.05)
      ,aeacn_list=(DOSE INCREASED,DOSE NOT CHANGED,DOSE REDUCED,DRUG INTERRUPTED
         ,DRUG WITHDRAWN,NOT APPLICABLE)
      ,aeacn_table=(.01,.90,.01,.06,.01,.01)
      ,aerel_list=(NOT RELATED,UNLIKELY RELATED,POSSIBLY RELATED,RELATED)
      ,aerel_table=(.40,.30,.20,.10)
      ,aeout_list=(FATAL,NOT RECOVERED/NOT RESOLVED,RECOVERED/RESOLVED
         ,RECOVERED/RESOLVED WITH SEQUELAE,RECOVERING/RESOLVING,UNKNOWN)
      ,aeout_table=(.01,.05,.90,.02,.01,.01)
      ,aecontrt_list=(Y,N)
      ,aecontrt_table=(.50,.50)
      ,aetoxgr_list=(1,2,3,4,5)
      ,aetoxgr_table=(.50,.25,.20,.04,.01)
      ,aeserprob=0.1
      ,aescanprob=0.01
      ,aescongprob=0.01
      ,aesdisabprob=0.01
      ,aeshospprob=0.02
      ,aeslifeprob=0.02
      ,aesodprob=0.01
      ,aesmieprob=0.01
      ,streaminit=&seed
      );

   %*--- required parameter checks ---;
   %required(dm domain meddra out)
   %required(events_pre events_during events_post)
   %required(aesev_list aesev_table aeacn_list aeacn_table aerel_list aerel_table)
   %required(aeout_list aeout_table aecontrt_list aecontrt_table)
   %required(aetoxgr_list aetoxgr_table)
   %required(aeserprob aescanprob aescongprob aesdisabprob)
   %required(aeshospprob aeslifeprob aesodprob aesmieprob)
   
   %*--- make some formats ---;
   %list2format(fmtname=aesev,list=&aesev_list)
   %list2format(fmtname=aeacn,list=&aeacn_list)
   %list2format(fmtname=aerel,list=&aerel_list)
   %list2format(fmtname=aeout,list=&aeout_list)
   %list2format(fmtname=aecontrt,list=&aecontrt_list)
   %list2format(fmtname=aetoxgr,list=&aetoxgr_list)
   
   %local meddra_n;
   %let meddra_n = %nobs(&meddra);

   %*--- build shell on which to merge events ---;
   data _events_10;
      call streaminit(8675309);
      set sdtm.dm;
      events_pre = rand("POISSON",&events_pre);
      events_during = rand("POISSON",&events_during);
      events_post = rand("POISSON",&events_post);
      if events_pre > 0 then do pre = 1 to events_pre;
         aeselect = round(&meddra_n*rand("UNIFORM"));
         output;
      end;
      pre = .;
      if events_during > 0 then do during = 1 to events_during;
         aeselect = round(&meddra_n*rand("UNIFORM"));
         output;
      end;
      during = .;
      if events_post > 0 then do post = 1 to events_post;
         aeselect = round(&meddra_n*rand("UNIFORM"));
         output;
      end;
      post = .;
   run;
   
   proc sort data=_events_10 out=_events_20;
      by aeselect;
   run;
   
   %*--- merge events onto shell ---;
   data _events_30;
      call streaminit(8675309);
      merge _events_20 (in=a) meta.aeselect;
      by aeselect;
      if a;
      *--- look-up tables ---;
      _aesev = rand("TABLE",%sysfunc(compress(&aesev_table,%str(()))));
      aesev = put(_aesev,aesev.);
      _aeacn = rand("TABLE",%sysfunc(compress(&aeacn_table,%str(()))));
      aeacn = put(_aeacn,aeacn.);
      _aerel = rand("TABLE",%sysfunc(compress(&aerel_table,%str(()))));
      aerel = put(_aerel,aerel.);
      _aeout = rand("TABLE",%sysfunc(compress(&aeout_table,%str(()))));
      aeout = put(_aeout,aeout.);
      _aecontrt = rand("TABLE",%sysfunc(compress(&aecontrt_table,%str(()))));
      aecontrt = put(_aecontrt,aecontrt.);
      _aetoxgr = rand("TABLE",%sysfunc(compress(&aetoxgr_table,%str(()))));
      aetoxgr = put(_aetoxgr,aetoxgr.);
      *--- sae probabilities ---;
      if rand("UNIFORM") < &aeserprob then do;
         aeser = "Y";
         if rand("UNIFORM") < &aescanprob/&aeserprob then
            aescan = "Y";
         if rand("UNIFORM") < &aescongprob/&aeserprob then
            aescong = "Y";
         if rand("UNIFORM") < &aesdisabprob/&aeserprob then
            aesdisab = "Y";
         if rand("UNIFORM") < &aeshospprob/&aeserprob then
            aeshosp = "Y";
         if rand("UNIFORM") < &aeslifeprob/&aeserprob then
            aeslife = "Y";
         if rand("UNIFORM") < &aesodprob/&aeserprob then
            aesod = "Y";
         if rand("UNIFORM") < &aesmieprob/&aeserprob then
            aesmie = "Y";
         if aescan = aescong = aesdisab = aeshosp = aeslife = aesod = aesmie = "" then
            aesmie = "Y";
      end;
      *--- start/end dates ---;
      _rficdtc = input(rficdtc,yymmdd10.);
      _rfstdtc = input(rfstdtc,yymmdd10.);
      _rfxendtc = input(rfxendtc,yymmdd10.);
      _rfendtc = input(rfendtc,yymmdd10.);
      _dthdtc = input(dthdtc,yymmdd10.);
      if n(pre) then 
         _aestdtc = _rficdtc + round(rand("UNIFORM")*(_rfstdtc-_rficdtc));
      else if n(during) then 
         _aestdtc = _rfstdtc + round(rand("UNIFORM")*(_rfxendtc-_rfstdtc));
      else if n(post) then 
         _aestdtc = _rfxendtc + round(rand("UNIFORM")*(_rfendtc-_rfxendtc));
      _aeendtc = _aestdtc + rand("POISSON",&duration);
      if .z < _dthdtc < _aeendtc then 
         _aeendtc = _dthdtc;
      aestdtc = put(_aestdtc,yymmdd10.);
      aeendtc = put(_aeendtc,yymmdd10.);
      *--- death ---;
      if _dthdtc = _aeendtc then do;
         aesev = "SEVERE";
         aeser = "Y";
         aeacn = "DRUG WITHDRAWN";
         aeout = "FATAL";
         aetoxgr = "5";
         aesdth = "Y";
      end;
      *--- ongoing ---;
      if rand("UNIFORM") < &ongoingprob and aesdth ne "Y" then do;
         aeenrf = "ONGOING";
         aeendtc = "";
      end;
      format _rf: _dt: _ae: yymmdd10.;
   run;
   
   %*--- output data ---;
   proc sort data=_events_30 out=_events_40;
      by usubjid aestdtc aeendtc;
   run;
   
   data &out;
      set _events_40;
      by usubjid;
      retain aeseq;
      if first.usubjid then
         aeseq = 0;
      aeseq + 1;
   run;
   
%mend events_create;
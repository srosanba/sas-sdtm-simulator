/*--------------------------------------------------------------------------------------*
   Copyright 2017, Rho, Inc.  All rights reserved. 

   PROGRAM:    sv_create

   PURPOSE:    Create the basic structure of a study visits dataset.

   INPUT:      dm=            a DM dataset
   OUTPUT:     out=           a study visits dataset
   CONFIG:     visitnum_list= list of visit numbers
               visit_list=    list of visit names
               reference_list=list of reference date variables
               target_list=   list of target days relative to reference date
               delta_list=    list of windows around target
               duration_list= list of durations
               missingprob=   probability of a missing value
               streaminit=    seed to use for streaminit

   DETAILS:
   - the macro produces visits for the SV dataset. 
   - all lists should be specified as comma-separated values enclosed in parentheses. 
     e.g., visit_list=(Screening,Baseline,Week 1,Month 1,End of Study,Follow-up).
   - list values are correlated. that is, the first item in visitnum_list is paired
     with the first item in visit_list and the first item in reference_list and so on.
   - visit dates are calculated as reference + target +/- some NORMAL noise 
     scaled by delta.
   - DM.RFENDTC and DM.DTHDTC act as caps on generated visit dates.
                  
   PROGRAM HISTORY:
   DATE        PROGRAMMER        DESCRIPTION
   ---------   ---------------   ------------------------------------------------------
   2017-12-15  Shane Rosanbalm   Create.

*--------------------------------------------------------------------------------------*/

%macro sv_create
      (dm=
      ,out=
      ,visitnum_list=
      ,visit_list=
      ,reference_list=
      ,target_list=
      ,delta_list=
      ,duration_list=
      ,missingprob=0
      ,streaminit=&seed
      );

   %*--- required parameter checks ---;
   %required(dm out)
      
   %*--- process lists ---;
   %list2items(prefix=visitnum,list=&visitnum_list);
   %list2items(prefix=visit,list=&visit_list);
   %list2items(prefix=reference,list=&reference_list);
   %list2items(prefix=target,list=&target_list);
   %list2items(prefix=delta,list=&delta_list);
   %list2items(prefix=duration,list=&duration_list);
   %if (&visitnum_n ne &visit_n) 
         or (&visit_n ne &reference_n) 
         or (&reference_n ne &target_n) 
         or (&target_n ne &delta_n) 
         or (&delta_n ne &duration_n)
         %then %do;
      %put %str(W)ARNING: lists of different lengths!!!;
      %put %str(W)ARNING: &=visitnum_n &=visit_n &=reference_n;
      %put %str(W)ARNING: &=target_n &=delta_n &=duration_n;
   %end;

   %*--- call the kernel ---;
   %sv_kernel
   
%mend sv_create;
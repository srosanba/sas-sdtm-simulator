%let path = H:\GitHub\srosanba\sas-sdtm-simulator\examples;

%sysmacdelete sv_create / nowarn;
%sysmacdelete required / nowarn;
%sysmacdelete list2items / nowarn;
%sysmacdelete sv_kernel / nowarn;
%sysmacdelete sdtm_attrs / nowarn;

options mprint sasautos=("&path/macros" sasautos);

libname sdtm "&path/data";
libname meta "&path/meta" access=readonly;

%let seed = 8675309;

*---------- create visits ----------;
%sv_create
   (dm=sdtm.dm
   ,out=sv10
   ,visitnum_list=
      (1
      ,2
      ,3
      ,4
      ,5
      ,6
      ,7
      )
   ,visit_list=
      (Screening
      ,Baseline
      ,Week 1
      ,Month 1
      ,Month 3
      ,End of Treatment
      ,End of Study
      )
   ,reference_list=
      (rficdtc
      ,rfstdtc
      ,rfstdtc
      ,rfstdtc
      ,rfstdtc
      ,rfxendtc
      ,rfendtc
      )
   ,target_list=
      (0
      ,0
      ,7
      ,28
      ,84
      ,0
      ,0
      )
   ,delta_list=
      (0
      ,0
      ,1
      ,2
      ,3
      ,3
      ,0
      )
   ,duration_list=
      (1
      ,1
      ,1
      ,1
      ,1
      ,1
      ,1
      )
   ,missingprob=0.05
   );

*---------- finalize attributes ----------;
%sdtm_attrs
   (data=sv10
   ,out=sdtm.sv
   ,domain=sv
   );


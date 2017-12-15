%let path = H:\GitHub\srosanba\sas-sdtm-simulator;

%sysmacdelete findings_create / nowarn;
%sysmacdelete required / nowarn;
%sysmacdelete list2format / nowarn;
%sysmacdelete list2items / nowarn;
%sysmacdelete missing2missing / nowarn;
%sysmacdelete findings_kernel / nowarn;
%sysmacdelete sdtm_attrs / nowarn;

options mprint sasautos=("&path/macros" sasautos);

libname sdtm "&path/data";
libname meta "&path/meta" access=readonly;

%let seed = 8675309;


*---------- create findings ----------;
%findings_create
   (sv=sdtm.sv
   ,domain=eg
   ,out=eg10
   ,testcd_list=
      (QRSAG
      ,PRAG
      ,QTAG
      )
   ,test_list=
      (QRS Duration
      ,PR Interval
      ,QT Interval
      )
   ,stresu_list=
      (msec
      ,msec
      ,msec
      )
   ,mean_list=
      (75
      ,125
      ,340
      )
   ,stddev_list=
      (15
      ,15
      ,30
      )
   ,precision_list=
      (1
      ,1
      ,1
      )
   ,blvisitnum=2
   ,missingprob=0.01
   );

*---------- clean up EGTEST values ----------;
data eg20;
   length egtest $50;
   set eg10;
   egtest = trim(egtest) || ", Aggregate";
run;

*---------- finalize attributes ----------;
%sdtm_attrs
   (data=eg20
   ,out=sdtm.eg
   ,domain=eg
   );


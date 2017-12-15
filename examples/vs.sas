%let path = H:\GitHub\srosanba\sas-sdtm-simulator\examples;

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
   ,domain=vs
   ,out=vs10
   ,testcd_list=
      (SYSBP
      ,DIABP
      ,TEMP
      )
   ,test_list=
      (Systolic Blood Pressure
      ,Diastolic Blood Pressure
      ,Temperature
      )
   ,stresu_list=
      (mmHg
      ,mmHg
      ,C
      )
   ,mean_list=
      (140
      ,90
      ,37
      )
   ,stddev_list=
      (15
      ,10
      ,0.2
      )
   ,precision_list=
      (1
      ,1
      ,0.1
      )
   ,pos_list=
      (SITTING
      ,SITTING
      ,missing
      )
   ,lat_list=
      (LEFT
      ,LEFT
      ,missing
      )
   ,blvisitnum=2
   ,missingprob=0.01
   );

*---------- finalize attributes ----------;
%sdtm_attrs
   (data=vs10
   ,out=sdtm.vs
   ,domain=vs
   );


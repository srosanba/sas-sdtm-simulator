%let path = H:\GitHub\srosanba\sas-sdtm-simulator\examples;

%sysmacdelete events_create / nowarn;
%sysmacdelete required / nowarn;
%sysmacdelete list2format / nowarn;
%sysmacdelete sdtm_attrs / nowarn;

options mprint sasautos=("&path/macros" sasautos);

libname sdtm "&path/data";
libname meta "&path/meta" access=readonly;

%let seed = 8675309;


*---------- create events ----------;
%events_create
   (dm=sdtm.dm
   ,domain=ae
   ,meddra=meta.aeselect
   ,out=ae10
   ,events_pre=0.2
   ,events_during=2
   ,events_post=0.1
   ,duration=4
   ,aesev_table=(.65,.20,.15)
   ,aeserprob=.10
   ,aeshospprob=.05
   );

*---------- finalize attributes ----------;
%sdtm_attrs
   (data=ae10
   ,out=sdtm.ae
   ,domain=ae
   );




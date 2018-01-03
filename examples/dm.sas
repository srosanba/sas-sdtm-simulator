%let path = H:\GitHub\srosanba\sas-sdtm-simulator;

%sysmacdelete list2format / nowarn;
%sysmacdelete required / nowarn;
%sysmacdelete dm_create / nowarn;
%sysmacdelete sdtm_attrs / nowarn;

options mprint sasautos=("&path/macros" sasautos);

libname sdtm "&path/data";
libname meta "&path/meta" access=readonly;

%let seed = 8675309;



*--------------------------------------------------------------------------------;
*---------- build dataset through several small macro calls ----------;
*--------------------------------------------------------------------------------;

*---------- create dm dataset ----------;
%dm_create
   (out=dm10
   ,subjid_n=40
   ,siteid_n=5
   ,country_list=(USA,CAN,MEX)
   ,country_table=(.6,.2,.2)
   ,fpfvdt=01oct2016
   ,lpfvdt=01apr2017
   ,screendur=3
   ,treatdur=182
   ,followupdur=28
   ,deathprob=0.05
   ,sex_table=(.6,.4)
   );

*---------- finalize attributes ----------;
%sdtm_attrs
   (data=dm10
   ,out=sdtm.dm
   ,domain=dm
   );



*--------------------------------------------------------------------------------;
*---------- troubleshoot ----------;
*--------------------------------------------------------------------------------;


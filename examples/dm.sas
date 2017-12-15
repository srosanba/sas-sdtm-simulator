%let path = H:\GitHub\srosanba\sas-sdtm-simulator\examples;

%sysmacdelete list2format / nowarn;
%sysmacdelete required / nowarn;
%sysmacdelete dm_init / nowarn;
%sysmacdelete dm_dates / nowarn;
%sysmacdelete dm_demog / nowarn;
%sysmacdelete sdtm_attrs / nowarn;

options mprint sasautos=("&path/macros" sasautos);

libname sdtm "&path/data";
libname meta "&path/meta" access=readonly;

%let seed = 8675309;



*--------------------------------------------------------------------------------;
*---------- build dataset through several small macro calls ----------;
*--------------------------------------------------------------------------------;

*---------- create subjects ----------;
%dm_init
   (out=dm10
   ,subjid_n=40
   ,siteid_n=5
   ,country_list=(USA,CAN,MEX)
   ,country_table=(.6,.2,.2)
   );

*---------- add date variables ----------;
%dm_dates
   (data=dm10
   ,out=dm20
   ,fpfvdt=01oct2016
   ,lpfvdt=01apr2017
   ,screendur=3
   ,treatdur=182
   ,followupdur=28
   ,deathprob=0.05
   );

*---------- add demog variables ----------;
%dm_demog
   (data=dm20
   ,out=dm30
   ,sex_table=(.6,.4)
   );

*---------- finalize attributes ----------;
%sdtm_attrs
   (data=dm30
   ,out=sdtm.dm
   ,domain=dm
   );



*--------------------------------------------------------------------------------;
*---------- troubleshoot ----------;
*--------------------------------------------------------------------------------;


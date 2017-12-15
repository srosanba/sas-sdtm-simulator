%let path = H:\GitHub\srosanba\sas-sdtm-simulator;

%sysmacdelete sv_xlsx / nowarn;
%sysmacdelete required / nowarn;
%sysmacdelete sv_kernel / nowarn;
%sysmacdelete sdtm_attrs / nowarn;

options mprint sasautos=("&path/macros" sasautos);

libname sdtm "&path/data";
libname meta "&path/meta" access=readonly;

%let seed = 8675309;


*---------- create visits ----------;
%sv_xlsx
   (dm=sdtm.dm
   ,out=sv10
   ,xlsx=%nrbquote(&path/sv.xlsx)
   ,missingprob=0.05
   );

*---------- finalize attributes ----------;
%sdtm_attrs
   (data=sv10
   ,out=sdtm.sv
   ,domain=sv
   );


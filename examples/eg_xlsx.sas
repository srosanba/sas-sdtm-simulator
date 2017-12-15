%let path = H:\GitHub\srosanba\sas-sdtm-simulator\examples;

%sysmacdelete findings_xlsx / nowarn;
%sysmacdelete required / nowarn;
%sysmacdelete xlsx2list / nowarn;
%sysmacdelete findings_kernel / nowarn;
%sysmacdelete sdtm_attrs / nowarn;

options mprint sasautos=("&path/macros" sasautos);

libname sdtm "&path/data";
libname meta "&path/meta" access=readonly;

%let seed = 8675309;


*---------- create visits ----------;
%findings_xlsx
   (sv=sdtm.sv
   ,domain=eg
   ,out=eg10
   ,xlsx=%nrbquote(&path/eg.xlsx)
   ,blvisitnum=2
   ,missingprob=0.05
   );

*---------- finalize attributes ----------;
%sdtm_attrs
   (data=eg10
   ,out=sdtm.eg
   ,domain=eg
   );


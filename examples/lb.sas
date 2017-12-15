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
   ,domain=lb
   ,out=lb10
   ,testcd_list=
      (BILI
      ,CREAT
      ,WBC
      )
   ,test_list=
      (Bilirubin
      ,Creatinine
      ,Leukocytes
      )
   ,stresu_list=
      (mg/dL
      ,mg/dL
      ,x10^3 c/uL
      )
   ,mean_list=
      (7
      ,33
      ,1.7
      )
   ,stddev_list=
      (2
      ,10
      ,0.5
      )
   ,precision_list=
      (1
      ,1
      ,0.1
      )
   ,cat_list=
      (LIVER & KIDNEY FUNCTION
      ,LIVER & KIDNEY FUNCTION
      ,HEMATOLOGY II
      )
   ,scat_list=
      (LIVER FUNCTION TESTS
      ,KIDNEY FUNCTION TESTS
      ,QUANTITATIVE WBC
      )
   ,spec_list=
      (SERUM
      ,SERUM
      ,SERUM
      )
   ,blvisitnum=2
   ,missingprob=0.01
   );

*---------- finalize attributes ----------;
%sdtm_attrs
   (data=lb10
   ,out=sdtm.lb
   ,domain=lb
   );


%let path = H:\GraphicsGroup\dummy\sdtm\r-style\meta;

libname meta "&path";



*--------------------------------------------------------------------------------;
*---------- metadata ----------;
*--------------------------------------------------------------------------------;

data meta.lb_meta;
   input name $ 1-8 type $ 10-13 length $ 16-18 label $ 22-61;
   length attr $100;
   attr = trim(name) || " label='" || trim(label) || "' length=";
   if type = "char" then
      attr = trim(attr) || "$";
   attr = trim(attr) || trim(length);
*--------1---------2---------3---------4---------5---------6-;
datalines;
STUDYID  char  25    Study Identifier
DOMAIN   char  2     Domain Abbreviation
USUBJID  char  25    Unique Subject Identifier
LBSEQ    num   8     Sequence Number
LBGRPID  char  25    Group ID
LBREFID  char  25    Specimen ID
LBSPID   char  25    Sponsor-Defined Identifier
LBTESTCD char  8     Lab Test or Examination Short Name
LBTEST   char  50    Lab Test or Examination Name
LBCAT    char  50    Category for Lab Test
LBSCAT   char  50    Subcategory for Lab Test
LBORRES  char  25    Result or Finding in Original Units
LBORRESU char  25    Original Units
LBORNRLO char  25    Reference Range Lower Limit in Orig Unit
LBORNRHI char  25    Reference Range Upper Limit in Orig Unit
LBSTRESC char  25    Character Result/Finding in Std Format
LBSTRESN num   8     Numeric Result/Finding in Standard Units
LBSTRESU char  25    Standard Units
LBSTNRLO num   8     Reference Range Lower Limit-Std Units
LBSTNRHI num   8     Reference Range Upper Limit-Std Units
LBSTNRC  char  25    Reference Range for Char Rslt-Std Units
LBNRIND  char  25    Reference Range Indicator
LBSTAT   char  25    Completion Status
LBREASND char  200   Reason Test Not Done
LBNAM    char  200   Vendor Name
LBLOINC  char  50    LOINC Code
LBSPEC   char  50    Specimen Type
LBSPCCND char  50    Specimen Condition
LBMETHOD char  50    Method of Test or Examination
LBBLFL   char  1     Baseline Flag
LBFAST   char  1     Fasting Status
LBDRVFL  char  1     Derived Flag
LBTOX    char  25    Toxicity
LBTOXGR  char  25    Standard Toxicity Grade
VISITNUM num   8     Visit Number
VISIT    char  100   Visit Name
VISITDY  num   8     Planned Study Day of Visit
LBDTC    char  19    Date/Time of Measurement
LBENDTC  char  19    End Date/Time of Specimen Collection
LBDY     num   8     Study Day of Specimen Collection
LBTPT    char  25    Planned Time Point Name
LBTPTNUM num   8     Planned Time Point Number
LBELTM   char  19    Planned Elapsed Time from Time Point Ref
LBTPTREF char  25    Time Point Reference
LBRFTDTC char  19    Date/Time of Reference Time Point
;
run;




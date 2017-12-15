%let path = H:\GraphicsGroup\dummy\sdtm\r-style\meta;

libname meta "&path";



*--------------------------------------------------------------------------------;
*---------- metadata ----------;
*--------------------------------------------------------------------------------;

data meta.eg_meta;
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
EGSEQ    num   8     Sequence Number
EGGRPID  char  25    Group ID
EGREFID  char  25    ECG Reference ID
EGSPID   char  25    Sponsor-Defined Identifier
EGTESTCD char  8     ECG Test or Examination Short Name
EGTEST   char  50    ECG Test or Examination Name
EGCAT    char  50    Category for ECG
EGSCAT   char  50    Subcategory for ECG
EGPOS    char  25    ECG Position of Subject
EGORRES  char  25    Result or Finding in Original Units
EGORRESU char  25    Original Units
EGSTRESC char  25    Character Result/Finding in Std Format
EGSTRESN num   8     Numeric Result/Finding in Standard Units
EGSTRESU char  25    Standard Units
EGSTAT   char  25    Completion Status
EGREASND char  200   Reason ECG Not Performed
EGFXN    char  200   ECG External File Path
EGNAM    char  200   Vendor Name
EGLEAD   char  50    Lead Location Used for Measurement
EGMETHOD char  50    Method of ECG Test
EGBLFL   char  1     Baseline Flag
EGDRVFL  char  1     Derived Flag
EGEVAL   char  200   Evaluator
VISITNUM num   8     Visit Number
VISIT    char  100   Visit Name
VISITDY  num   8     Planned Study Day of Visit
EGDTC    char  19    Date/Time of ECG
EGDY     num   8     Study Day of ECG
EGTPT    char  25    Planned Time Point Name
EGTPTNUM num   8     Planned Time Point Number
EGELTM   char  19    Planned Elapsed Time from Time Point Ref
EGTPTREF char  25    Time Point Reference
EGRFTDTC char  19    Date/Time of Reference Time Point
;
run;




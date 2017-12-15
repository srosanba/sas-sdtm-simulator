%let path = H:\GraphicsGroup\dummy\sdtm\r-style\meta;

libname meta "&path";



*--------------------------------------------------------------------------------;
*---------- metadata ----------;
*--------------------------------------------------------------------------------;

data meta.vs_meta;
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
VSSEQ    num   8     Sequence Number
VSGRPID  char  25    Group ID
VSSPID   char  25    Sponsor-Defined Identifier
VSTESTCD char  8     Vital Signs Test Short Name
VSTEST   char  50    Vital Signs Test Name
VSCAT    char  50    Category for Vital Signs
VSSCAT   char  50    Subcategory for Vital Signs
VSPOS    char  25    Vital Signs Position of Subject
VSORRES  char  25    Result or Finding in Original Units
VSORRESU char  25    Original Units
VSSTRESC char  25    Character Result/Finding in Std Format
VSSTRESN num   8     Numeric Result/Finding in Standard Units
VSSTRESU char  25    Standard Units
VSSTAT   char  25    Completion Status
VSREASND char  200   Reason Not Peformed
VSLOC    char  25    Location of Vital Signs Measurement
VSLAT    char  25    Laterality
VSBLFL   char  1     Baseline Flag
VSDRVFL  char  1     Derived Flag
VISITNUM num   8     Visit Number
VISIT    char  100   Visit Name
VISITDY  num   8     Planned Study Day of Visit
VSDTC    char  19    Date/Time of Measurement
VSDY     num   8     Study Day of Vital Signs
VSTPT    char  25    Planned Time Point Name
VSTPTNUM num   8     Planned Time Point Number
VSELTM   char  19    Planned Elapsed Time from Time Point Ref
VSTPTREF char  25    Time Point Reference
VSRFTDTC char  19    Date/Time of Reference Time Point
;
run;




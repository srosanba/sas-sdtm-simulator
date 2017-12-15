%let path = H:\GraphicsGroup\dummy\sdtm\r-style\meta;

libname meta "&path";



*--------------------------------------------------------------------------------;
*---------- metadata ----------;
*--------------------------------------------------------------------------------;

data meta.sv_meta;
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
VISITNUM num   8     Visit Number
VISIT    char  100   Visit Name
VISITDY  num   8     Planned Study Day of Visit
SVSTDTC  char  19    Start Date/Time of Visit
SVENDTC  char  19    End Date/Time of Visit
SVSTDY   num   8     Study Day of Start of Visit
SVENDY   num   8     Study Day of End of Visit
SVUPDES  char  100   Description of Unplanned Visit
;
run;




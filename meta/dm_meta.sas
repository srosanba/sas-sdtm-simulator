%let path = H:\GraphicsGroup\dummy\sdtm\r-style\meta;

libname meta "&path";



*--------------------------------------------------------------------------------;
*---------- metadata ----------;
*--------------------------------------------------------------------------------;

data meta.dm_meta;
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
SUBJID   char  25    Subject Identifier for the Study
RFSTDTC  char  19    Subject Reference Start Date/Time
RFENDTC  char  19    Subject Reference End Date/Time
RFXSTDTC char  19    Date/Time of First Study Tretment
RFXENDTC char  19    Date/Time of Last Study Tretment
RFICDTC  char  19    Date/Time of Informed Consent
RFPENDTC char  19    Date/Time of End of Participation
DTHDTC   char  19    Date/Time of Death
DTHFL    char  1     Subject Death Flag
SITEID   char  25    Study Site Identifier
INVID    char  25    Investigator Identifier
INVNAM   char  200   Investigator Name
BRTHDTC  char  19    Date/Time of Birth
AGE      num   8     Age
AGEU     char  10    Age Units
SEX      char  1     Sex
RACE     char  50    Race
ETHNIC   char  50    Ethnicity
ARMCD    char  8     Planned Arm Code
ARM      char  50    Description of Planned Arm
ACTARMCD char  8     Actual Arm Code
ACTARM   char  50    Description of Actual Arm
COUNTRY  char  3     Country
DMDTC    char  19    Date/Time of Collection
DMDY     num   8     Study Day of Collection
;
run;




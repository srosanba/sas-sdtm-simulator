%let path = H:\GraphicsGroup\dummy\sdtm\r-style\meta;

libname meta "&path";



*--------------------------------------------------------------------------------;
*---------- metadata ----------;
*--------------------------------------------------------------------------------;

data meta.ae_meta;
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
AESEQ    num   8     Sequence Number
AEGRPID  char  25    Group ID
AEREFID  char  25    Sponsor-Defined Identifier
AETERM   char  200   Reported Term for the Adverse Event
AEMODIFY char  200   Modified Reported Term
AELLT    char  200   Lowest Level Term
AELLTCD  num   8     Lowest Level Term Code
AEDECOD  char  200   Dictionary-Derived Term
AEPTCD   num   8     Preferred Term Code
AEHLT    char  200   High Level Term
AEHLTCD  num   8     High Level Term Code
AEHLGT   char  200   High Level Group Term
AEHLGTCD num   8     High Level Group Term Code
AECAT    char  200   Category for Adverse Event
AESCAT   char  200   Subcategory for Adverse Event
AEPRESP  char  1     Pre-Specified Adverse Event
AEBODSYS char  200   Body System or Organ Class
AEBDSYCD num   8     Body System or Organ Class Code
AESOC    char  200   Primary System Organ Class
AESOCCD  num   8     Primary System Organ Class Code
AELOC    char  50    Location of Event
AESEV    char  25    Severity/Intensity
AESER    char  1     Serious Event
AEACN    char  50    Action Taken with Study Treatment
AEACNOTH char  200   Other Action Taken
AEREL    char  50    Causality
AERELNST char  50    Relationship to Non-Study Treatment
AEPATT   char  50    Patterm of Adverse Event
AEOUT    char  50    Outcome of Adverse Event
AESCAN   char  1     Involves Cancer
AESCONG  char  1     Congenital Anomaly or Birth Defect
AESDISAB char  1     Persist or Signif Disability/Incapacity
AESDTH   char  1     Results in Death
AESHOSP  char  1     Requires or Prolongs Hospitalization
AESLIFE  char  1     Is Life Threatening
AESOD    char  1     Occurred with Overdose
AESMIE   char  1     Other Medically Important Serious Event
AECONTRT char  200   Concomitant or Additional Trtmnt Given
AETOXGR  char  50    Standard Toxicity Grade
AESTDTC  char  19    Start Date/Time of Adverse Event
AEENDTC  char  19    End Date/Time of Adverse Event
AESTDY   num   8     Study Day of Start of Adverse Event
AEENDY   num   8     Study Day of End of Adverse Event
AEDUR    char  19    Duration of Adverse Event
AEENRF   char  50    End Relative to Reference Period
AEENRTPT char  50    End Relative to Reference Time Point
AEENTPT  char  50    End Reference Time Point
;
run;




*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding default payments, demographic factors, credit data, 
history of payment, and bill statements of credit card clients in Taiwan from 
April 2005 to September 2005.

Dataset Name: UCI_Credit_Card_analytic_file created in external file
STAT6250-01_w17-team-4_project1_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

*Environmental Setup;

*Reset the relative file import path to the current working directory;
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,
%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

*Calls the data preparation file in the current working directory.
Brings in the data preparation file;
%include '.\STAT6250-01_w17-team-4_project1_data_preparation.sas';

*Research Questions;

/*Research Question 1*/
title1 'Research Question: What is the average bill amount for the most recent month 
for customers who have defaulted on payment, for each education level?';
title2 'Rationale: This gives an idea about the most recent bill amounts for
defaulters and see if education may play any role.';
footnote1 'By find the average of the most recent bill statement across 
different education distributions, susbet for defaulters, we can see if
statement amounts differ';
title;
footnote;
*Methodology: Use PROC MEANS on BILL_AMT6 with a subset of the dataset that 
has defaulted (default.payment.next.month = 1) and by education level.;
proc means data=UCI_Credit_Card_analytic_file;
    class education;
    var BILL_AMT6;
    where default_payment_next_month = 1;
    format education education_level.;
run;


/*Research Question 2*/
title1 'Research Question: Which education group comprises the most of those who are
defaulting?';
title2 'Rationale: This can help identify which education level to watch out for
when lending credit.';
footnote1 'PROC FREQ is taken with a subet of the dataset that has defaulted
(default_payment_next_month = 1) and education is taken as the variable of
interest. We can surmise that the education with the highest percentage takes
up the percentage of defaulters';
title;
footnote;
*Methodology: Use PROC FREQ on education with a subset of the dataset that
has defaulted (default.payment.next.month = 1). 
By finding the row percentages, we get the distribution which can help 
tell us which educational level makes up the highest percentage of 
defaulters.;
proc freq data=UCI_Credit_Card_analytic_file;
    table education;
    where default_payment_next_month = 1;
    format education education_level.
run;


/*Research Question 3*/
title1 'Research Question: What is the average bill statement across all
available months months between defaulters and non-defaulters, for
levels of education, sex, and marital status?';
title2 'Rationale: This would give us an idea of to see if between defaulters
and non-defaulter of each level of said categorical variables have
different spending habits';
title3 'Average billstatement amounts for defaulters of each level of 
education, marital status, and sex';
footnote1 'By taking the deriviative dataset which has a variable for meanbill
amount, we isolate each PROC MEANS statement for defaulters and non-defaulters.
We look at class variables education, marriage, and sex. From here, we can see
if there are statement differences between different levels of each variable for
defaulters and non-defaulters';
title;
footnote;
*Methodology: Create an average bill amount across each of the months
for each variable. Take the average of the newly created variable for
both defaulters and non-defaulters.;
proc means data=UCI_CC_analytic_file_meanbill;
    class education marriage sex;
    var meanbill;
    where default_payment_next_month = 1;
    format education education_level. marriage marital_status_bins. sex gender_bins.;
run;
title4 'Average billstatement amounts for non-defaulters of each level of 
education, marital status, and sex';
proc means data=UCI_CC_analytic_file_meanbill;
    class education marriage sex;
    var meanbill;
    where default_payment_next_month = 0;
    format education education_level. marriage marital_status_bins. sex gender_bins.;
run;

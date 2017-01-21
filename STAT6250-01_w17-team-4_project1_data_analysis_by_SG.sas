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

*
Research Question: What is the average bill amount for the most recent month 
for customers who have defaulted on payment, for each education level?

Rationale: This gives an idea about the most recent bill amounts for
defaulters and see if education may play any role.

Methodology: Use PROC MEANS on BILL_AMT6 with a subset of the dataset that 
has defaulted (default.payment.next.month = 1) and by education level.
;
proc format;
    value education_level 1 = 'Graduate School'
                          2 = 'University'
                          3 = 'High School'
                          4 = 'Other'
                          5-6 = 'Unknown';
run;

title 'Average bill statement amounts by education level for those who have 
defaulted';
proc means data=UCI_Credit_Card_analytic_file;
    class education;
    var BILL_AMT6;
    where default.payment.next.month = 1;
    format education education_level.;
run;
title;

*Research Question: Which education group has the highest probability of
defaulting?

Rationale: This can help identify which education level to watch out for
when lending credit.

Methodology: Use PROC FREQ on education with a subset of the dataset that
has defaulted (default.payment.next.month = 1). 
By finding the row percentages, we get the distribution which can help 
tell us which educational level makes up the highest percentage of 
defaulters.
;

title 'Distribution of education level among those who have defaulted';
proc freq data=UCI_Credit_Card_analytic_file;
    table education;
    where default.payment.next.month = 1;
run;
title;

*Research Question: What is the average bill statement across all
available months months between defaulters and non-defaulters, for
levels of education, sex, and marital status?

Rationale: This would give us an idea of to see if between defaulters
and non-defaulter of each level of said categorical variables have
different spending habits
;

/*Prepares a dataset containing the mean of all bill statements 
amounts*/
data UCI_CC_analytic_file_meanbill;
    set UCI_Credit_Card_analytic_file;
    meanbill = mean(bill_amt1-bill_amt6);
run;

title 'Average billstatement amounts for defaulters 
of each level of education, marital status, and sex';
proc means data=UCI_CC_analytic_file_meanbill;
    class education marriage sex;
    var meanbill;
    where default.payment.next.month = 1;
run;
title;

title 'Average billstatement amounts for non-defaulters 
of each level of education, marital status, and sex';
proc means data=UCI_CC_analytic_file_meanbill;
    class education marriage sex;
    var meanbill;
    where default.payment.next.month = 0;
run;
title;
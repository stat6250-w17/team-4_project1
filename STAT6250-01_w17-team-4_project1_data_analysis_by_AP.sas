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

* environmental setup;
%let dataPrepFileName = STAT6250-01_w17-team-4_project1_data_preparation.sas;
%let sasUEFilePrefix = team-4_project1;

* load external file that generates analytic dataset 
UCI_Credit_Card_analytic_file using a system path dependent on the host 
operating system, after setting the relative file import path to the current 
directory, if using Windows;

%macro setup;
%if
	&SYSSCP. = WIN
%then
	%do;
		X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";			
		%include ".\&dataPrepFileName.";
	%end;
%else
	%do;
		%include "~/&sasUEFilePrefix./&dataPrepFileName.";
	%end;
%mend;
%setup


title1 
"Research Question: Are male clients more likely to default than female clients?"
;
title2 
"Rationale: This would help to know if gender plays any role in payment defaulting"
;
footnote1
"Based on the above output, it cannot be concluded if gender plays a role or not."
;
footnote2
"It can be seen that about 20% of both male and female clients default, though the percentage is slightly higher in males."
;
* 
Methodology: Use PROC FREQ to compute the percentage of clients defaulting based
on the variable SEX in the excel file. 
;
proc freq data=UCI_Credit_Card_analytic_file;
    table 
         default_payment_next_month 
        *sex
	    / missing norow nocol nofreq
    ;
    format
        default_payment_next_month default_payment_next_month_bins.
        sex gender_bins.
    ;
run;
title;
footnote;



title1 
"Research Question: Are people who are single more likely to default than couples?"
;
title2 
"Rationale: This would help to know if marital status plays any role in payment defaulting." 
;
footnote1
"Based on the above output, it can be said that married clients default more than clients who are single."
;
footnote2
"It can be seen that about 24% of married clients default, while its about 20% for single people."
;
*
Methodology: Use PROC freq to compute the percentage of clients defaulting based
on the variable MARRIAGE in the excel file. 
;
proc freq data=UCI_Credit_Card_analytic_file;
    table
         default_payment_next_month
        *Marriage
	    / missing norow nocol nopercent ;
	    where marriage > 0
    ;
	format
        default_payment_next_month default_payment_next_month_bins.
		marriage marital_status_bins.
	;
run;
title;
footnote;
* 
Notes: These percentages may not seem significantly different, but a regression 
may yeild a result which might indicate other parameter which may impact 
defaulting.
;



title1 
"Research Question: Which variable (sex, education, marital status) will help predict default payment?"
;
title2
"Rationale: This would help the company determine whether the customer is high risk or low risk while approving the credit card or limit."
;
footnote1
"Based on the output, this model explains less than 3% about the default payment"
;
*
Methodology: We have to use regression to find which parameter affects the 
default payment.
;
proc reg data=UCI_Credit_Card_analytic_file;
    model default_payment_next_month = SEX MARRIAGE EDUCATION
    ;	
run;
title;
footnote;

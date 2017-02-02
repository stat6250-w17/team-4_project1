*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding default of credit card clients
Dataset Name: UCI_Credit_Card_analytic_file created in external file
STAT6250-01_w17-team-4_project1_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;

* environmental setup;
%let dataPrepFileName = STAT6250-01_w17-team-4_project1_data_preparation.sas;
%let sasUEFilePrefix = team-4_project1;

* load external file that generates analytic dataset UCI_Credit_Card_analytic_file
using a system path dependent on the host operating system, after setting the
relative file import path to the current directory, if using Windows;

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
"Research Question: What is the default rate? "
;
title2
"Rationale: This would help to know how serious the credit card default is for the credit card company."
;
footnote1
"Based on the above output, 22.12% clients default "
;
footnote2
"Further analysis to look for who are defaulting"
;
*
Methodology: Use PROC freq to compute the percentage of default clients.
;
proc freq  data=UCI_Credit_Card_analytic_file;
    tables default_payment_next_month
         /nocum
    ;
    format default_payment_next_month default_payment_next_month_bins.; 
run;
title;
footnote;



title1
"Research Question: Which age group  people are more likely to default?  "
;
title2
"Rationale: This would help to know that if age is related to default and that what age range of clients are more likely to default ."
;
footnote1
"Based on the above output, clients who are younger than 25 and older than 55 are most likely to default (having default rate of 26.6%). "
;
footnote2
"Clients who are 25-35 years old are least likely to default (having default rate of 19.83%)"
;
*
Methodology: use proc format to group age, then use proc freq to compute
percentage of default for each age group.
;
proc freq data=UCI_Credit_Card_analytic_file;
    tables default_payment_next_month*age
        / missing nofreq nopercent norow 
    ;
    format 
        age agefmt. 
        default_payment_next_month default_payment_next_month_bins.
    ; 
run;
title;
footnote;



title1
"Research Question: How does the distribution of credit limit for default clients compare to that for standard clients?  "
;
title2
"Rationale: This would help to know if credit limit is related to default."
;
footnote1
"Based on the above output, the distribution of credit limit for default clients is pretty much different form that for standard clients. "
;
footnote2
"credit limit for default clients is much lower than that for standard clients."
;
footnote3
"Further analysis to look for whether credit limit is associated with age."
;
*
Methodolody: Compute five-number summaries by default.payment.next.month 
indicator variable
;
proc means 
        min q1 median q3 max 
        data=UCI_Credit_Card_analytic_file
    ;
    class default_payment_next_month;
    var limit_bal;
    format
        default_payment_next_month default_payment_next_month_bins.; 
run;
title;
footnote;



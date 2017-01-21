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
%setup;


/*
Research Question: Are male clients more likely to default than female clients? 
Rationale: This would help to know if gender plays any role in payment defaulting. 

Methodology: Use PROC freq to compute the percentage of clients defaulting based
on the variable SEX in the excel file. 

*/
title "Percentage of default clients based on gender";
proc freq data=UCI_Credit_Card_analytic_file;
     tables = default.payment.next.month * SEX;
run;

/*
Research Question: Are people who are single more likely to default than couples? 
Rationale: This would help to know if marital status plays any role in payment
defaulting. 

Methodology: Use PROC freq to compute the percentage of clients defaulting based
on the variable MARRIAGE in the excel file. 

*/

proc freq data=UCI_Credit_Card_analytic_file;
     tables = default.payment.next.month * MARRIAGE;
run;

/*
Research Question: Which variable (age, sex, education, marital status) will 
help predict default payment? 
(Rationale: This would help the company determine whether the customer is high 
risk or low risk while approving the credit card or limit.)

Methodology: We have to use regression to find which parameter affects the 
default payment.
*/

proc reg data=UCI_Credit_Card_analytic_file;
     model default.payment.next.month = AGE SEX MARRIAGE EDUCATION / stb;
run;





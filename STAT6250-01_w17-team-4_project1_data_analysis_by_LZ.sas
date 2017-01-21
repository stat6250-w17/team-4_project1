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


*
Research Question: What is the default rate? 
Rationale: This would help to know how serious the credit card default is for 
the credit card company.
Methodology: Use PROC freq to compute the percentage of default clients.
;

proc freq  data=UCI_Credit_Card_analytic_file;
    tables default.payment.next.month/nocum;
run;

*
Research Question: Which age group  people are more likely to default? 
Rationale: This would help to know that if age is related to default and that
 what age range of clients are more likely to default .
Methodology: use proc format to group age, then use proc freq to compute
percentage of default for each age group.
;

proc format;
    value Agefmt
        low-25="<25"
        25-35="25-35"
        35-45="35-45"
        45-55="45-55"
        55-65="55-65"
        65-high=">=65" ;
run;

proc freq data=UCI_Credit_Card_analytic_file;
    tables default.payment.next.month*Age
        / missing nofreq nopercent norow 
    ;
    format Age Agefmt.;
run;

*
Research Question: How does the distribution of "Credit Limit" for default
clients compare to that for standard clients?
Rationale: This would help to know if credit limit is related to default.
Methodolody: Compute five-number summaries by default.payment.next.month 
indicator variable
;

proc means min q1 median q3 max data=UCI_Credit_Card_analytic_file;
    class default.payment.next.month;
    var LIMIT_BAL;
run;




*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
This file prepares the dataset described below for analysis.

Dataset Name: Default of Credit Card Clients Dataset

Experimental Units: Default of Credit Card Clients

Number of Observations: 30000

Number of Features: 25

Data Source: The file, UCI_Credit_Card.xlsx was downloaded from
'https://www.kaggle.com/uciml/default-of-credit-card-clients-datasetù'
The CSV file was downloaded from the files directory on the bottom of the page.
No further modifications took place and the data was used directly.

Data Dictionary: The data dictionary was taken from
'https://www.kaggle.com/uciml/default-of-credit-card-clients-dataset'. The 
CSV file was downloaded from the files directory on the bottom of the page.

Unique ID: The column ID is the unique ID.
;

* setup environmental parameters;
%let inputDatasetURL =
https://raw.githubusercontent.com/sgummidipundi-stat6250/Project-1/master/UCI_Credit_Card.csv
;

*PROC FORMAT steps;
proc format;
    value education_level 1 = 'Graduate School'
                          2 = 'University'
                          3 = 'High School'
                          4 = 'Other'
                          5-6 = 'Unknown';



    value default_payment_next_month_bins
        0="Good Standing"
        1="Default"
        
    ;
    value gender_bins
       1="Male"
       2="Female"
    ;
    value marital_status_bins
	    1="Married"
	    2="Single"
	    3="Others"
   ;
   value agefmt
        low-25="<25"
        25-35="25-35"
        35-45="35-45"
        45-55="45-55"
        55-65="55-65"
        65-high=">=65" 
    ;
run;

* load raw default credit card dataset over the wire;
filename UCICCtmp TEMP;
proc http
    method="get" 
    url="&inputDatasetURL." 
    out= UCICCtmp
    ;
run;
proc import
    file= UCICCtmp
    out= UCI_Credit_Card_raw
    dbms=csv replace
    ;
run;
filename UCICCtmp clear;

* check raw Credit card dataset for duplicates with respect to its composite key;
proc sort nodupkey data= UCI_Credit_Card_raw dupout= UCI_Credit_Card_raw_dups 
out=_null_;
    by id;
run;


* build analytic dataset from default credit card dataset with the least 
number of columns and minimal cleaning/transformation needed to address 
research questions in corresponding data-analysis files. Named improper
excel variable name default.payment.next.month to SAS compliant
default_payment_next_month;
data UCI_Credit_Card_analytic_file;
	retain
        id
        age
        limit_bal
        sex
        marriage
        education
        default_payment_next_month
        bill_amt1-bill_amt6 
    ;

    keep
        id
        age
        limit_bal
        sex
        marriage
        education
        default_payment_next_month
        bill_amt1-bill_amt6
    ;
    set UCI_Credit_Card_raw (rename=('default.payment.next.month'n = default_payment_next_month));
run;

*Data steps to build for analysis;

/*Prepares a dataset containing the mean of all bill statements 
amounts*/
data UCI_CC_analytic_file_meanbill;
    set UCI_Credit_Card_analytic_file;
    meanbill = mean(bill_amt1-bill_amt6);
run;


*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
This file prepares the dataset described below for analysis.

Dataset Name: Student Poverty Free or Reduced Price Meals (FRPM) Data

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
proc sort nodupkey data= UCI_Credit_Card_raw dupout= UCI_Credit_Card_raw_dups out=_null_;
    by id;
run;


* build analytic dataset from default credit card dataset with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files;
data UCI_Credit_Card_analytic_file;

/*default.payment.next.month has been renamed in order to comply with SAS
      naming conventions*/
    
    set UCI_Credit_Card_raw (rename=(default_payment_next_month = default_yn));

    retain
        id
        age
        limit_bal
        sex
        marriage
        education
        default_yn

        
    ;
    keep
        id
        age
        limit_bal
        sex
        marriage
        education
        default_yn
    ;
    set UCI_Credit_Card_raw;
run;





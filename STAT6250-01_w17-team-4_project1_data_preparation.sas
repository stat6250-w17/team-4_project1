*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file prepares the dataset described below for analysis.

Dataset Name: Default of Credit Card Clients

Experimental Units: Customers

Number of Observations: 

Number of Features:

Data Source: The file, UCI_Credit_Card.xlsx was downloaded from
'https://www.kaggle.com/uciml/default-of-credit-card-clients-dataset'
The XLS file was downloaded from the files directory on the bottom of the page.
No further modifications took place and the data was used directly.

Data Dictionary: The data dictionary was taken from
'https://www.kaggle.com/uciml/default-of-credit-card-clients-dataset'. The 
XLS file was downloaded from the files directory on the bottom of the page.

Unique ID: The columns ID is the unique ID.
;

* setup environmental parameters;
%let inputDatasetURL = 
https://raw.githubusercontent.com/sgummidipundi-stat6250/Project-1/master/UCI_Credit_Card.csv
;

*Load raw data over the wire;
filename UCICCtmp temp;
proc http method="get"
		url="&inputDatasetURL."
		out=UCICCtmp;
run;

proc import file= UCICCtmp
			out= UCI_Credit_Card_raw
			dbms=csv replace;
run;
filename credit clear;

*Check to see if there's any duplicate keys;
proc sort nodupkey data=UCI_Credit_Card_raw 
dupout = UCI_Credit_Card_raw_dups out = _null_;
    by id;
run;

*Create an anlytic dataset based off of only the columns that need to be used 
for addressing the proposed research questions corresponding to data analysis 
files;
data UCI_Credit_Card_analytic_file;
    /*default.payment.next.month has been renamed in order to comply with SAS
      naming conventions*/
    set UCI_Credit_Card_raw (rename=('default.payment.next.month'n = default_yn));
	retain id age limit_bal sex marriage education default_yn;
    keep id age limit_bal sex marriage education default_yn;
run;

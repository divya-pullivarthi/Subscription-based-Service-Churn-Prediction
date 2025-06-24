*Subscription based Service Churn;

PROC Import Datafile="C:\Users\DPULLIVA\Desktop\Project\Final_Dataset.csv" out= churn replace; 
delimiter=','; getnames=yes; 
RUN; 

TITLE"Print Dataset";
PROC PRINT;
RUN;

*Used proq frequency to find out how many dummy varaibles needs to be created for each column;
PROC FREQ;
Tables GenrePreference; *used this also for columns like SubscriptionType, PaymentMethod, ContentType, DeviceRegistered, GenrePreference;
RUN;

*Creating dummy variables;

DATA churn;      
SET churn; 

*dummy variable for Subscription Type;
d_subtype2 = (SubscriptionType='Standard');
d_subtype3 = (SubscriptionType='Premium');

*dummy variable for Payment Method;
d_pay1 = (PaymentMethod='Bank transfer');
d_pay2 = (PaymentMethod='Credit card');
d_pay3 = (PaymentMethod='Electronic check');

*dummy variable for Content Type;
d_content1 = (ContentType='TV Shows');
d_content2 = (ContentType='Movies');

*dummy variable for DeviceRegistered;
d_device1 = (DeviceRegistered='Computer');
d_device2 = (DeviceRegistered='Mobile');
d_device3 = (DeviceRegistered='TV');

*dummy variable for GenrePreference;
d_genre1 = (GenrePreference='Action');
d_genre2 = (GenrePreference='Comedy');
d_genre3 = (GenrePreference='Drama');
d_genre4 = (GenrePreference='Fantasy');

*dummy variable for paperlessbilling;
d_paperlessbilling =(Paperlessbilling ='Yes');

*dummy variable for MultiDeviceAccess;
d_MultiDeviceAccess =(MultiDeviceAccess ='Yes');

*dummy variable for gender;
d_gender=(gender='Female'); 

*dummy variable for ParentalControl;
d_ParentalControl=(ParentalControl='Yes'); 

*dummy variable for SubtitlesEnabled;
d_SubtitlesEnabled=(SubtitlesEnabled='Yes'); 
RUN;

TITLE"Print Dataset";
PROC PRINT;
RUN;

*Sort the data - by the qualitative or text variable i.e. churn;

PROC SORT;
BY churn;
RUN;

*CREATE BOXPLOT;
TITLE"Box plot for Churn Data with Account Age";
PROC BOXPLOT;

*y-axis var * x-axis var. X-axis var - is text var;

PLOT Accountage*churn;
RUN;

TITLE"Box plot for Churn Data with User Rating";
PROC BOXPLOT;

*y-axis var * x-axis var. X-axis var - is text var;

PLOT userrating*churn;
RUN;

TITLE"Box plot for Churn Data with Monthly Charges";
PROC BOXPLOT;

*y-axis var * x-axis var. X-axis var - is text var;

PLOT MonthlyCharges*churn;
RUN;

TITLE"Box plot for Churn Data with Support Tickets Per Month";
PROC BOXPLOT;

*y-axis var * x-axis var. X-axis var - is text var;

PLOT SupportTicketsPerMonth*churn;
RUN;

TITLE "Descriptives";
PROC MEANS N min P25 P50 P75 P99 max mean mode;
VAR Churn AccountAge MonthlyCharges TotalCharges ViewingHoursPerWeek AverageViewingDuration ContentDownloadsPerMonth UserRating SupportTicketsPerMonth WatchlistSize d_subtype2 d_subtype3 d_pay1 d_pay2 d_pay3 d_content1 d_content2 d_device1 d_device2 d_device3 d_genre1 d_genre2 d_genre3 d_genre4 d_paperlessbilling d_MultiDeviceAccess d_gender d_ParentalControl d_SubtitlesEnabled ;
RUN;

*Full model + R2;
TITLE "Full Model";
PROC LOGISTIC data=churn; 
Model churn(event='1')=AccountAge MonthlyCharges TotalCharges ViewingHoursPerWeek AverageViewingDuration ContentDownloadsPerMonth UserRating SupportTicketsPerMonth WatchlistSize d_subtype2 d_subtype3 d_pay1 d_pay2 d_pay3 d_content1 d_content2 d_device1 d_device2 d_device3 d_genre1 d_genre2 d_genre3 d_genre4 d_paperlessbilling d_MultiDeviceAccess d_gender d_ParentalControl d_SubtitlesEnabled / rsq ;
RUN;

*Full Model - Check Diagnostics;
TITLE "Full Model - Diagnostics";
PROC LOGISTIC data=churn; 
Model churn(event='1')=AccountAge MonthlyCharges TotalCharges ViewingHoursPerWeek AverageViewingDuration ContentDownloadsPerMonth UserRating SupportTicketsPerMonth WatchlistSize d_subtype2 d_subtype3 d_pay1 d_pay2 d_pay3 d_content1 d_content2 d_device1 d_device2 d_device3 d_genre1 d_genre2 d_genre3 d_genre4 d_paperlessbilling d_MultiDeviceAccess d_gender d_ParentalControl d_SubtitlesEnabled / stb influence corrb iplots rsq ;
RUN;

* Dropping a predictor because of multicollinearity;
DATA churn_new;
SET churn;
* Remove variable TotalCharges to remove multicollinearity between TotalCharges and Accountage;
Drop TotalCharges;
RUN;

PROC PRINT data = churn_new ;
RUN;

*/Splitting the data into training and testing sets - 70/30
samplerate = 70% of observations to be randomly selected for training set
out= selected_data defines new sas dataset for training & test sets;

PROC SURVEYSELECT data=churn_new out=selected_data seed= 4862037
samplerate=0.70 outall;
RUN;

*To check if selected field was created;
PROC PRINT;
RUN;

*/create new_y varaible to be used for model selection
new_y holds the training set;

DATA train;
SET selected_data;
*assign the obs_y if it is training set;
if (Selected = 1) then new_y = churn;
RUN;

*check new_y if it is populated correctly;
PROC PRINT;
RUN;

*Run Model Selection using new_y;

TITLE "Final Model Selection - Forward";
PROC LOGISTIC data=train; 
Model new_y(event='1')=AccountAge MonthlyCharges ViewingHoursPerWeek AverageViewingDuration ContentDownloadsPerMonth UserRating SupportTicketsPerMonth WatchlistSize d_subtype2 d_subtype3 d_pay1 d_pay2 d_pay3 d_content1 d_content2 d_device1 d_device2 d_device3 d_genre1 d_genre2 d_genre3 d_genre4 d_paperlessbilling d_MultiDeviceAccess d_gender d_ParentalControl d_SubtitlesEnabled / selection= forward rsq ;
RUN;

*Final Model - Check Diagnostics;
TITLE "Final Model - Diagnostics";
PROC LOGISTIC data=train;
Model new_y(event='1')= AccountAge MonthlyCharges ViewingHoursPerWeek AverageViewingDuration ContentDownloadsPerMonth UserRating SupportTicketsPerMonth d_subtype2 d_pay3 d_device3 d_genre2 d_ParentalControl / stb influence corrb iplots rsq;
RUN;

*/1. Run final model
2. with the final model, generate classification table to identify the threshold
3. compute the predicted probability for test set;

PROC LOGISTIC data=train;
*1 & 2;
Model new_y(event='1')= AccountAge MonthlyCharges ViewingHoursPerWeek AverageViewingDuration ContentDownloadsPerMonth UserRating SupportTicketsPerMonth d_subtype2 d_pay3 d_device3 d_genre2 d_ParentalControl / ctable pprob= (0.1 to 0.9 by 0.05);
*save prediction in sas dataset "pred";
*3;
output out=pred(where=(new_y=.)) p=phat;
RUN;

*Compute performance for Test set;
DATA probs;
SET pred;
*use the pred.probability and threshold to compute pred y;
if (phat>0.55) then pred_y =1;
else 
pred_y = 0;
RUN;

PROC PRINT;
RUN;

*Confusion matrix;
TITLE "Confusion Matrix";
PROC FREQ data = probs;
*cross tab between obsY and preY;
Tables churn*pred_y / norow nocol nopercent;
RUN;

*/Compute Prediction - i.e. compute prediction for the likelihood of churn for a 48-month subscriber who pays $18.48625748 monthly, has accrued $886.90 in total charges, 
uses a basic subscription paid via bank transfer, does not use paperless billing, watches TV shows on a registered TV device with multi-device access enabled. 
They watch 27.828635925 hours weekly, averaging 75.787314567 minutes per session, download 18 items per month, prefer drama, rate the service 4.162684247, submit 6 support tickets monthly, 
identify as male, have a watchlist of 22 items, use parental controls, but do not enable subtitles.";

*(a) Create prediction dataset;
TITLE "Computing Prediction";
DATA new;
Input AccountAge MonthlyCharges ViewingHoursPerWeek AverageViewingDuration ContentDownloadsPerMonth UserRating SupportTicketsPerMonth d_subtype2 d_pay3 d_device3 d_genre2 d_ParentalControl;
DATALINES;
48 18.48625748 27.828635925 75.787314567 18 4.162684247 6 0 0 1 0 1
;

PROC PRINT;
RUN;

*(b) Merge prediction dataset with original dataset and populate dummy variables;

DATA churn_predictions;
SET new churn;
RUN;

PROC PRINT;
RUN;

*(c) Run prediction;
PROC LOGISTIC data = churn_predictions;
MODEL Churn (even='1')= AccountAge MonthlyCharges ViewingHoursPerWeek AverageViewingDuration ContentDownloadsPerMonth UserRating SupportTicketsPerMonth d_subtype2 d_pay3 d_device3 d_genre2 d_ParentalControl;
output out= churn_predictions p=phat lower = lcl upper=ucl;
RUN;


*(d) Print predicted probabilities and confidence intervals;

PROC PRINT data = churn_predictions;
RUN;




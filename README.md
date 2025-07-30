# 📊 **Subscription-Based Service Churn Prediction**

### Data Analysis project on Subscription-based Service Churn Prediction

This project uses logistic regression modeling to analyze and predict customer churn for a subscription-based digital service. It identifies behavioral and demographic features that influence whether a customer is likely to cancel their subscription, and supports organizations in developing targeted retention strategies.

## 📖 Table of Contents
- [🔍 Objective](#-objective)
- [🧾 Dataset Source](#-dataset-source)
- [🔧 Sampling Process](#-sampling-process)
- [🛠 Tools & Techniques](#-tools--techniques)
- [🧪 Methodology](#-methodology)
- [🔍 Model Selection Approach](#-model-selection-approach)
- [🔄 Forward Selection](#-forward-selection)
- [🔁 Stepwise Selection](#-stepwise-selection)
- [🔃 Backward Elimination](#-backward-elimination)
- [✅ Final Model Selection](#-final-model-selection)
- [📉 Final Model Equation](#-final-model-equation)
- [📁 Files](#-files)
- [🧠 Insights](#-insights)
- [🎯 Conclusion](#-conclusion)
- [📌 Author](#-author)

## 🔍 **Objective**

To answer two key questions:

What is the likelihood of churn for a specific customer segment or profile?

Which customer attributes or behaviors are most strongly associated with churn?

## 🧾 **Dataset Source** 

Kaggle - Predictive Analytics for Customer Churn Dataset 

_**Link:** https://www.kaggle.com/datasets/safrin03/predictive-analytics-for-customer-churn-dataset?resource=download&select=train.csv_

**Original Size:** ~2.5 million records

**Final Used:** 2,226 observations (edited for computational feasibility and balance for the academic project)

## **🔧 Sampling Process**

To reduce dataset size while retaining meaningful insights:

Used Excel’s RAND() function for random sampling

If Churn = 1, included only if RAND() > 0.8

If Churn = 0, included only if RAND() > 0.9

Did this 2 times for a balanced data observations.

This sampling process ensured balance in the churn-to-no-churn ratio while keeping model stability.

## 🛠 **Tools & Techniques**

**Software:** SAS

**Model Type:** Logistic Regression

**Feature Engineering:** Dummy variables created for all categorical features

**Data Split:** 70% Training / 30% Testing

## **🧪 Methodology**

### **✅Data Preprocessing**

Dummy variable creation for all categorical features

Exploratory data analysis (EDA) with boxplots and descriptive statistics

Multicollinearity check and removal (TotalCharges dropped due to high correlation with AccountAge)

Outliers and Influential points were checked.

## **🔍 Model Selection Approach**

SAS supports three model selection methods for logistic regression, and all three were applied:

## **🔄 Forward Selection**

Predictors (12):
AccountAge, MonthlyCharges, ViewingHoursPerWeek, AverageViewingDuration, ContentDownloadsPerMonth, UserRating, SupportTicketsPerMonth, d_subtype2, d_pay3, d_device3, d_genre2, d_ParentalControl

### **Model Metrics:**

R²: 0.1654

AIC / SC: 1883.316 / 1952.889

**Classification Threshold:** 0.55

### **Test Set Performance:**

True Positives (TP): 252

True Negatives (TN): 192

False Positives (FP): 94

False Negatives (FN): 129

Sensitivity: 66.14%

Specificity: 67.13%

Accuracy: 66.57%

Precision: 72.83%

F1-Score: 0.6933

## **🔁 Stepwise Selection**

Predictors (11):
AccountAge, MonthlyCharges, ViewingHoursPerWeek, AverageViewingDuration, ContentDownloadsPerMonth, UserRating, SupportTicketsPerMonth, d_subtype2, d_device3, d_genre2, d_ParentalControl

### **Model Metrics:**

R²: 0.1634

AIC / SC: 1885.181 / 1949.403

Classification Threshold: 0.60

### **Test Set Performance:**

TP: 214

TN: 210

FP: 76

FN: 167

Sensitivity: 56.17%

Specificity: 73.43%

Accuracy: 63.57%

Precision: 73.79%

F1-Score: 0.6379

## **🔃 Backward Elimination**

Predictors (12):
Includes AccountAge, MonthlyCharges, ViewingHoursPerWeek, AverageViewingDuration, ContentDownloadsPerMonth, UserRating, SupportTicketsPerMonth, d_subtype2, d_pay1, d_pay2, d_genre2, d_ParentalControl

### **Model Metrics:**

R²: 0.1654

AIC / SC: 1883.380 / 1952.954

Classification Threshold: (not specified, assumed 0.5)

### **Test Set Performance:**

TP: 213

TN: 219

FP: 67

FN: 168

Sensitivity: 55.91%

Specificity: 76.57%

Accuracy: 64.77%

Precision: 76.07%

F1-Score: 0.6445

## **✅ Final Model Selection**

The Forward Selection model was selected as the final model since it was the most aligned with the focal research questions of the project:
 
What is the probability of churn for a particular customer segment or profile?

What customer propensities or behaviour characteristics are more strongly associated with churn?

With this emphasis, our preference is to be able to identify as many actual churners as possible, that is, to maximize true positives (TP). The Forward Selection model had the highest true positives, TP=252, along with a strong balance of precision and overall accuracy:

True Positives (TP): 252 (highest across all models)

Precision: 72.83%

F1-Score: 0.6933

Accuracy: 66.57%

Although the Stepwise and Backward models had slightly higher specificity or precision on their own, they achieved fewer total churn cases (lower TP and sensitivity), which is not as preferable when the goal is to proactively detect customers at risk of churn. 

As a result, the Forward model is the best and most suitable selection for understanding the likelihood of churn and the most influential factors to drive actions to detect customer churn.

## **📉 Final Model Equation**

See Project_Report.pdf → p.15 for the logistic regression equation and odds analysis.

## **📁 Files**

Project_Report.pdf: Detailed statistical report with data insights, EDA, modeling, and conclusions.

## **🧠 Insights**

In studying patterns of churn within our subscriber data, a few themes emerged:
 
Early-stage customers tend to be fragile. Customers with shorter account ages were more likely to churn. It became clear that if we do not win them early, we will probably lose them quickly. Investing in onboarding and engaging a customer in their early involvement could alter the curve.
 
Payment Method tells a story. Customers who used electronic checks were disproportionately more likely to churn. There is more than convenience at play here; it could suggest poor digital absorption or disengagement. Getting a customer to utilize seamless means of payment may generate increased commitment from customers.
 
Support is a double-edged sword. At first glance, support tickets might reflect engagement. But our model produced evidence that more support tickets led to more churn. The takeaway? Support quality matters more than quantity. Unresolved frustrations are a warning sign.
 
Device type might matter more than we think. Customers who consumed viewing on TVs exhibited stronger retention profiles compared to those who used other types of devices. This could indicate that television viewing potentially provided a better, more immersive viewing experience, or viewers were using the service as a family, creating a sense of opportunity cost connected to the value of the service.
 
Not all content drives loyalty. Users who reported Comedy as their preferred type of content experienced churn at higher rates. It raises the question: Is our comedy library repetitive, outdated, or just not what customers desire?

Standard plan customers stood out for the wrong reason. Standard plan subscribers had worse churn rates than people on Basic and Premium. Perhaps this is the result of a value-perception gap? The standard tier may need to be reconsidered.

Parents who use parental controls stick around longer. This may make sense, enabling parental controls was probably a signal of being more involved in their everyday family lives, also therefore, a stronger reason to have a continued subscription.

## **🎯 Conclusion**

The analysis showed churn is not an attribute influenced by one factor; churn is influenced by customer behaviours, perceived quality of experience, situational factors that influence retention outcomes. 
Longer-term users and TV watchers are more likely to stay than newer customers, electronic check users, and customers who opened frequent support tickets. In fact, even long-term active customers can churn if their expectations are not met; for example, Comedy users and customers on the Standard subscription plan.

The analysis also suggests straightforward, tactical things to do, including:

Focus on retention within the first month through onboarding and individualized nudges.
Encourage digital payment methods to further promote seamless, modern customer experiences.
Revisit the Standard subscription tier to deliver clear value.
Dig into content-related satisfaction — especially with genres that have high churn, such as Comedy.
Track support ticket frequency to find early indicators of chu

## **📌 Author**

Divya Pullivarthi

Project completed for course DSC 423: Data Analysis and Regression

[LinkedIn](https://www.linkedin.com/in/divya-pullivarthi-992970198/)

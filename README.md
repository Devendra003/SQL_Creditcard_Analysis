# SQL_Creditcard_Analysis
The project's goal is to analyze the usage of credit card and analyze spent habit of ussers and provide insights

# Tech Stack & Process involved in building the project
Step 1: Collect the necessary details about the Credit Card analysis report.
Step 2: (Explore Process) Fletch the data from the csv file to "MS SQL Server" using ssis.

Observations 1: 

1. In the data, female users is 5% higher than male users.
2. The most common spending type is food->fuel->bills->entertainment->grocery and the least is travel
3. Silver is the most popular card type, slightly higher (1.5%) than 3 other card types
4. Deal size is segmented into 4 equal sizes, meets our expectation because it's defined by the amount 
   dispersion, I'm interested in the gender and spending type wthin 4 deal sizes
   

Observations 2:

1. In most of the label, Female users has higher percentage than male users.
2. While comparing expense type, fuel is the only label male users use credit card more than female, 
while food and bills female surpass male 
3. When the deal size gets bigger,the range of (female-male) percentage gets larger, 
which means higher the amount is,more female tend to use credit card and males tend to 
pay by other methods


Observations 3

1. Interesting finding is no matter which card type, the interaction with other labels looks indentical.
2. As far as gender, 4 card types male users spend around 0.3M
3. As far as expense type, Bills stand out of other expense, while other expenses locate lower than 0.4M

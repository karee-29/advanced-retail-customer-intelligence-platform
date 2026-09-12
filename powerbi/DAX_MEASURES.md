# DAX Measures

```DAX
Revenue = CALCULATE(SUM(fact_order[net_sales_inr]), fact_order[order_status] IN {"Delivered","Returned"})
Orders = CALCULATE(DISTINCTCOUNT(fact_order[order_id]), fact_order[order_status] IN {"Delivered","Returned"})
Active Customers = CALCULATE(DISTINCTCOUNT(fact_order[customer_id]), fact_order[order_status] IN {"Delivered","Returned"})
AOV = DIVIDE([Revenue],[Orders])
Gross Profit = CALCULATE(SUM(fact_order[gross_profit_inr]), fact_order[order_status] IN {"Delivered","Returned"})
Contribution Profit = CALCULATE(SUM(fact_order[contribution_profit_inr]), fact_order[order_status] IN {"Delivered","Returned"})
Contribution Margin % = DIVIDE([Contribution Profit],[Revenue])
Return Rate % = DIVIDE(SUM(fact_order[is_returned]),[Orders])
Revenue per Customer = DIVIDE([Revenue],[Active Customers])
Revenue YoY % = VAR PY=CALCULATE([Revenue],DATEADD(dim_date[date],-1,YEAR)) RETURN DIVIDE([Revenue]-PY,PY)
Average CLV = AVERAGE(customer_360[clv_3yr])
High Churn Risk Customers = CALCULATE(DISTINCTCOUNT(customer_360[customer_id]),customer_360[churn_probability]>=0.60)
High Value At Risk = CALCULATE(DISTINCTCOUNT(customer_360[customer_id]),customer_360[churn_probability]>=0.60,customer_360[clv_3yr]>=10000)
```
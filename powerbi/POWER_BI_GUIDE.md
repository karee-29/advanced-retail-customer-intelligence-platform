# Power BI Build Guide

## Data model
Create a star schema:
- `dim_date[date]` → `fact_order[order_date]`
- `dim_customer[customer_id]` → `fact_order[customer_id]`
- `dim_product[product_id]` → `fact_order[product_id]`

Load the raw fact/dim tables plus the analytics tables under `data/analytics/`.

## Pages

### 1. Executive Customer Intelligence
Revenue, Orders, Active Customers, AOV, Contribution Margin, monthly revenue trend, category revenue, channel contribution.

### 2. Customer Segmentation & CLV
RFM segment distribution, CLV distribution, frequency vs monetary scatter, churn bands, high-value-at-risk table.

### 3. Retention & Cohorts
Cohort heatmap, active customers, repeat rate, monthly retention and revenue by acquisition cohort.

### 4. Product Profitability
Revenue vs contribution margin, contribution by category, SKU ranking, return-rate analysis, ABC classification.

### 5. Geographic & Acquisition Intelligence
Revenue by state, revenue/customer, acquisition channel economics, contribution mix.

### 6. Customer Risk Action Center
Filter to high CLV + high churn probability; show customer ID, segment, recency, frequency, CLV, risk and recommended CRM action.

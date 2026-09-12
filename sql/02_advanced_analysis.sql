-- Executive KPIs
SELECT SUM(net_sales_inr) revenue, COUNT(DISTINCT order_id) orders, COUNT(DISTINCT customer_id) customers, SUM(net_sales_inr)/NULLIF(COUNT(DISTINCT order_id),0) aov, SUM(contribution_profit_inr)/NULLIF(SUM(net_sales_inr),0) contribution_margin FROM fact_order WHERE order_status IN ('Delivered','Returned');

-- RFM using window functions
WITH b AS (SELECT customer_id, DATE '2025-12-31'-MAX(order_date) recency_days, COUNT(DISTINCT order_id) frequency, SUM(net_sales_inr) monetary FROM fact_order WHERE order_status IN ('Delivered','Returned') GROUP BY customer_id), r AS (SELECT *, 6-NTILE(5) OVER(ORDER BY recency_days) r_score, NTILE(5) OVER(ORDER BY frequency) f_score, NTILE(5) OVER(ORDER BY monetary) m_score FROM b) SELECT *,r_score+f_score+m_score rfm_score FROM r;

-- Customer profitability
SELECT customer_id,SUM(net_sales_inr) revenue,SUM(gross_profit_inr) gross_profit,SUM(contribution_profit_inr) contribution_profit,COUNT(DISTINCT order_id) orders FROM fact_order WHERE order_status IN ('Delivered','Returned') GROUP BY customer_id ORDER BY contribution_profit DESC;

-- Product profitability
SELECT p.category,p.subcategory,p.product_name,SUM(o.net_sales_inr) revenue,SUM(o.contribution_profit_inr) contribution_profit,100*SUM(o.contribution_profit_inr)/NULLIF(SUM(o.net_sales_inr),0) contribution_margin_pct,100*SUM(o.is_returned)::numeric/NULLIF(COUNT(DISTINCT o.order_id),0) return_rate_pct FROM fact_order o JOIN dim_product p ON o.product_id=p.product_id WHERE o.order_status IN ('Delivered','Returned') GROUP BY p.category,p.subcategory,p.product_name ORDER BY contribution_profit DESC;

-- Monthly retention
WITH m AS (SELECT customer_id,DATE_TRUNC('month',order_date)::date month FROM fact_order WHERE order_status IN ('Delivered','Returned') GROUP BY customer_id,DATE_TRUNC('month',order_date)) SELECT a.month,COUNT(DISTINCT a.customer_id) active_customers,COUNT(DISTINCT CASE WHEN b.customer_id IS NOT NULL THEN a.customer_id END) returning_customers,100.0*COUNT(DISTINCT CASE WHEN b.customer_id IS NOT NULL THEN a.customer_id END)/NULLIF(COUNT(DISTINCT a.customer_id),0) retention_pct FROM m a LEFT JOIN m b ON b.customer_id=a.customer_id AND b.month=a.month-INTERVAL '1 month' GROUP BY a.month ORDER BY a.month;

-- Acquisition economics
SELECT c.acquisition_channel,COUNT(DISTINCT c.customer_id) customers,SUM(o.net_sales_inr) revenue,SUM(o.contribution_profit_inr) contribution_profit,SUM(o.net_sales_inr)/NULLIF(COUNT(DISTINCT c.customer_id),0) revenue_per_customer FROM dim_customer c JOIN fact_order o ON c.customer_id=o.customer_id WHERE o.order_status IN ('Delivered','Returned') GROUP BY c.acquisition_channel ORDER BY contribution_profit DESC;

-- Revenue concentration / Pareto
WITH cr AS (SELECT customer_id,SUM(net_sales_inr) revenue FROM fact_order WHERE order_status IN ('Delivered','Returned') GROUP BY customer_id), r AS (SELECT *,SUM(revenue) OVER(ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_revenue,SUM(revenue) OVER() total_revenue FROM cr) SELECT *,100*running_revenue/NULLIF(total_revenue,0) cumulative_revenue_pct FROM r ORDER BY revenue DESC;

-- Returns by category
SELECT p.category,COUNT(DISTINCT o.order_id) orders,SUM(o.is_returned) returns,100.0*SUM(o.is_returned)/NULLIF(COUNT(DISTINCT o.order_id),0) return_rate_pct FROM fact_order o JOIN dim_product p ON o.product_id=p.product_id GROUP BY p.category ORDER BY return_rate_pct DESC;

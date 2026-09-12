SELECT COUNT(*) total_customers,COUNT(DISTINCT customer_id) unique_customers FROM dim_customer;
SELECT COUNT(*) total_products,COUNT(DISTINCT product_id) unique_products FROM dim_product;
SELECT COUNT(*) total_orders,COUNT(DISTINCT order_id) unique_orders FROM fact_order;
SELECT COUNT(*) orphan_customers FROM fact_order o LEFT JOIN dim_customer c ON o.customer_id=c.customer_id WHERE c.customer_id IS NULL;
SELECT COUNT(*) orphan_products FROM fact_order o LEFT JOIN dim_product p ON o.product_id=p.product_id WHERE p.product_id IS NULL;
SELECT COUNT(*) negative_revenue_rows FROM fact_order WHERE net_sales_inr<0;
SELECT order_status,COUNT(*) rows FROM fact_order GROUP BY order_status;

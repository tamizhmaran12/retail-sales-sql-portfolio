# 🛒 Retail Sales SQL Portfolio

A beginner-to-intermediate **MySQL 8.0+** project that models a small retail business and answers real business questions with SQL: revenue trends, best-selling products, customer value, inventory risk and more.

Everything lives in a single script (`retail_sales_portfolio.sql`) that builds the database, loads sample data and runs 8 analytical queries.

---

## 📌 Project Highlights

- Designed a normalized **5-table relational schema** with primary keys, foreign keys, `CHECK` constraints and an `ENUM` order status
- Loaded realistic sample data: 8 customers, 8 products, 3 categories, 10 orders, 18 order items
- Wrote **8 business queries** using joins, aggregations, CTEs and window functions
- Added **indexes** on commonly joined and filtered columns
- Revenue is always calculated on **completed orders only**, so cancelled and pending orders don't inflate results

---

## 🗂️ Database Schema

```
customers ──< orders ──< order_items >── products >── categories
```

| Table | Purpose | Key columns |
|---|---|---|
| `customers` | Customer profiles | `customer_id`, `email` (unique), `city`, `joined_at` |
| `categories` | Product categories | `category_id`, `category_name` (unique) |
| `products` | Product catalogue and stock | `product_id`, `category_id`, `unit_price`, `stock_quantity` |
| `orders` | Order headers | `order_id`, `customer_id`, `order_date`, `order_status` |
| `order_items` | Line items per order | `order_id`, `product_id`, `quantity`, `unit_price`, `discount_amount` |

**Order status values:** `completed`, `pending`, `cancelled`

**Line total formula:** `(quantity × unit_price) − discount_amount`

**Indexes:** `orders(customer_id)`, `orders(order_date)`, `order_items(product_id)`

---

## 🔍 Business Questions Answered

| # | Question | SQL concepts used |
|---|---|---|
| 1 | What are the line totals for every completed order? | Multi-table `JOIN`, calculated columns |
| 2 | What are monthly revenue and order counts? | `GROUP BY`, `COUNT(DISTINCT)`, `DATE_FORMAT` |
| 3 | Which 5 products earn the most revenue? | Aggregation, `ORDER BY`, `LIMIT` |
| 4 | Who are the highest-value customers? | `DENSE_RANK()` window function |
| 5 | Which products need restocking? | `CASE` expressions |
| 6 | Which customers have never completed an order? | `LEFT JOIN` with `IS NULL` anti-join |
| 7 | What share of revenue does each category contribute? | CTE, `SUM() OVER ()` |
| 8 | Which orders are above or below average value? | CTE, `AVG() OVER ()`, `CASE` |

---

## 📊 Key Findings from the Sample Data

- **Total completed revenue:** ₹41,130 across 8 completed orders (average order value ≈ ₹5,141)
- **Monthly revenue:** June ₹20,291 vs July ₹20,839, so July was slightly ahead
- **Top product by revenue:** USB-C Hub (₹9,546), followed by Webcam (₹8,697) and Noise Cancelling Headphones (₹5,999)
- **Top customers:** Priya Nair (₹12,095) and Aisha Khan (₹11,995)
- **Category split:** Accessories 51.88% · Electronics 35.73% · Home Office 12.39%
- **Inactive customers:** Arjun Singh (cancelled order) and Vikram Shah (pending order) have no completed purchases
- **Inventory alert:** Noise Cancelling Headphones (9 units) needs reordering now; Webcam (12) and Monitor Stand (18) should be monitored

> Figures are derived from the sample data in this script and will change if you edit the inserts.

---

## 🚀 How to Run

**Requirements:** MySQL 8.0 or later (window functions and CTEs need 8.0+)

**Option 1: MySQL Workbench**
1. Open `retail_sales_portfolio.sql`
2. Click the ⚡ *Execute* button to run the whole script

**Option 2: Command line**
```bash
mysql -u root -p < retail_sales_portfolio.sql
```

The script drops and recreates the `retail_sales_portfolio` database each time, so it is safe to re-run.

---

## 🧠 Skills Demonstrated

`Database Design` · `Normalization` · `Primary & Foreign Keys` · `Constraints` · `Indexing` · `INNER / LEFT JOIN` · `GROUP BY & Aggregates` · `CTEs` · `Window Functions` · `CASE Logic` · `Business Analysis`

---

## 🔮 Possible Improvements

- Add a `returns` table and calculate net revenue
- Build a month-over-month growth query with `LAG()`
- Add customer segmentation (RFM analysis)
- Create views for common reports
- Connect the database to Power BI or Tableau for dashboards

---

## 📁 Repository Structure

```
.
├── retail_sales_portfolio.sql   # Schema, sample data and analysis queries
└── README.md
```

---

## 👤 Author

**Tamizhmaran S**
[LinkedIn](https://www.linkedin.com/in/tamizh-maran-s/) · [GitHub](https://github.com/tamizhmaran12)

⭐ If you found this useful, feel free to star the repo!

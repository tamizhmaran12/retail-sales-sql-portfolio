-- retail sales sql portfolio
-- mysql 8.0+
-- run this file as a script in mysql workbench or from the mysql command line.

drop database if exists retail_sales_portfolio;
create database retail_sales_portfolio;
use retail_sales_portfolio;

create table customers (
    customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    email varchar(150) not null unique,
    city varchar(80) not null,
    joined_at date not null
);

create table categories (
    category_id int primary key auto_increment,
    category_name varchar(80) not null unique
);

create table products (
    product_id int primary key auto_increment,
    product_name varchar(120) not null,
    category_id int not null,
    unit_price decimal(10,2) not null,
    stock_quantity int not null,
    foreign key (category_id) references categories(category_id),
    check (unit_price >= 0),
    check (stock_quantity >= 0)
);

create table orders (
    order_id int primary key auto_increment,
    customer_id int not null,
    order_date date not null,
    order_status enum('completed', 'pending', 'cancelled') not null,
    foreign key (customer_id) references customers(customer_id)
);

create table order_items (
    order_item_id int primary key auto_increment,
    order_id int not null,
    product_id int not null,
    quantity int not null,
    unit_price decimal(10,2) not null,
    discount_amount decimal(10,2) not null default 0.00,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id),
    check (quantity > 0),
    check (unit_price >= 0),
    check (discount_amount >= 0)
);

insert into customers (customer_name, email, city, joined_at) values
('aisha khan', 'aisha.khan@example.com', 'mumbai', '2024-01-12'),
('rohan mehta', 'rohan.mehta@example.com', 'delhi', '2024-02-03'),
('priya nair', 'priya.nair@example.com', 'bengaluru', '2024-02-20'),
('arjun singh', 'arjun.singh@example.com', 'pune', '2024-03-11'),
('neha das', 'neha.das@example.com', 'kolkata', '2024-03-29'),
('vikram shah', 'vikram.shah@example.com', 'ahmedabad', '2024-04-16'),
('sana ali', 'sana.ali@example.com', 'hyderabad', '2024-05-05'),
('kabir joshi', 'kabir.joshi@example.com', 'mumbai', '2024-05-22');

insert into categories (category_name) values
('electronics'),
('home office'),
('accessories');

insert into products (product_name, category_id, unit_price, stock_quantity) values
('wireless mouse', 3, 899.00, 65),
('mechanical keyboard', 3, 3499.00, 32),
('usb-c hub', 3, 2499.00, 41),
('monitor stand', 2, 1899.00, 18),
('desk lamp', 2, 1299.00, 24),
('webcam', 1, 2999.00, 12),
('noise cancelling headphones', 1, 6499.00, 9),
('laptop sleeve', 3, 1199.00, 38);

insert into orders (customer_id, order_date, order_status) values
(1, '2024-06-02', 'completed'),
(2, '2024-06-03', 'completed'),
(3, '2024-06-04', 'completed'),
(1, '2024-06-15', 'completed'),
(4, '2024-06-18', 'cancelled'),
(5, '2024-07-01', 'completed'),
(6, '2024-07-04', 'pending'),
(7, '2024-07-08', 'completed'),
(3, '2024-07-11', 'completed'),
(8, '2024-07-15', 'completed');

insert into order_items (order_id, product_id, quantity, unit_price, discount_amount) values
(1, 1, 2, 899.00, 0.00),
(1, 3, 1, 2499.00, 200.00),
(2, 2, 1, 3499.00, 0.00),
(2, 8, 1, 1199.00, 0.00),
(3, 6, 1, 2999.00, 300.00),
(3, 1, 1, 899.00, 0.00),
(4, 7, 1, 6499.00, 500.00),
(4, 4, 1, 1899.00, 0.00),
(5, 5, 2, 1299.00, 0.00),
(6, 3, 2, 2499.00, 250.00),
(6, 8, 1, 1199.00, 0.00),
(7, 2, 1, 3499.00, 0.00),
(8, 1, 1, 899.00, 0.00),
(8, 5, 1, 1299.00, 0.00),
(9, 6, 2, 2999.00, 0.00),
(9, 3, 1, 2499.00, 0.00),
(10, 8, 2, 1199.00, 100.00),
(10, 4, 1, 1899.00, 0.00);

create index idx_orders_customer_id on orders(customer_id);
create index idx_orders_order_date on orders(order_date);
create index idx_order_items_product_id on order_items(product_id);

-- 1. view completed-order line totals.
select o.order_id, o.order_date, c.customer_name, p.product_name, oi.quantity, oi.unit_price, oi.discount_amount,
    (oi.quantity * oi.unit_price) - oi.discount_amount as line_total
from orders as o
join customers as c on c.customer_id = o.customer_id
join order_items as oi on oi.order_id = o.order_id
join products as p on p.product_id = oi.product_id
where o.order_status = 'completed'
order by o.order_date, o.order_id;

-- 2. calculate revenue and order count by month.
select date_format(o.order_date, '%y-%m') as order_month, count(distinct o.order_id) as completed_orders,
    round(sum((oi.quantity * oi.unit_price) - oi.discount_amount), 2) as revenue
from orders as o
join order_items as oi on oi.order_id = o.order_id
where o.order_status = 'completed'
group by date_format(o.order_date, '%y-%m')
order by order_month;

-- 3. find the five best-selling products by revenue.
select p.product_name, sum(oi.quantity) as units_sold,
    round(sum((oi.quantity * oi.unit_price) - oi.discount_amount), 2) as revenue
from order_items as oi
join orders as o on o.order_id = oi.order_id
join products as p on p.product_id = oi.product_id
where o.order_status = 'completed'
group by p.product_id, p.product_name
order by revenue desc
limit 5;

-- 4. rank customers by lifetime completed-order spend.
select c.customer_id, c.customer_name,
    round(sum((oi.quantity * oi.unit_price) - oi.discount_amount), 2) as lifetime_value,
    dense_rank() over (order by sum((oi.quantity * oi.unit_price) - oi.discount_amount) desc) as customer_rank
from customers as c
join orders as o on o.customer_id = c.customer_id
join order_items as oi on oi.order_id = o.order_id
where o.order_status = 'completed'
group by c.customer_id, c.customer_name
order by customer_rank, c.customer_name;

-- 5. identify products below the reorder threshold.
select p.product_name, c.category_name, p.stock_quantity,
    case
        when p.stock_quantity <= 10 then 'reorder now'
        when p.stock_quantity <= 20 then 'monitor stock'
        else 'stock healthy'
    end as inventory_status
from products as p
join categories as c on c.category_id = p.category_id
order by p.stock_quantity;

-- 6. return customers without a completed order.
select c.customer_id, c.customer_name, c.email, c.city
from customers as c
left join orders as o on o.customer_id = c.customer_id and o.order_status = 'completed'
where o.order_id is null
order by c.customer_name;

-- 7. calculate each category's share of completed-order revenue.
with category_revenue as (
    select c.category_name, sum((oi.quantity * oi.unit_price) - oi.discount_amount) as revenue
    from categories as c
    join products as p on p.category_id = c.category_id
    join order_items as oi on oi.product_id = p.product_id
    join orders as o on o.order_id = oi.order_id
    where o.order_status = 'completed'
    group by c.category_name
)
select category_name, round(revenue, 2) as revenue,
    round(100 * revenue / sum(revenue) over (), 2) as revenue_share_percent
from category_revenue
order by revenue desc;

-- 8. compare each completed order with the average completed-order value.
with order_totals as (
    select o.order_id, o.order_date, c.customer_name,
        sum((oi.quantity * oi.unit_price) - oi.discount_amount) as order_total
    from orders as o
    join customers as c on c.customer_id = o.customer_id
    join order_items as oi on oi.order_id = o.order_id
    where o.order_status = 'completed'
    group by o.order_id, o.order_date, c.customer_name
)
select order_id, order_date, customer_name, round(order_total, 2) as order_total,
    round(avg(order_total) over (), 2) as average_order_value,
    case
        when order_total > avg(order_total) over () then 'above average'
        when order_total < avg(order_total) over () then 'below average'
        else 'average'
    end as order_value_segment
from order_totals
order by order_total desc;

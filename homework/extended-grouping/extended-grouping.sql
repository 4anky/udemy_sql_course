-- Домашнее задание

-- 1. Вывести сумму продаж (цена * кол-во) по каждому сотруднику
--    с подсчётом полного итога (полной суммы по всем сотрудникам)
--    отсортировав по сумме продаж (по убыванию).

select
	employee_id,
	sum(quantity * unit_price) as sales_amount
from
	orders
	join order_details using(order_id)
group by rollup(employee_id)
order by sales_amount desc;

-- 2. Вывести отчёт показывающий сумму продаж по сотрудникам и
--    странам отгрузки с подытогами по сотрудникам и общим итогом.

select
	employee_id,
	ship_country,
	sum(quantity * unit_price) as sales_amount
from
	orders
	join order_details using(order_id)
group by rollup(employee_id, ship_country)
order by employee_id, ship_country;

-- 3. Вывести отчёт показывающий сумму продаж по сотрудникам, странам отгрузки,
--    сотрудникам и странам отгрузки с подытогами по сотрудникам и общим итогом.

select
	employee_id,
	ship_country,
	sum(quantity * unit_price) as sales_amount
from
	orders
	join order_details using(order_id)
group by cube(employee_id, ship_country)
order by employee_id, ship_country;

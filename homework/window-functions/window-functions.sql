-- 1) Вывести отчёт показывающий по сотрудникам суммы продаж SUM(unit_price * quantity),
--    и сопоставляющий их со средним значением суммы продаж по сотрудникам (AVG по
--    SUM(unit_price * quantity)) сортированный по сумме продаж по убыванию.
SELECT
	employee_id,
	sales_sum,
	AVG(sales_sum) OVER () AS avg_sales
FROM (
	SELECT
		DISTINCT(employee_id) AS employee_id,
		SUM(unit_price * quantity) OVER (PARTITION BY employee_id) AS sales_sum
	FROM orders JOIN order_details ON orders.order_id = order_details.order_id
)
ORDER BY sales_sum DESC;


-- 2) Вывести ранг сотрудников по их зарплате, без пропусков.
--    Также вывести имя, фамилию и должность.
--
--    NB! Поле salary отсутствовало, оно и его значения были собственноручно
--        вставлены в northwind.sql
SELECT
	first_name,
	last_name,
	title,
	salary,
	DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank
FROM employees;
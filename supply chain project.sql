create database supply_chain_project

select * from dbo.supply_chain

--Inventory & Cost Analysis: Kaun si product categories hain jinki total inventory cost 50,000 se zyada hai, aur unka average cost kya hai?

select category , sum(Quantity_Ordered * Unit_Cost) as total_inventory 
from dbo.supply_chain
group by category 
having sum(Quantity_Ordered * Unit_Cost) > 50000
order by total_inventory desc


--Business Problem: Hamaare customers complain kar rahe hain ki deliveries mein bohot time lag raha hai. Mujhe har region (Warehouse_Region) ka average delivery time (Days) calculate karke do.

select warehouse_region  , 
avg(datediff(day , order_date ,  delivery_date)) as total_days 
from dbo.supply_chain
group by warehouse_region  


--Business Problem: Dashboard par hume har category ke Top 2 sabse zyada bechne wale products ka ek section banana hai.


with ranked_products as (
select category , product_name , 
sum (quantity_ordered) as total_quantity ,
dense_rank () over(partition by category order by sum(quantity_ordered)desc) as product_rank
from dbo.supply_chain
group by category , product_name
)
select category , product_name , total_quantity , product_rank 
from ranked_products
where product_rank <= 2



-- Dashboard par ek filter lagane ke liye, mujhe har order ko uski quantity ke hisab se classify karna hai:

--Agar quantity 100 se kam hai -> 'Small Order'

--Agar 100 se 300 ke beech hai -> 'Medium Order'

--Agar 300 se zyada hai -> 'Bulk Order'


select Order_ID, Product_Name, Quantity_Ordered , 
case 
when Quantity_Ordered > 300 then 'Bulk Order'
when Quantity_Ordered between 100 and 300 then 'Medium Order'
when Quantity_Ordered < 100 then 'small_orders'
end as Order_Class 
from dbo.supply_chain 
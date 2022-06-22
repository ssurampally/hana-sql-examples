// to check how many PO are associated to one invoice. 

select distinct belnr from
(select belnr, row_number() over (partition by belnr) as row_count from
	(select belnr, ebeln from rseg where gjahr = '2020' 
     group by belnr, ebeln  
    ) 
 ) where row_count > 1 ;
 
 ------------------------------------
 
 // to check the duplicates of a column value.
 
 select inventory_item_id, row_count
     from
      (select inventory_item_id, row_number() over (partition by inventory_item_id) as row_count
       from Inventory_table --where 
       )
      where row_count > 1 ;
      
----------------------------------------------

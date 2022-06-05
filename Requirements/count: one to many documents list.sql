// to check how many PO are associated to one invoice. 

select distinct belnr from
(select belnr, row_number() over (partition by belnr) as row_count from
	(select belnr, ebeln from rseg where gjahr = '2020' 
     group by belnr, ebeln  
    ) 
 ) where row_count > 1 ;
 
 ------------------------------------

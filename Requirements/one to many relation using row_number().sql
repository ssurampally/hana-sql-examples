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
// alternatively you can use count() function

//Actually it is more comfortable to do the duplicate or per count logic with COUNT() instead of row_number()


SELECT ITEM_NUMBER, ROW_COUNT FROM 
  (SELECT SEGMENT1 AS ITEM_NUMBER, count(1) AS ROW_COUNT FROM Item_table -- WHERE
         GROUP BY SEGMENT1
   ) WHERE ROW_COUNT > 1 ;
   
 -----------------------
// for 2 or more columns -- 
select vendor_id, address_seq_num, row_count from
  (select vendor_id, address_seq_num, count(1) as row_count from Vendor_master
         group by vendor_id, address_seq_num
   ) where row_count > 1 ;
   
 ------------------------
 
 // this logic can be used while you using Join data data result
 
  select belnr, row_count from
 (
 select H.BELNR, COUNT(1) as row_count from BKPF H LEFT JOIN BSEG I ON H.BELNR = I.BELNR AND H.GJAHR = I.GJAHR AND H.BUKRS = I.BUKRS
                         WHERE H.TCODE  IN  ('MIRO','MRIS','MRRL')  AND I.KOART = 'K' AND I.GJAHR = '2021' AND i.BUKRS = '1000' AND I.BELNR IS NOT NULL
     group by H.belnr
                         
  ) where row_count = 1 ; 

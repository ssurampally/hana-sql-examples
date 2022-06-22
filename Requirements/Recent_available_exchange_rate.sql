FUNCTION SSURAMPALLY.TF_CURRENCY_RATE_INV_DATE" ( ) 
	RETURNS TABLE
	   (INVOICE_DT DATE,
	    VALIDITY_DT DATE,
	    FROM_CUR NVARCHAR(3),
	    RATE_MULT DECIMAL(15,8),
	    RATE_DIV DECIMAL(15,8)
	   )
	LANGUAGE SQLSCRIPT
	SQL SECURITY INVOKER AS
  
BEGIN

 RETURN
 
  -- Self join on the Currency Rate table to get match on effective date
  SELECT DISTINCT L.INVOICE_DT, L.VALIDITY_DT, VR.FROM_CUR AS FROM_CUR, VR.RATE_MULT AS RATE_MULT, VR.RATE_DIV AS RATE_DIV FROM SSURAMPALLY.TABLE_CURRENCY VR
 	INNER JOIN 
   -- Aggregate Effective date (MAX) based on Invoice date from transaction table, FROM_CURR in Currency table.
 	    (SELECT S.INVOICE_DT, FROM_CUR, MAX(S.EFFDT) AS VALIDITY_DT FROM  
            -- to get all effective date currency rate that >= Invoice date. 
  		    (SELECT TO_DATE(V.INVOICE_DT) AS INVOICE_DT, TO_DATE(R.EFFDT) AS EFFDT , R.FROM_CUR FROM SSURAMPALLY.TABLE_INVOICE V INNER JOIN SSURMAPALLY.TABLE_CURRENCY R
                                	ON V.INVOICE_DT >= R.EFFDT 
                             AND R."TO_CUR" = 'USD' and R."RT_TYPE" = 'CRRNT'
            ) S GROUP BY INVOICE_DT, FROM_CUR
        ) L ON VR.EFFDT = L.VALIDITY_DT AND VR.FROM_CUR = L.FROM_CUR
          WHERE VR."TO_CUR" = 'USD' and VR."RT_TYPE" = 'CRRNT' ; 
             
END;

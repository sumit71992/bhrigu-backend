SELECT
       
       
        (SELECT JSON_ARRAYAGG(JSON_OBJECT('id', sp.id, 'title', sp.title))
         FROM ProductSuggestions ps
         JOIN Product sp ON ps.suggestedProductId = sp.id
         WHERE ps.productId = p.id) as suggestedProducts,
      
        
         LEFT JOIN
         IncludedKit ik
       ON
         p.includedKitId = ik.id
       LEFT JOIN
         ProductIncludedKitInventory piki
       ON
         ik.id = piki.includedKitId
       LEFT JOIN
         Inventory i
       ON
         piki.inventoryId = i.id
    
      
      
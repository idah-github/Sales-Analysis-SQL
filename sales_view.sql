-- DROP VIEW IF EXISTS sales_view;
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sales_view` AS
    SELECT 
        `sales`.`Order ID` AS `Order_ID`,
        `sales`.`Sales Channel` AS `Channel`,
        `sales`.`Item Type` AS `Type`,
        `sales`.`Units Sold` AS `Units_Sold`,
        `sales`.`Unit_Price` AS `Unit_Price`,
        `sales`.`Unit_Cost` AS `Unit_Cost`,
        (`sales`.`Units Sold` * `sales`.`Unit_Price`) AS `Revenue`,
        (`sales`.`Units Sold` * `sales`.`Unit_Cost`) AS `Total_Cost`,
        ((`sales`.`Units Sold` * `sales`.`Unit_Price`) - (`sales`.`Units Sold` * `sales`.`Unit_Cost`)) AS `Profit`
    FROM
        (SELECT 
            `o`.`Order ID` AS `Order ID`,
                `o`.`Item Type` AS `Item Type`,
                `o`.`Sales Channel` AS `Sales Channel`,
                `o`.`Order Date` AS `Order Date`,
                `o`.`Region` AS `Region`,
                `o`.`Country` AS `Country`,
                `p`.`Units Sold` AS `Units Sold`,
                CAST(REPLACE(`p`.`Unit Price`, '$', '') AS UNSIGNED) AS `Unit_Price`,
                CAST(REPLACE(`p`.`Unit Cost`, '$', '') AS UNSIGNED) AS `Unit_Cost`,
                CAST(REPLACE(`p`.`Total Profit`, '$', '') AS UNSIGNED) AS `Total_Profit`
        FROM
            (`amazonsalesorders` `o`
        JOIN `amazonsalesprice` `p` ON ((`o`.`Order ID` = `p`.`Order ID`)))
        GROUP BY `o`.`Order ID` , `o`.`Item Type` , `o`.`Sales Channel` , 
        `o`.`Order Date` , `o`.`Region` , `o`.`Country` , 
        `p`.`Units Sold` , `p`.`Unit Price` , `p`.`Unit Cost` , `p`.`Total Profit`) `sales`;
        
SELECT * FROM sales_view;

ALTER VIEW `sales_view` AS
    SELECT 
        `sales`.`Order ID` AS `Order_ID`,
		`Order Date`,
        Country,
         Region,
        `sales`.`Sales Channel` AS `Channel`,
        `sales`.`Item Type` AS `Type`,
        `sales`.`Units Sold` AS `Units_Sold`,
        `sales`.`Unit_Price` AS `Unit_Price`,
        `sales`.`Unit_Cost` AS `Unit_Cost`,
        (`sales`.`Units Sold` * `sales`.`Unit_Price`) AS `Revenue`,
        (`sales`.`Units Sold` * `sales`.`Unit_Cost`) AS `Total_Cost`,
        ((`sales`.`Units Sold` * `sales`.`Unit_Price`) - (`sales`.`Units Sold` * `sales`.`Unit_Cost`)) AS `Profit`
    FROM
        (SELECT 
            `o`.`Order ID` AS `Order ID`,
                `o`.`Item Type` AS `Item Type`,
                `o`.`Sales Channel` AS `Sales Channel`,
                `o`.`Order Date` AS `Order Date`,
                `o`.`Region` AS `Region`,
                `o`.`Country` AS `Country`,
                `p`.`Units Sold` AS `Units Sold`,
                CAST(REPLACE(`p`.`Unit Price`, '$', '') AS UNSIGNED) AS `Unit_Price`,
                CAST(REPLACE(`p`.`Unit Cost`, '$', '') AS UNSIGNED) AS `Unit_Cost`,
                CAST(REPLACE(`p`.`Total Profit`, '$', '') AS UNSIGNED) AS `Total_Profit`
        FROM
            (`amazonsalesorders` `o`
        JOIN `amazonsalesprice` `p` ON ((`o`.`Order ID` = `p`.`Order ID`)))
        GROUP BY `o`.`Order ID` , `o`.`Item Type` , `o`.`Sales Channel` , 
        `o`.`Order Date` , `o`.`Region` , `o`.`Country` , 
        `p`.`Units Sold` , `p`.`Unit Price` , `p`.`Unit Cost` , `p`.`Total Profit`) `sales`;
        
       
       
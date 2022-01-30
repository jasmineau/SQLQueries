/*

Cleaning Data in SQL Queries

*/


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT CONVERT(Date,SaleDate)
FROM ...


UPDATE ...
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE ...
ADD SaleDateConverted Date;

UPDATE ... 
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Address data
-- fill in missing data 

SELECT * 
FROM ...
WHERE Address IS NULL


-- use self joint table 
SELECT a.ID, a.Address, b.ID, b.Address, ISNULL(a.Address,b.Address)    -- if a.adress is null, replace it with b.address
FROM ... a
JOIN ... b
ON a.ID = b.ID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.Address IS NULL


UPDATE a
SET Address = ISNULL(a.Address,b.Address)
FFROM ... a
JOIN ... b
ON  a.ID = b.ID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.Address IS NULL




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City)
-- Adress: "100 Street, Kowloon"


SELECT
SUBSTRING(Address, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address
, SUBSTRING(Address, CHARINDEX(',', PropertyAddress) + 1 , LEN(Address)) AS Address
From ...


ALTER TABLE ...
ADD SplitAddress Nvarchar(255);

Update ...
SET SplitAddress = SUBSTRING(Address, 1, CHARINDEX(',', Address) -1 )



ALTER TABLE ...
ADD SplitCity Nvarchar(255);

UPDATE ...
SET SplitCity = SUBSTRING(Address, CHARINDEX(',', Address) + 1 , LEN(Address))



-- Breaking out Address into Individual Columns (Address,District, City)
-- Address: "100 Street, Kowloon.HK"

SELECT
PARSENAME(REPLACE(Address, ',', '.') , 3)
,PARSENAME(REPLACE(Address, ',', '.') , 2)
,PARSENAME(REPLACE(Address, ',', '.') , 1)
From ...


ALTER TABLE ...
ADD SplitAddress Nvarchar(255);

UPDATE ...
SET SplitAddress = PARSENAME(REPLACE(Address, ',', '.') , 3)


ALTER TABLE ...
ADD SplitDistrict Nvarchar(255);

UPDATE ...
SET SplitDistrict = PARSENAME(REPLACE(Address, ',', '.') , 2)



ALTER TABLE ...
ADD rSplitCity Nvarchar(255);

UPDATE ...
SET SplitCity = PARSENAME(REPLACE(Address, ',', '.') , 1)



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "YesNo" field
-- YesNo: "Y", "N", "Yes", "No"


SELECT DISTINCT(YesNo), COUNT(YesNo)
FROM ...
GROUP BY YesNo
ORDER BY 2


SELECT YesNo, CASE When YesNo = 'Y' THEN 'Yes' When YesNo = 'N' THEN 'No' ELSE YesNo END
FROM ...


UPDATE ...
SET YesNo = CASE When YesNo = 'Y' THEN 'Yes'When YesNo = 'N' THEN 'No' ELSE YesNo END




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates using ROW_NUMBER()

WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY ID, Address, SalePrice, SaleDate ORDER BY UniqueID) row_num
FROM ...
-- ORDER BY ParcelID
) row_num


-- duplicates are row_number > 2
SELECT *
FROM RowNumCTE
WHERE row_num > 1


-- delete
DELETE
FROM RowNumCTE
WHERE row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


ALTER TABLE ...
DROP COLUMN Address, Address, SaleDate


























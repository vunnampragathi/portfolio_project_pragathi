select * from [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]

--- data cleaning
-- cleaning the property address column

select * from [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
--where PropertyAddress is null
order by ParcelID

-- the same parcel id should have same property adress s lets self join the table and check it
-- so first check the same parcel id where property address is null
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress from [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning] a
join [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning] b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

---lets replace the property address which are null
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , isnull(a.PropertyAddress, b.PropertyAddress)
from [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning] a
join [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning] b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress= isnull(a.PropertyAddress, b.PropertyAddress)
from [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning] a
join [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning] b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null




---cleaning the property adress column. Separating the address into different columns

select PropertyAddress from [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]

select
substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

from [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]

ALTER TABLE [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
Add PropertySplitAddress Nvarchar(255);

Update [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
Add PropertySplitCity Nvarchar(255);

Update [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


-- lets do the same for owner address using parse name function instead of substring

Select *
From [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]


ALTER TABLE [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
Add OwnerSplitAddress Nvarchar(255);

Update [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
Add OwnerSplitCity Nvarchar(255);

Update [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
Add OwnerSplitState Nvarchar(255);

Update [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]


--- lets remove the duplicate values.
--- lets do it by windows functions. Here i am using the row number function to delete duplicates.

with RownumCTE as (
Select *,
row_number()  over(
partition by ParcelID,
                 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by UniqueID
				 ) as Row_num
From [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
)
Select *
--Delete
from RownumCTE
where Row_num > 1
--order by PropertyAddress




----- lets delete some unsued columns which are not used for our analysis purpose

Select * from  [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]

Alter Table [dbo].[Nashville Housing Data for Data Cleaning]
drop column PropertyAddress, OwnerAddress, TaxDistrict

Select * from  [pragathi portfolio project].[dbo].[Nashville Housing Data for Data Cleaning]
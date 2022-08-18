/* cleaning data in SQL Qureries */

select *
from [portfolioProject ].dbo.NashvilleHousing


/* standardize date formate  */

select SaleDate, CONVERT(date,SaleDate)
from [portfolioProject ].dbo.NashvilleHousing;

update [portfolioProject ].dbo.NashvilleHousing
set SaleDate = CONVERT(date,SaleDate);                              

alter table [portfolioProject ].dbo.NashvilleHousing
add salesDateConverted date;

update [portfolioProject ].dbo.NashvilleHousing
set salesDateConverted = CONVERT(date,SaleDate);

select salesDateConverted
from [portfolioProject ].dbo.NashvilleHousing;


----------------------------------------------------------------------------------------

/* Populate property address data */

select a.[UniqueID ],a.PropertyAddress ,b.[UniqueID ], b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolioProject ].dbo.NashvilleHousing a
join [portfolioProject ].dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolioProject ].dbo.NashvilleHousing a
join [portfolioProject ].dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


/* seperate city and address from Proterty address */

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) as City
from [portfolioProject ].dbo.NashvilleHousing

alter table [portfolioProject ].dbo.NashvilleHousing
add PropertyAddressNew Nvarchar(255);

alter table [portfolioProject ].dbo.NashvilleHousing
add PropertyCity Nvarchar(255);

update [portfolioProject ].dbo.NashvilleHousing
set
PropertyAddressNew =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

update [portfolioProject ].dbo.NashvilleHousing
set
PropertyCity =SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))

/* ALTER TABLE [portfolioProject ].dbo.NashvilleHousing
DROP COLUMN PropertyCity  */

------------------------------------------------------------------------

/* seperate city and address from Owner address */

select OwnerAddress
from [portfolioProject ].dbo.NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) Owner_State, 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) Owner_City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) Owner_Address, ParcelID
from [portfolioProject ].dbo.NashvilleHousing

alter table [portfolioProject ].dbo.NashvilleHousing
add Owner_State Nvarchar(255), Owner_City Nvarchar(255), Owner_Address Nvarchar(255);

update [portfolioProject ].dbo.NashvilleHousing
set
Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) , 
Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) ,
Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 


-----------------------------------------------------------------------------------

/* cleaning data in soldAsVacant */

select DISTINCT(SoldAsVacant)
from [portfolioProject ].dbo.NashvilleHousing

select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from [portfolioProject ].dbo.NashvilleHousing

update [portfolioProject ].dbo.NashvilleHousing
set
SoldAsVacant= CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from [portfolioProject ].dbo.NashvilleHousing


-----------------------------------------------------------------

/* remove duplicate */

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [portfolioProject ].dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

	
/*same code as above but to delete the duplicate rows, above one is to view only */



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [portfolioProject ].dbo.NashvilleHousing
--order by ParcelID
)
delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


/* delete unused data */

select TaxDistrict,OwnerAddress,PropertyAddress, SaleDate
from [portfolioProject ].dbo.NashvilleHousing

ALTER TABLE [portfolioProject ].dbo.NashvilleHousing
DROP COLUMN TaxDistrict,OwnerAddress,PropertyAddress,SaleDate








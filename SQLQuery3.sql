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
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress), LEN(PropertyAddress)) as City
from [portfolioProject ].dbo.NashvilleHousing

alter table [portfolioProject ].dbo.NashvilleHousing
add PropertyAddressNew Nvarchar(255);

alter table [portfolioProject ].dbo.NashvilleHousing
add PropertyCity Nvarchar(255);

update [portfolioProject ].dbo.NashvilleHousing
set
PropertyAddressNew =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress))

update [portfolioProject ].dbo.NashvilleHousing
set
PropertyCity =SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))

ALTER TABLE [portfolioProject ].dbo.NashvilleHousing
DROP COLUMN PropertyCity





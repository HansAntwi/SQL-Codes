select *
from PortfolioProject..nashvillehousing

select saledate, salesdateconverted
from PortfolioProject..nashvillehousing

update nashvillehousing
set SaleDate = CAST(SaleDate as Date)

alter table nashvillehousing
add SalesDateConverted Date;

update nashvillehousing
set salesdateconverted = CAST(SaleDate as Date)


select SalesDateConverted--, count(salesdateconverted) over (partition by Salesdateconverted) as SalesDateCount
from PortfolioProject..NashvilleHousing
order by SalesDateConverted


--populate property address
select *
from PortfolioProject..nashvillehousing
--where PropertyAddress is null
order by ParcelID


select initable.parcelid, initable.propertyaddress, duptable.parcelid, duptable.propertyaddress
from PortfolioProject..NashvilleHousing as initable
join PortfolioProject..NashvilleHousing as duptable
	on initable.parcelid = duptable.parcelid
	and initable.uniqueid <> duptable.uniqueid
--where initable.ParcelID is null

select initable.parcelid, initable.propertyaddress, duptable.parcelid, 
	duptable.propertyaddress,isnull(initable.propertyaddress, duptable.PropertyAddress) as ToFillInitableCol
from PortfolioProject..NashvilleHousing as initable
join PortfolioProject..NashvilleHousing as duptable
	on initable.parcelid = duptable.parcelid
	and initable.uniqueid <> duptable.uniqueid
where initable.PropertyAddress is null


update initable
set PropertyAddress = isnull(initable.propertyaddress, duptable.PropertyAddress)
from PortfolioProject..NashvilleHousing as initable
join PortfolioProject..NashvilleHousing as duptable
	on initable.parcelid = duptable.parcelid
	and initable.uniqueid <> duptable.uniqueid
where initable.PropertyAddress is null


select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--group by propertyaddress


--BREAKING ADDRESS

select *
from PortfolioProject..NashvilleHousing


select 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address,
	SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress)) as CityExtract
from portfolioproject..nashvillehousing
order by CityExtract


alter table NashvilleHousing
add PropertyAddressSplit nvarchar(255);

alter table NashvilleHousing
add City nvarchar(255);


update NashvilleHousing
set propertyaddresssplit = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)

select * 
from NashvilleHousing


update NashvilleHousing
set City = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress)) 



select OwnerAddress
from NashvilleHousing


select
PARSENAME(replace(owneraddress, ',', '.'), 3),
parsename(replace(owneraddress, ',' , '.'), 2),
parsename(replace(owneraddress, ',' , '.'), 1)
from NashvilleHousing



select SoldAsVacant, COUNT(soldasvacant) as count
from NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant


alter table nashvillehousing
add OwnerSplitAddress nvarchar (255)


update NashvilleHousing
set
ownersplitaddress = PARSENAME(replace(owneraddress, ',', '.'), 3)

alter table nashvillehousing
add OwnerSplitCity nvarchar (255)

alter table nashvillehousing
add OwnerSplitState nvarchar (255)


update NashvilleHousing
set
OwnerSplitCity = parsename(replace(owneraddress, ',' , '.'), 2)

update NashvilleHousing
set
OwnerSplitState = parsename(replace(owneraddress, ',' , '.'), 1)



--change Y and N to Yes and No in "Sold as vacant" field

select distinct SoldAsVacant, count(soldasvacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

alter table nashvillehousing
add NewSoldAsVacant nvarchar (255)

select SoldAsVacant,
case when SoldAsVacant = 'y' then 'Yes'
	 when SoldAsVacant = 'n' then 'No'
	 Else SoldAsVacant
end as replacement
from NashvilleHousing
order by 1

update NashvilleHousing
set SoldAsVacant = 
case when SoldAsVacant = 'y' then 'Yes'
	 when SoldAsVacant = 'n' then 'No'
	 Else SoldAsVacant
end



---removing duplicates
with RowNumCte as(
select *, 
ROW_NUMBER() over (
	partition by parcelID,
				 propertyaddress,
				 Saleprice,
				 legalreference
				 order by
				 uniqueid) Countnum
from NashvilleHousing)
--order by Countnum desc
select * 
from RowNumCte
where Countnum > 1
--order by PropertyAddress


select *
from NashvilleHousing


--delete unused column
alter table nashvillehousing
drop column owneraddress, tax

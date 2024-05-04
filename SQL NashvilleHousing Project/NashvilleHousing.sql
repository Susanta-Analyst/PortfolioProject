

---- CLEANING UNNECCESARY DATA IN NASHVILLEHOUSING ----

Select *
From dbo.NashvilleHousing


--STANDARDISE DATA FORMAT--
 
 Select SaleDate
 From dbo.NashvilleHousing

-- The above execution reveals that SaleDate is with timing--
-- So Saledate needs to be changed to be a single parameter without any timing--
-- To enable this the followwing command is applied--

Select SaleDate, Convert(Date,SaleDate) 
From dbo.NashvilleHousing

-- Changing SaleDate ColumnName to SaleDateConverted without using AS command


Select SaleDate, Convert(Date,SaleDate) 
From dbo.NashvilleHousing

-- The above command did not bring any change in the column name with changed content in it--
-- So to enable changed column name along with changed content, the following command is applied--

Update NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

-- The above Command too does not change the content of SaleDate exactly as per the content given in (No Column Name)--

--So we need to change the column Name from SaleDate to SaleDateConvertd at first by using command Alter Table before enabling the Update in NashvilleHousing
-- Next we need to set the SaleDateConverted Column equivalent to No Column Name


ALTER TABLE NashVilleHousing
Add SaleDateConverted Date 

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

Select SaleDateConverted, Convert(Date,SaleDate) 
From dbo.NashvilleHousing


---- Populating the Property Address Data Or Replacing Null Address with Originally Existing Addresss ----

Select PropertyAddress
From dbo.NashvilleHousing


Select PropertyAddress
From dbo.NashvilleHousing
Where PropertyAddress is Null
-- The above command gives zero result since not a single address is null--


Select *
From dbo.NashvilleHousing
Where PropertyAddress is Null

-- The above command gives zero result since not a single address is null--


Select *
From dbo.NashvilleHousing
Where PropertyAddress is Null
Order By ParcelID
-- The above command gives zero result since not a single address is null--



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
       on a.ParcelID = b.ParcelID
     and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is Null
Order By ParcelID

--The above command highlights 35 rows of Property Address showing NULL values whereas those have an address in fact
-- Now we want to replace the NULL Property Address with the actual address for these 35 rows.The following command does the work --

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
       on a.ParcelID = b.ParcelID
     and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is Null
Order By ParcelID

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
       on a.ParcelID = b.ParcelID
     and a.[UniqueID] <> b.[UniqueID]

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
       on a.ParcelID = b.ParcelID
     and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is Null
Order By ParcelID

--The above Command replaces Property Address of Table a BY Property Address of Table b
-- Now it is striking to note that since the NULL values of Property Address in Table a is replaced by Column B so the last line "a.PropertyAddress is Null" shows no value 
-- This is becuse no Null Value is there exiesting. All replaced with Address from Table b



--BREAKING DOWN ADDRESS INRO SEPARATE COLUMNS ( Address, City and State)

Select PropertyAddress
From dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address,
CHARINDEX (',', PropertyAddress)
 --CHARINDEX indicates the exact position after the comma
From NashvilleHousing
----The above command lets the ProprtyAddress end in Comma----


Select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
 --CHARINDEX indicates the exact position after the comma
From NashvilleHousing

-- The above command ends in comma and then goes further as instructed to go further by the command +1 to end in the Property Address

--The following commands are two different steps in creating two separate columns which are PropertySplitAddress & PropertSplitCity with Values in it--

ALTER TABLE NashVilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashVilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

Select *
From NashVilleHousing


--Working with Owner Addresss / / Splitting the address into respective parameters

 Select OwnerAddress
From NashVilleHousing

Select 
PARSENAME (OwnerAddress, 1)
From NashvilleHousing

-- Want to create Addresss, City and State separately in three different columns
--Select Replace(OwnerAddress,',','====') From NashvilleHousing

Select 
PARSENAME (Replace(OwnerAddress,',','.') , 3),
PARSENAME (Replace(OwnerAddress,',','.') , 2),
PARSENAME (Replace(OwnerAddress,',','.') , 1)
From NashvilleHousing

ALTER TABLE NashVilleHousing
Add UpdatedState Nvarchar(255);

Update NashvilleHousing
SET UpdatedState = PARSENAME (Replace(OwnerAddress,',','.') , 1)

ALTER TABLE NashVilleHousing
Add UpdatedCity Nvarchar(255);

Update NashvilleHousing
SET UpdatedCity = PARSENAME (Replace(OwnerAddress,',','.') , 2)

ALTER TABLE NashVilleHousing
Add UpdatedAddress1 Nvarchar(255);

Update NashvilleHousing
SET UpdatedAddress1 = PARSENAME (Replace(OwnerAddress,',','.') , 3)





-- Changing Y and N to Yes and No in the SoldAsVacant Column

--Command below helps in finding Y, N, Yes and No in Counts

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant
Order By 2

--The following two steps help in converting Y and N to Yes and No

Select SoldAsVacant,
 CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant 
	  END
From NashvilleHousing

Update NashVilleHousing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant 
	  END
	  
Select SoldAsVacant
From NashvilleHousing


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant
Order By 2


--REMOVING DUPLICATES 

--At First Finding Out Duplicates
Select *,
Row_Number()Over
      (Partition By ParcelID,
		SalePrice,
		SaleDate,
		PropertyAddress,
		LegalReference
		Order By UniqueID) row_num
From NashVilleHousing
Order by ParcelID
--Where row_num > 1

--The above command is not working since Where command cannot be used in Windows syntax
--As such a  CTE command can be effective


WITH RowNumberCTE AS (
 Select *,
Row_Number()Over
      (Partition By ParcelID,
		SalePrice,
		SaleDate,
		PropertyAddress,
		LegalReference
		Order By
		UniqueID) row_num
From NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumberCTE
Where Row_Num > 1
Order By PropertyAddress


-- So it is found that 104 rows are duplicate ones
-- Now to remove the duplicate ones

--NOW TO DELETE THE DUPLICATE ROWS 
--WITH RowNumberCTE AS (
-- Select *,
--Row_Number()Over
--      (Partition By ParcelID,
--		SalePrice,
--		SaleDate,
--		PropertyAddress,
--		LegalReference
--		Order By
--		UniqueID) row_num
--From NashvilleHousing
----Order by ParcelID
--)
--Delete
--From RowNumberCTE
--Where Row_Num > 1
----Order By PropertyAddress

--DELETING UNUSED COLUMNS

--ALTER TABLE From <Table Name> 
--DROP COULUMN A, B,C Say Where A,B,C stands for specific column Names






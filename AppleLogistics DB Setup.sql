create database AppleLogistics
use AppleLogistics

-----------------------------------------------------------------------------------------------------------------
--Table Setup

create table tbl_Continents
(
	contName varchar(20) primary key,
	constraint enum_contName check (contName IN('Africa', 'Asia', 'Europe', 'North America', 'Oceania', 'South America'))
)

create table tbl_Countries
(
	countId int primary key identity,
	countName varchar(200),
	contName varchar(20),
	constraint fk_Countries_contName foreign key(contName) references tbl_Continents
)

create table tbl_Products
(
	prodId int primary key identity,
	prodCategory varchar(20),
	prodName varchar(50),
	prodBasePrice money
)

create table tbl_Factories
(
	factId int primary key identity,
	factCostofManufacture float,
	contName varchar(20),
	constraint fk_Factories_contName foreign key(contName) references tbl_Continents
)

create table tbl_Warehouses
(
	wareId int primary key identity,
	countId int,
	factId int,
	constraint fk_Warehouses_countId foreign key(countId) references tbl_Countries,
	constraint fk_Warehouses_factId foreign key(factId) references tbl_Factories
)

create table tbl_Distributors
(
	distId int primary key identity,
	distName varchar(50),
	countId int,
	constraint fk_Distributors_countId foreign key(countId) references tbl_Countries
)

create table tbl_SubDistributors
(
	subDistId int primary key identity,
	subDistName varchar(50),
	distId int,
	constraint fk_SubDistributors_distId foreign key(distId) references tbl_Distributors
)

create table tbl_ChannelPartners
(
	chanId int primary key identity,
	chanName varchar(50),
	chanZone varchar(50),
	subDistId int,
	constraint fk_ChannelPartners_subDistId foreign key(subDistId) references tbl_SubDistributors
)

create table tbl_Stores
(
	storeId int primary key identity,
	storeName varchar(50),
	chanId int,
	constraint fk_Stores_chanId foreign key(chanId) references tbl_ChannelPartners
)

create table tbl_Customers
(
	custId int primary key identity,
	custName varchar(50),
	custAddress varchar(50),
	custEmail varchar(50) unique,
	custGovId varchar(50) unique
)

create table tbl_Items
(
	itemId int primary key identity,
	itemPrice money,
	prodId int,
	wareId int,
	distId int,
	subDistId int,
	chanId int,
	storeId int,
	constraint fk_Items_prodId foreign key(prodId) references tbl_Products,
	constraint fk_Items_wareId foreign key(wareId) references tbl_Warehouses,
	constraint fk_Items_distId foreign key(distId) references tbl_Distributors,
	constraint fk_Items_subDistId foreign key(subDistId) references tbl_SubDistributors,
	constraint fk_Items_chanId foreign key(chanId) references tbl_ChannelPartners,
	constraint fk_Items_storeId foreign key(storeId) references tbl_Stores
)

create table tbl_Orders
(
	orderId int primary key identity,
	storeId int,
	custId int,
	dateRecieved datetime,
	constraint fk_Orders_storeId foreign key(storeId) references tbl_Stores,
	constraint fk_Orders_custId foreign key(custId) references tbl_Customers
)

create table tbl_OrdersItems
(
	orderId int,
	itemId int,
	constraint fk_OrderItems_itemId foreign key(itemId) references tbl_Items,
	constraint fk_OrderItems_orderId foreign key(orderId) references tbl_Orders
)

create table tbl_Warehouses_Inventory
(
	wareId int,
	itemId int,
	dateRecieved datetime,
	constraint fk_Warehouses_Inventory_wareId foreign key(wareId) references tbl_Warehouses,
	constraint fk_Warehouses_Inventory_itemId foreign key(itemId) references tbl_Items
)

create table tbl_Distributors_Inventory
(
	distId int,
	itemId int,
	dateRecieved datetime,
	constraint fk_Distributors_Inventory_distId foreign key(distId) references tbl_Distributors,
	constraint fk_Distributors_Inventory_itemId foreign key(itemId) references tbl_Items
)

create table tbl_SubDistributors_Inventory
(
	subDistId int,
	itemId int,
	dateRecieved datetime,
	constraint fk_SubDistributors_Inventory_subDistId foreign key(subDistId) references tbl_SubDistributors,
	constraint fk_SubDistributors_Inventory_itemId foreign key(itemId) references tbl_Items
)

create table tbl_ChannelPartners_Inventory
(
	chanId int,
	itemId int,
	dateRecieved datetime,
	constraint fk_ChannelPartners_Inventory_chanId foreign key(chanId) references tbl_ChannelPartners,
	constraint fk_ChannelPartners_Inventory_itemId foreign key(itemId) references tbl_Items
)

create table tbl_Stores_Inventory
(
	storeId int,
	itemId int,
	dateRecieved datetime,
	constraint fk_Stores_Inventory_storeId foreign key(storeId) references tbl_Stores,
	constraint fk_Stores_Inventory_itemId foreign key(itemId) references tbl_Items
)

create table tbl_Returns
(
	returnId int primary key identity,
	itemId int,
	dateReturned datetime,
	returnReason varchar(500),
	constraint fk_Returns_itemId foreign key(itemId) references tbl_Items
)

-----------------------------------------------------------------------------------------------------------------
--Junk Data Propagation

insert into tbl_Continents values('Africa')
insert into tbl_Continents values('Asia')
insert into tbl_Continents values('Europe')
insert into tbl_Continents values('North America')
insert into tbl_Continents values('Oceania')
insert into tbl_Continents values('South America')

create procedure proc_NewFactory
as
begin
	declare @fno int = 0
	declare @factCostofManufacture float
	declare @contName varchar(20)
	while @fno < 18
	begin
		select @fno = @fno + 1
		if @fno < 4
		begin
			set @factCostofManufacture = .02
			set @contName = 'Africa'
		end
		else if @fno < 7
		begin
			set @factCostofManufacture = .04
			set @contName = 'Asia'
		end
		else if @fno < 10
		begin
			set @factCostofManufacture = .06
			set @contName = 'Europe'
		end
		else if @fno < 13
		begin
			set @factCostofManufacture = .07
			set @contName = 'North America'
		end
		else if @fno < 16
		begin
			set @factCostofManufacture = .05
			set @contName = 'Oceania'
		end
		else
		begin
			set @factCostofManufacture = .03
			set @contName = 'South America'
		end
		insert into tbl_Factories values(@factCostofManufacture, @contName)
	end
end

exec proc_NewFactory

create procedure proc_NewWarehouse
as
begin
	declare @cno int = 0
	declare @wno int = 0
	declare @fno int
	while @cno < 257
	begin
		select @cno = @cno + 1
		if @cno <= 20
		begin
			select @fno = 1
		end
		else if @cno <= 39
		begin
			select @fno = 2
		end
		else if @cno <= 58
		begin
			select @fno = 3
		end
		else if @cno <= 77
		begin
			select @fno = 4
		end
		else if @cno <= 96
		begin
			select @fno = 5
		end
		else if @cno <= 116
		begin
			select @fno = 6
		end
		else if @cno <= 134
		begin
			select @fno = 7
		end
		else if @cno <= 153
		begin
			select @fno = 8
		end
		else if @cno <= 173
		begin
			select @fno = 9
		end
		else if @cno <= 187
		begin
			select @fno = 10
		end
		else if @cno <= 201
		begin
			select @fno = 11
		end
		else if @cno <= 216
		begin
			select @fno = 12
		end
		else if @cno <= 225
		begin
			select @fno = 13
		end
		else if @cno <= 234
		begin
			select @fno = 14
		end
		else if @cno <= 243
		begin
			select @fno = 15
		end
		else if @cno <= 247
		begin
			select @fno = 16
		end
		else if @cno <= 252
		begin
			select @fno = 17
		end
		else
		begin
			select @fno = 18
		end
		while @wno < 4
		begin
			select @wno = @wno + 1
			insert into tbl_Warehouses values(@cno, @fno)
		end
	select @wno = 0
	end
end

exec proc_NewWarehouse

create procedure proc_NewDistributor
as
begin
	declare @dname varchar(20)
	declare @cno int = 0
	while @cno < 257
	begin
		select @cno = @cno + 1
		select @dname = concat(upper((select left(countName, 4) from tbl_Countries where countId = @cno)), 'Dist')
		insert into tbl_Distributors values(@dname, @cno)
	end
end

exec proc_NewDistributor

create procedure proc_NewSubDistributor
as
begin
	declare @sdname varchar(20)
	declare @dno int = 0
	declare @sdno int = 0
	while @dno < 257
	begin
		select @dno = @dno + 1
		while @sdno < 2
		begin
			select @sdno = @sdno + 1
			if @sdno = 1
				insert into tbl_SubDistributors values('SubDist1', @dno)
			else
				insert into tbl_SubDistributors values('SubDist2', @dno)
		end
		select @sdno = 0
	end
end

exec proc_NewSubDistributor

create procedure proc_NewChannelPartner
as
begin
	declare @cpname varchar(20)
	declare @sdno int = 0
	declare @cpno int = 0
	while @sdno < 514
	begin
		select @sdno = @sdno + 1
		while @cpno < 4
		begin
			select @cpno = @cpno + 1
			if @cpno = 1
				insert into tbl_ChannelPartners values('NE', 'Northeast', @sdno)
			else if @cpno = 2
				insert into tbl_ChannelPartners values('NW', 'Northwest', @sdno)
			else if @cpno = 3
				insert into tbl_ChannelPartners values('SE', 'Southeast', @sdno)
			else
				insert into tbl_ChannelPartners values('SW', 'Southwest', @sdno)
		end
		select @cpno = 0
	end
end

exec proc_NewChannelPartner

create procedure proc_NewStore
as
begin
	declare @sname varchar(20)
	declare @cpno int = 0
	declare @sno int = 0
	while @cpno < 2056
	begin
		select @cpno = @cpno + 1
		while @sno < 2
		begin
			select @sno = @sno + 1
			if @sno = 1
				insert into tbl_Stores values('Apple', @cpno)
			else
				insert into tbl_Stores values('Best Buy', @cpno)
		end
		select @sno = 0
	end
end

exec proc_NewStore

-----------------------------------------------------------------------------------------------------------------
--Functions

create function func_BasePrice (@p_ProdId int, @p_WareId int)
returns money
as
begin
	declare @factCostofManufacture float
	declare @factPrice money
	set @factCostofManufacture = (select tbl_Factories.factCostofManufacture
		from tbl_Factories
		join tbl_Warehouses
		on tbl_Warehouses.factId = tbl_Factories.factId
		where tbl_Warehouses.wareId = @p_WareId)
	set @factPrice = (select prodBasePrice from tbl_Products where prodId = @p_ProdId)
	set @factPrice = @factPrice + (@factPrice * @factCostofManufacture)
	return @factPrice
end

-----------------------------------------------------------------------------------------------------------------
--Procedures

create procedure proc_WarehouseOrder(@p_WareId int, @p_ProdId int, @p_Qty int)
as
begin
	declare @count int = 0
	declare @itemId int
	declare @itemPrice money
	while @count < @p_Qty
	begin
		select @count = @count + 1
		set @itemPrice = dbo.func_BasePrice(@p_ProdId, @p_WareId)
		insert into tbl_Items (itemPrice, prodId, wareId) values (@itemPrice, @p_ProdId, @p_WareId)
		set @itemId = SCOPE_IDENTITY()
		insert into tbl_Warehouses_Inventory values(@p_WareId, @itemId, GETDATE())
	end
end

alter procedure proc_RestockCountry(@p_CountId int, @p_ProdId int)
as
begin
	declare @wareId int
	set @wareId = (select min(wareId) from tbl_Warehouses where countId = @p_CountId)
	while @wareId is not null
	begin
		exec proc_WarehouseOrder @wareId, @p_ProdId, 1
		set @wareId = (select min(wareId) from tbl_Warehouses where countId = @p_CountId and wareId > @wareId)
	end
end


select * from tbl_Warehouses
select * from tbl_Products

exec proc_WarehouseOrder 1, 1, 10
exec proc_WarehouseOrder 1, 2, 10
exec proc_WarehouseOrder 2, 1, 10
exec proc_WarehouseOrder 3, 1, 10
exec proc_WarehouseOrder 4, 1, 10

select * from tbl_Warehouses_Inventory

alter procedure proc_DistributorOrder(@p_DistId int, @p_ProdId int, @p_Qty int, @p_wareNum int)
as
begin
	declare @count int = 0
	declare @itemId int
	declare @wareId int
	declare @lowStock bit = 0
	declare @wareNum int = @p_wareNum + 1
	if @p_wareNum > 4
	begin
		declare @countId int
		set @countId = (select min(tbl_Warehouses.countId)
			from tbl_Warehouses
			join tbl_Countries
			on tbl_Warehouses.countId = tbl_Countries.countId
			join tbl_Distributors
			on tbl_Distributors.countId = tbl_Countries.countId
			where tbl_Distributors.distId = @p_DistId)
		exec proc_RestockCountry @countId, @p_ProdId
		select @wareNum = 1
	end

	set @wareId = (select tbl_Warehouses.wareId
		from tbl_Warehouses
		join tbl_Countries
		on tbl_Warehouses.countId = tbl_Countries.countId
		join tbl_Distributors
		on tbl_Distributors.countId = tbl_Countries.countId
		where tbl_Distributors.distId = @p_DistId
		order by tbl_Warehouses.wareId
		offset (@wareNum - 1) rows
		fetch next 1 rows only)

	while @count < @p_Qty and @lowStock = 0
	begin
		set @itemId = (select min(tbl_Warehouses_Inventory.itemId)
			from tbl_Warehouses_Inventory
			join tbl_Items
			on tbl_Warehouses_Inventory.itemId = tbl_Items.itemId
			join tbl_Products
			on tbl_Items.prodId = tbl_Products.prodId
			where tbl_Products.prodId = @p_ProdId and tbl_Warehouses_Inventory.wareId = @wareId)
		if @itemId is not null
		begin
			insert into tbl_Distributors_Inventory values(@p_distId, @itemId, GETDATE())
			update tbl_Items set distId = @p_DistId, itemPrice = (itemPrice * 1.08) where itemId = @itemId
			delete from tbl_Warehouses_Inventory where itemId = @itemId
			select @count = @count + 1
		end
		else
		begin
			select @lowStock = 1
		end
	end
	if @count < @p_Qty
	begin
		declare @leftover int = (@p_Qty - @count)
		exec proc_DistributorOrder @p_DistId, @p_ProdId, @leftover, @wareNum
	end
end

alter procedure proc_SubDistributorOrder(@p_SubDistId int, @p_ProdId int, @p_Qty int)
as
begin
	declare @count int = 0
	declare @itemId int
	declare @distId int
	set @distId = (select distId from tbl_SubDistributors where subDistId = @p_SubDistId)
	while @count < @p_Qty
	begin
		set @itemId = (select min(tbl_Distributors_Inventory.itemId)
		from tbl_Distributors_Inventory
		join tbl_Items
		on tbl_Distributors_Inventory.itemId = tbl_Items.itemId
		join tbl_Products
		on tbl_Items.prodId = tbl_Products.prodId
		where tbl_Products.prodId = @p_ProdId and tbl_Distributors_Inventory.distId = @distId)
		if @itemId is not null
		begin
			insert into tbl_SubDistributors_Inventory values(@p_SubDistId, @itemId, GETDATE())
			update tbl_Items set subDistId = @p_SubDistId, itemPrice = (itemPrice * 1.08) where itemId = @itemId
			delete from tbl_Distributors_Inventory where itemId = @itemId
			select @count = @count + 1
		end
		else
		begin
			exec proc_DistributorOrder @distId, @p_ProdId, @p_Qty, 0
		end
	end
end

create procedure proc_ChannelPartnerOrder(@p_ChanId int, @p_ProdId int, @p_Qty int)
as
begin
	declare @count int = 0
	declare @itemId int
	declare @subDistId int
	set @subDistId = (select subDistId from tbl_ChannelPartners where chanId = @p_ChanId)
	while @count < @p_Qty
	begin
		set @itemId = (select min(tbl_SubDistributors_Inventory.itemId)
		from tbl_SubDistributors_Inventory
		join tbl_Items
		on tbl_SubDistributors_Inventory.itemId = tbl_Items.itemId
		join tbl_Products
		on tbl_Items.prodId = tbl_Products.prodId
		where tbl_Products.prodId = @p_ProdId and tbl_SubDistributors_Inventory.subDistId = @subDistId)
		if @itemId is not null
		begin
			insert into tbl_ChannelPartners_Inventory values(@p_ChanId, @itemId, GETDATE())
			update tbl_Items set chanId = @p_ChanId, itemPrice = (itemPrice * 1.08) where itemId = @itemId
			delete from tbl_SubDistributors_Inventory where itemId = @itemId
			select @count = @count + 1
		end
		else
		begin
			exec proc_SubDistributorOrder @subDistId, @p_ProdId, @p_Qty
		end
	end
end


create procedure proc_StoreOrder(@p_StoreId int, @p_ProdId int, @p_Qty int)
as
begin
	declare @count int = 0
	declare @itemId int
	declare @chanId int
	set @chanId = (select chanId from tbl_Stores where storeId = @p_StoreId)
	while @count < @p_Qty
	begin
		set @itemId = (select min(tbl_ChannelPartners_Inventory.itemId)
		from tbl_ChannelPartners_Inventory
		join tbl_Items
		on tbl_ChannelPartners_Inventory.itemId = tbl_Items.itemId
		join tbl_Products
		on tbl_Items.prodId = tbl_Products.prodId
		where tbl_Products.prodId = @p_ProdId and tbl_ChannelPartners_Inventory.chanId = @chanId)
		if @itemId is not null
		begin
			insert into tbl_Stores_Inventory values(@p_StoreId, @itemId, GETDATE())
			update tbl_Items set storeId = @p_StoreId, itemPrice = (itemPrice * 1.08) where itemId = @itemId
			delete from tbl_ChannelPartners_Inventory where itemId = @itemId
			select @count = @count + 1
		end
		else
		begin
			exec proc_ChannelPartnerOrder @chanId, @p_ProdId, @p_Qty
		end
	end
end

exec proc_StoreOrder 1, 1, 10
exec proc_StoreOrder 2, 1, 10
exec proc_StoreOrder 1, 2, 10
exec proc_StoreOrder 2, 2, 10

select * from tbl_Products

alter procedure proc_FillStores
as
begin
	declare @storeCount int = 0
	declare @productCount int = 0
	while @storeCount < 4112
	begin
	select @storeCount = @storeCount + 1
		while @productCount < 26
		begin
			select @productCount = @productCount + 1
			exec proc_StoreOrder @storeCount, @productCount, 1
		end
		select @productCount = 0
	end
end

exec proc_FillStores

--delete from tbl_Stores_Inventory
--delete from tbl_ChannelPartners_Inventory
--delete from tbl_SubDistributors_Inventory
--delete from tbl_Distributors_Inventory
--delete from tbl_Warehouses_Inventory
--delete from tbl_Items

--dbcc checkident ('[tbl_Items]', RESEED, 0)


-----------------------------------------------------------------------------------------------------------------
--Views

--Number of Warehouses in each Country
create view [Warehouses by Country] as
	select tbl_Countries.countName AS [Country Name], count(tbl_Warehouses.wareId) AS [Number of Warehouses]
	from tbl_Countries
	join tbl_Warehouses
	on tbl_Countries.countId = tbl_Warehouses.countId
	group by countName

select * from [Warehouses by Country]

--Country and associated Distributor
create view [Distributor List] as
	select tbl_Countries.countName AS [Country], tbl_Countries.contName AS [Continent], tbl_Distributors.distName AS [Distributor] 
	from tbl_Countries
	join tbl_Distributors
	on tbl_Countries.countId = tbl_Distributors.countId

select * from [Distributor List] order by Country

--complete store info
create view [Full Supply Chain] as
	select tbl_Countries.countName as [Country], tbl_Distributors.distName as [Distributor], tbl_SubDistributors.subDistName as [Subdistributor], tbl_ChannelPartners.chanName as [Channel Partner], tbl_Stores.storeName as [Store]
	from tbl_Stores
	join tbl_ChannelPartners
	on tbl_Stores.chanId = tbl_ChannelPartners.chanId
	join tbl_SubDistributors
	on tbl_ChannelPartners.subDistId = tbl_SubDistributors.subDistId
	join tbl_Distributors
	on tbl_Distributors.distId = tbl_SubDistributors.distId
	join tbl_Countries
	on tbl_Countries.countId = tbl_Distributors.countId

select * from [Full Supply Chain]

--number of stores in each continent
create view [Stores in each Continent] as
	select tbl_Continents.contName AS [Continent], count(tbl_Stores.storeId) AS [Number of Stores]
	from tbl_Stores
	join tbl_ChannelPartners
	on tbl_Stores.chanId = tbl_ChannelPartners.chanId
	join tbl_SubDistributors
	on tbl_ChannelPartners.subDistId = tbl_SubDistributors.subDistId
	join tbl_Distributors
	on tbl_Distributors.distId = tbl_SubDistributors.distId
	join tbl_Countries
	on tbl_Countries.countId = tbl_Distributors.countId
	join tbl_Continents
	on tbl_Countries.contName = tbl_Continents.contName
	group by tbl_Continents.contName

select * from [Stores in each Continent] order by [Number of Stores] desc

select tbl_Stores.storeName as [Store], tbl_Stores.storeId as [Store No], tbl_Products.prodName as [Product], tbl_Items.itemPrice as [Price in Store]
from tbl_Stores
join tbl_Stores_Inventory
on tbl_Stores.storeId = tbl_Stores_Inventory.storeId
join tbl_Items
on tbl_Stores_Inventory.itemId = tbl_Items.itemId
join tbl_Products
on tbl_Items.prodId = tbl_Products.prodId
order by tbl_Stores.storeId
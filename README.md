# Apple Inc Device Manufacturing Database

## Project Description

This project is meant to mimic the supply chain of Apple Inc. It tracks as each individual product is produced, where it currently sits in the supply chain, when it is sold, and if it is returned. All of this information about the product is permanently stored and can be tracked by serial number.

## Technologies Used

* Microsoft SQL Server
* TSQL
* SSIS

## Features

List of features:
* Assigns each item a serial number when produced that can be used to track its history.
* Fills the database with sample data automatically, using TSQL Procedures. 
* Implements an ordering system that sells the product to the customer.
* Implements a return system that sends the product back to the factory, through the original channels in which it was sent down.

To-do list:
* Build a data warehouse based on the serial number.
* Create visualizations to assist the business using SSRS and Power BI.

## Getting Started
   
git clone https://github.com/210104-msbi-reston/Dakota-Wells-P1.git

Run the query in SQL Server Management Studio.

## Usage

Views:
* [Warehouses by Country] - View number of warehouses in each country.
* [Full Supply Chain] - Shows where each store sources its products from.
* [Stores in each Continent] - Shows stores by continent.
* [%%% Inventories] - Shows the inventory of the respective business type.
* [Order History] - Shows all order history.

Procedures:
* proc_%%%Inventory - Shows inventory of a specific business with provided ID.
* proc_NewOrder - Creates order with provided product, store, customer, and quantity.
* proc_CustomerOrderHistory - Shows order history of customer with provided ID.
* proc_NewReturn - Returns item with provided serial number.

## License

This project uses the following license: [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

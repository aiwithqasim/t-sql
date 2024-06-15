# SQL Server (t-SQL)

_NOTE: This repository is part of cloud data engineering roadmap for getting hands on t-SQL on Microsoft SQL Server_

## What is SQL Server?

- Relational database management system (RDBMS) developed by Mricosoft.
- Similar to other RDBMS software, SQL Server is built on top of SQL.
- SQL Server is tied to Transact-SQL, or T-SQL which includes a set of proprietary programming constructs.

## SQL Server Architecture

SQL Server consists of two main components:

- Database Engine
    - Core component of the SQL Server is the Database Engine
    - Comprises a relational engine that **processes queries** and a **storage engine** that **manages database files, pages, indexes**, etc
    - Additionally, the database engine creates database objects such as stored procedures, views, and triggers.

- SQLOS
    - Under the relational engine and storage engine lies the SQL Server Operating System, or SQLOS.
    - SQLOS provides services such as **memory** and **I/O management**, as well as **exception handling** and **synchronization** services.

![sql-server-architecture](./img/sql-server-architecture.png)

## Others tools

- SSMS used for database development
- SSIS used for data management
- SSAS used for analysis
- SSRS used for reporting

_NOTE: SSMS & SSIS are important skillset for Data Engineers_

## SQL Server Editions

- SQL Server Developer Edition ( used for database developement & tetsing)
- SQL Server Express Edition ( used for small database with storage capacity up to 10GBs)
- SQL Server Standard Edition ( subset of enterprise edition with limitiation like **number of processor cores** and **memory configurations**.)
- SQL server Web Edition ( used for web hosting companies due to its low total cost of ownership)

## Summary
- SQL server architecture includes a **database engine** and **SQL server operation system (SQLOS)**
- SQL server offers a set of tools for working with data effectively
- SQL server has different editions including developer edition, expression, enterprise, and standard


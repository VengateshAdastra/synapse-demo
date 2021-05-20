CREATE USER SalesDemo_ELTUser WITHOUT LOGIN;
GO

EXEC sp_addrolemember 'db_owner', 'SalesDemo_ELTUser';
GO

CREATE WORKLOAD CLASSIFIER [wgcSalesDemoELT]
WITH (WORKLOAD_GROUP = 'xlargerc'
      ,MEMBERNAME = 'SalesDemo_ELTUser'
      ,IMPORTANCE = HIGH);

      --Workload groups
SELECT * FROM
sys.workload_management_workload_groups

--Workload classifiers
SELECT * FROM
sys.workload_management_workload_classifiers

--Run-time values
SELECT * FROM
sys.dm_workload_management_workload_groups_stats
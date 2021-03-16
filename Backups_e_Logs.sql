--BACKUP Banco De Dados
select 'BACKUP DATABASE [' + name + '] TO DISK=''C:\CAMINHO_EXEMPLO\BACKUP\' + name + '.bak'' WITH INIT;' from sys.databases 

--RESTAURAR BACKUP
select 'ALTER DATABASE ' + name + ' SET SINGLE_USER WITH ROLLBACK IMMEDIATE; ALTER DATABASE ' + name + ' SET READ_ONLY; RESTORE DATABASE ' + name + ' FROM DISK = ''C:\CAMINHO_EXEMPLO\BACKUP\' + name + '.bak'' WITH REPLACE; ALTER DATABASE ' + name + ' SET MULTI_USER;' from sys.databases  order by name

--RESTAURAR BACKUP QUANDO O ARQUIVO BAK FOI EXPORTADO DE OUTRA MAQUINA,É NECESSARIO APONTAR O LOCAL DOS ARQUIVO .MDF E .LDF DO BANCO DE DESTINO
select 'ALTER DATABASE  [' + name + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; ALTER DATABASE  [' + name + '] SET READ_ONLY; RESTORE DATABASE [' + name + '] FROM DISK = ''C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\Backup\' + name + '.bak'' WITH MOVE ''' + name + ''' TO ''C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\' + name + '.MDF'',  MOVE ''' + name + '_log'' TO ''C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\' + name + '.LDF'',REPLACE ; ALTER DATABASE [' + name + '] SET MULTI_USER;'  from sys.databases  order by name

--Diminuir Tamanho do Arquivo de LOG
select ' USE ['+name+'] DBCC SHRINKFILE("'+name+'_log", 1)' from sys.databases

--Verificar o log e o nome correto da database de log
SELECT * FROM sysfiles 

--Verificar Tamanho dos Bancos Da Instancia
SELECT DB.name, SUM(size) * 8  AS  Tamanho FROM sys.databases DB INNER JOIN sys.master_files ON DB.database_id = sys.master_files.database_id GROUP BY DB.name order by Tamanho asc

--inserir arquivos de uma planilha excel em uma tabela ja existente no banco usando OLEDB VERSÃO 12.0
select 'insert  INTO ['+name+'].dbo.MercRed SELECT * FROM OPENDATASOURCE(''Microsoft.ACE.OLEDB.12.0'', ''Data Source=C:\CAMINHO_EXEMPLO\PLANILHA.xlsx;Extended Properties=Excel 12.0'')...[Data$];' from sys.databases

--criar uma tabela especifica no banco e inserir arquivos de uma planilha excel usando OLEDB VERSÃO 12.0
select 'SELECT * INTO ['+name+'].dbo.TABELA FROM OPENDATASOURCE(''Microsoft.ACE.OLEDB.12.0'', ''Data Source=C:\CAMINHO_EXEMPLO\PLANILHA.xlsx;Extended Properties=Excel 12.0'')...[Data$];' from sys.databases

-- Procedure para Verificar Espaco em disco da Maquina Do Banco , Funciona em usuarios não administradores da Maquina ou Do Banco
CREATE PROCEDURE BANCO
@ESPACO VARCHAR(20)
AS
SELECT DISTINCT
    VS.volume_mount_point [Caminho / Letra] ,
    VS.logical_volume_name AS [Nome] ,
    CAST(CAST(VS.total_bytes AS DECIMAL(19, 2)) / 1024 / 1024 / 1024 AS DECIMAL(10, 2)) AS [Total (GB)] ,
    CAST(CAST(VS.available_bytes AS DECIMAL(19, 2)) / 1024 / 1024 / 1024 AS DECIMAL(10, 2)) AS [Espaço Disponível (GB)] ,
    CAST(( CAST(VS.available_bytes AS DECIMAL(19, 2)) / CAST(VS.total_bytes AS DECIMAL(19, 2)) * 100 ) AS DECIMAL(10, 2)) AS [Espaço Disponível ( % )] ,
    CAST(( 100 - CAST(VS.available_bytes AS DECIMAL(19, 2)) / CAST(VS.total_bytes AS DECIMAL(19, 2)) * 100 ) AS DECIMAL(10, 2)) AS [Espaço em uso ( % )]
FROM
    sys.master_files AS MF
    CROSS APPLY [sys].[dm_os_volume_stats](MF.database_id, MF.file_id) AS VS
WHERE
    CAST(VS.available_bytes AS DECIMAL(19, 2)) / CAST(VS.total_bytes AS DECIMAL(19, 2)) * 100 < 100;

EXECUTE BANCO ESPACO


-- Usando SQL Server em Linha de Comando (CLI):
SQLCMD -NOMEDAINSTANCIA -Uusuario -Psenha -Q "SELECT * FROM TABELA ;"

--Retirar Single_User
USE master
GO
ALTER DATABASE [BANCODEDADOS]
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE [BANCODEDADOS]
SET READ_ONLY;
GO
ALTER DATABASE [BANCODEDADOS]
SET MULTI_USER;
GO


--RETIRAR O SOMENTE LEITURA (READ_ONLY):
USE master
GO
ALTER DATABASE [BANCODEDADOS]
SET READ_WRITE
WITH ROLLBACK IMMEDIATE;
GO
--Obter formato da data atual da instancia
select getdate()

--obter a linguagem atual do usuario da instancia
SELECT @@LANGUAGE AS 'Language Name';
Select language From sys.syslogins Where sid = SUSER_ID('sa')

--verificar a collation atual dos bancos
--lembrar que a collation do banco master é sempre a mesma da instancia
select name,COLLATION_NAME from sys.databases


--Mudar o idioma do usuario do banco
Exec sp_defaultlanguage 'sa', 'Português (Brasil)'
Reconfigure


-- alterar a collation do banco de dados
alter database banco set single_user with rollback immediate;
go
alter database banco collate Latin1_General_CI_AS;
go
alter database banco set multi_user;


--alterar a collatin da instancia toda
--abrir cmd com Administrador e navegar ate a pasta BINN do sql da instancia
--ex: C:\Program Files\Microsoft SQL Server\MSSQL14.MZA\MSSQL\Binn
--Execeutar: sqlservr -sINSTANCIA -m -T4022 -T3659 -q"SQL_Latin1_General_CP1_CI_AS"
--depois que acabar reiniciar a instancia
--caso de erro parar a instancia para realizar a operação depois ligar novamente
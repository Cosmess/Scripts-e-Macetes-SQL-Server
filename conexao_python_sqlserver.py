#pip install pyodbc
import pyodbc

def retornar_conexao_sql():
    
    #Dependendo da sua configuração de segurança no windows ou sql server é necessario passar a porta no server
    #exemplo: 192.168.1.1\EC2AMAZ-QACBCFM\CLIENTES,1433
    server = "IP\NOMEMAQUINA\INSTANCIA,PORTA"
    database = ""
    username = ""
    port = ""
    password = ""
    string_conexao = 'Driver={SQL Server};Server='+server+';UID='+username+';PWD='+ password
    #string_conexao = 'Driver={SQL Server Native Client 10.0};Server='+server+';Database='+database+';Trusted_Connection=yes;'
    return pyodbc.connect(string_conexao)

conexao = retornar_conexao_sql()
cursor = conexao.cursor()
sql = "SELECT * FROM TABELA"
cursor.execute(sql)

linhas = cursor.fetchall()

for linha in linhas:
    print(linha)
    
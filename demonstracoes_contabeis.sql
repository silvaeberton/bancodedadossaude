create database if not exists demonstracoes_contabeis;

use demonstracoes_contabeis;

alter database demonstracoes_contabeis charset = Latin1 collate = latin1_general_ci;

-- CRIA TABELAS OPERADORAS E DESPESAS --
create table if not exists operadoras(		
    id_registro int,
	cnpj bigint unsigned not null,
	razaosocial varchar(255) not null,
    nomefantasia varchar(255),
    modalidade varchar(255),
    logradouro varchar(255),
    numero varchar(255),
    complemento varchar(255),
    bairro varchar(255),
    cidade varchar(255),
    uf varchar(255),
    cep varchar(255),
    ddd varchar(255),
    telefone varchar(255),
    fax varchar(255),
    endereco varchar(255),
    representante varchar(255),
    cargorepresentante varchar(255),
    dataregistroans varchar(255),
    primary key(id_registro)    
);

create table if not exists despesas(
	id int auto_increment not null,
    datarelatorio date,
    registroans int,
    contacontabil int,
    descricao varchar(255),
    saldofinal varchar(255),
    primary key(id)   
);

-- CARREGA ARQUIVOS --
set global local_infile=1;

load data infile 'F:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Relatorio_cadop.csv'
into table operadoras
fields terminated by ';'
enclosed by '"'
lines terminated by '\r\n'
ignore 3 lines
(id_registro, cnpj, razaosocial, nomefantasia, modalidade, logradouro, numero, complemento, bairro, cidade, uf, cep, ddd, telefone, fax, endereco, representante, cargorepresentante, dataregistroans);

load data infile 'F:/ProgramData/MySQL/MySQL Server 8.0/Uploads/1T2020.csv'
into table despesas
fields terminated by ';'
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@datarelatorio,registroans,contacontabil,descricao,saldofinal)
set datarelatorio = str_to_date(@datarelatorio, '%d/%m/%Y');

load data infile 'F:/ProgramData/MySQL/MySQL Server 8.0/Uploads/1T2019.csv'
into table despesas
fields terminated by ';'
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@datarelatorio,registroans,contacontabil,descricao,saldofinal)
set datarelatorio = str_to_date(@datarelatorio, '%d/%m/%Y');

load data infile 'F:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2T2019.csv'
into table despesas
fields terminated by ';'
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@datarelatorio,registroans,contacontabil,descricao,saldofinal)
set datarelatorio = str_to_date(@datarelatorio, '%d/%m/%Y');

load data infile 'F:/ProgramData/MySQL/MySQL Server 8.0/Uploads/3T2019.csv'
into table despesas
fields terminated by ';'
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@datarelatorio,registroans,contacontabil,descricao,saldofinal)
set datarelatorio = str_to_date(@datarelatorio, '%d/%m/%Y');

load data infile 'F:/ProgramData/MySQL/MySQL Server 8.0/Uploads/4T2019.csv'
into table despesas
fields terminated by ';'
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@datarelatorio,registroans,contacontabil,descricao,saldofinal)
set datarelatorio = str_to_date(@datarelatorio, '%d/%m/%Y');

-- RETORNA operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR nos ultimos  3 meses
select operadoras.razaosocial, sum(saldofinal) as total
from despesas
	inner join operadoras
    on (operadoras.id_registro = despesas.registroans)
where (descricao='EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR')
and (select year(datarelatorio) = 2020)
group by registroans
order by total desc
limit 10;

-- RETORNA operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR no ano de 2019
select operadoras.razaosocial, sum(saldofinal) as total
from despesas
	inner join operadoras
    on (operadoras.id_registro = despesas.registroans)
where (descricao='EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR')
and (select year(datarelatorio) = 2019)
group by registroans
order by total desc
limit 10;




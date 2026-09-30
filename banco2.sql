create database clinica_medica;
use clinica_medica;

create table medicos(
crm int primary key,
nome varchar(45) not null,
especialidade varchar(45) not null,
telefone varchar(11) not null,
data_admissao date not null,
tipo varchar(20)
);

create table pacientes(
cpf varchar(11) primary key,
nome varchar(45) not null,
data_nascimento date not null,
sexo varchar(13),
telefone varchar(11) not null,
rua varchar(45) not null,
numero int not null,
bairro varchar(45) not null,
cidade varchar(45) not null,
cep varchar(8) not null
);

create table consultas(
codigo int primary key,
data_consulta date not null,
hora time not null,
valor int not null,
status varchar(15) not null
);

create table medicamentos(
codigo int primary key,
nome_comercial varchar(35) not null,
principio_ativo varchar (35) not null,
fabricante varchar(35) not null
);

create table prescricoes(
codigo_consulta int primary key,
codigo_medicamento int,
dosagem varchar(30) not null,
quantidade int not null
);

create table convenios(
codigo int primary key,
nome varchar(35) not null,
telefone varchar(11) not null
);

show tables;
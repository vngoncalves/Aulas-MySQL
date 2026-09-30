#Comando para apagar o banco de dados antes da criaçãoptimize
drop database if exists db_escola_atual;

#Verificando se o banco de dados existe
create database db_escola_atual
character set utf8mb4
collate utf8mb4_unicode_ci;

#Selecionando o banco de dados
use db_escola_atual;

#CRIANDO A TABELA alunos
create table alunos(
    id_aluno smallint unsigned auto_increment primary key,
    nome varchar(45) not null,
    matricula char(10) not null unique,
    data_nascimento date not null,
    responsavel varchar(45) not null,
    telefone char(11) not null, 
    status tinyint not null
);
#CRIANDO A ENTIDADE professores
create table professores(
	id_professor smallint unsigned auto_increment primary key,
    nome varchar(45) not null,
    email varchar(60) not null unique,
    telefone char(11) not null,
    especialidade enum("Matemática","Informática","Física"),
    salario_bruto decimal(7,2) not null
);
#CRIANDO A TABELA disciplinas
create table disciplinas(
	id_disciplina smallint unsigned auto_increment primary key,
    nome varchar(45) not null,
    carga_horaria smallint unsigned not null
);
#CRIANDO A TABELA turmas
create table turmas(
    id_turma smallint auto_increment primary key,
    id_disciplina smallint unsigned not null,
    id_professor smallint unsigned not null,
    constraint fk_professor_turmas  foreign key (id_professor)  references professores(id_professor),
    constraint fk_disciplina_turmas foreign key (id_disciplina) references disciplinas(id_disciplina)
);
create table matriculas(
	id_matricula int auto_increment primary key,
	id_aluno smallint  unsigned not null unique,
    id_turma smallint  unsigned not null unique,
    data_matricula date,
    status tinyint
);
#CRIANDO A TABELA notas
create table notas(
	id_notas smallint  auto_increment primary key,
    id_matricula smallint  unsigned not null unique,
    id_turma_disciplina smallint  unsigned not null unique,
    bimestre varchar(2),
    valor decimal(6,2)
);
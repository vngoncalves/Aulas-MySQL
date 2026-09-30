# CRIANDO A BASE DE DADOS
create database db_escola;

# SELECIONANDO A BASE DE DADOS
use db_escola;

# CRIANDO A ENTIDADE (alunos)
create table alunos(
	id_aluno int auto_increment primary key,
    nome varchar(100) not null,
    matricula int not null unique,
    data_nascimento date not null,
    responsavel varchar(100) not null,
    telefone varchar(15) not null,
    email varchar(100),
    status varchar(20) not null
    );

# CRIANDO A ENTIDADE (professores)
create table professores(
	id_professor int auto_increment primary key,
    nome varchar(100) not null,
    email varchar(100),
    telefone varchar(15) not null
    );

# CRIANDO A ENTIDADE (disciplinas)
create table disciplinas(
	id_disciplinas int auto_increment primary key,
	nome varchar(100) not null,
    carga_horaria int not null 
    );

# CRIANDO A ENTIDADE (turmas)
create table turmas(
	id_turmas int auto_increment primary key,
    codigo int not null unique,
    serie varchar(20) not null,
    ano_letivo year not null,
    turno varchar(20) not null
    );

# CRIANDO A ENTIDADE (turmas_disciplinas)
create table turmas_disciplinas(
	id_turmas_disciplinas int auto_increment primary key,
	turma_id int not null,
    disciplina_id int not null,
    professor_id int not null 
    );

# CRIANDO A ENTIDADE (matriculas)
create table matriculas(
	id_matricula int auto_increment primary key,
	aluno_id int not null,
	turma_id int not null,
	data_matriculas date not null,
	status varchar(20) not null
);

# CRIANDO A ENTIDADE (notas)
create table notas(
	id_notas int auto_increment primary key,
    matricula_id int not null,
    turma_disciplina_id int not null,
    bimestre int not null,
    valor decimal(4,2) not null
);

# CRIANDO A ENTIDADE (frequencias)
create table frequencias(
	id_frequencias int auto_increment primary key,
	matricula_id int not null,
	data date not null,
	presente boolean not null,
	justificativa varchar(200)
);

# CRIANDO A ENTIDADE (usuarios)
create table usuarios(
	id_usuarios int auto_increment primary key,
	login varchar(45) not null unique,
	senha varchar(255) not null,
	tipo varchar(15)
);

show tables;
alter table professores modify id_professor smallint unsigned auto_increment not null primary key;
desc professores;

/*
    PRINCIPAIS TIPOS:
    datetime = Data + Horário
    time     = Horário
    tinyint  = Verdadeiro/Falso (1 ou 0)
    smallint = Números pequenos
    enum     = Lista de opções
    year     = Ano
    decimal  = Número + Casas decimais
*/

CREATE DATABASE IF NOT EXISTS db_escola_correcao;
USE db_escola_correcao;

CREATE TABLE professores (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(11) NOT NULL,
    especialidade ENUM('Matemática', 'x', 'y'),
    salario_bruto DECIMAL(7,2) NOT NULL
);

CREATE TABLE alunos (
    id_aluno SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    matricula SMALLINT UNIQUE,
    data_nascimento YEAR NOT NULL,
    responsavel VARCHAR(100) NOT NULL,
    telefone CHAR(11) NOT NULL,
    email VARCHAR(100),
    status TINYINT NOT NULL
);

CREATE TABLE turmas (
    id_turma SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_disciplina SMALLINT UNSIGNED NOT NULL,
    id_professor INT NOT NULL,

    CONSTRAINT fk_professor_turma FOREIGN KEY (id_professor) REFERENCES professores(id_professor)
);

CREATE TABLE matriculas (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno SMALLINT UNSIGNED NOT NULL,
    id_turma SMALLINT UNSIGNED NOT NULL,
    data_matricula DATE,
    status TINYINT,
    CONSTRAINT fk_matricula_aluno FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno),
    CONSTRAINT fk_matricula_turma FOREIGN KEY (id_turma) references turmas(id_turma)
);

CREATE TABLE notas (
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_matricula INT NOT NULL,
    id_turma_disciplina SMALLINT UNSIGNED NOT NULL,
    bimestre VARCHAR(2),
    valor DECIMAL(6,2),
    CONSTRAINT fk_nota_matricula FOREIGN KEY (id_matricula) REFERENCES matriculas(id_matricula)
);

CREATE TABLE aulas (
    id_aula SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_turma SMALLINT UNSIGNED NOT NULL,
    id_disciplina SMALLINT UNSIGNED NOT NULL,
    id_professor INT NOT NULL,
    CONSTRAINT fk_aula_turma FOREIGN KEY (id_turma) REFERENCES turmas(id_turma),
    CONSTRAINT fk_aula_professor FOREIGN KEY (id_professor) REFERENCES professores(id_professor)
);

show tables;
desc alunos;
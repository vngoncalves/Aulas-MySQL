#Comando para apagar o banco de dados antes da criação
DROP DATABASE IF EXISTS db_clinica_vidaplena;

#Criando o banco de dados
CREATE DATABASE IF NOT EXISTS db_clinica_vidaplena
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

#Selecionando o banco de dados
USE db_clinica_vidaplena;


#CRIANDO A TABELA paciente
CREATE TABLE paciente(
    codigo_paciente INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo VARCHAR(1) NOT NULL,
    email VARCHAR(100),
    logradouro VARCHAR(120) NOT NULL,
    numero VARCHAR(15) NOT NULL,
    complemento VARCHAR(80),
    bairro VARCHAR(80) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    uf CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (codigo_paciente),
    # CPF DO PACIENTE NAO PODE SE REPETIR
    CONSTRAINT uq_paciente_cpf UNIQUE (cpf),
    # SEXO DEVE SER M OU F
    CONSTRAINT chk_paciente_sexo CHECK (sexo IN ('M','F'))
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA telefone_paciente
CREATE TABLE telefone_paciente(
    codigo_telefone INT NOT NULL,
    codigo_paciente INT NOT NULL,
    numero VARCHAR(20) NOT NULL,
    tipo VARCHAR(20),
    CONSTRAINT pk_telefone_paciente PRIMARY KEY (codigo_telefone),
    # RELACIONAMENTO telefone_paciente ENTRE paciente
    CONSTRAINT fk_telefone_paciente
    FOREIGN KEY (codigo_paciente)
    REFERENCES paciente(codigo_paciente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA contato_emergencia
CREATE TABLE contato_emergencia(
    codigo_contato INT NOT NULL,
    codigo_paciente INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    parentesco VARCHAR(50),
    CONSTRAINT pk_contato_emergencia PRIMARY KEY (codigo_contato),
    # RELACIONAMENTO contato_emergencia ENTRE paciente
    CONSTRAINT fk_contato_paciente
    FOREIGN KEY (codigo_paciente)
    REFERENCES paciente(codigo_paciente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA convenio
CREATE TABLE convenio(
    codigo_convenio INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(14) NOT NULL,
    telefone VARCHAR(20),
    percentual_cobertura DECIMAL(5,2) NOT NULL,
    CONSTRAINT pk_convenio PRIMARY KEY (codigo_convenio),
    # CNPJ DO CONVENIO NAO PODE SE REPETIR
    CONSTRAINT uq_convenio_cnpj UNIQUE (cnpj),
    # O PERCENTUAL DE COBERTURA DEVE ESTAR ENTRE 0 E 100
    CONSTRAINT chk_convenio_cobertura CHECK (percentual_cobertura BETWEEN 0 AND 100)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA paciente_convenio
CREATE TABLE paciente_convenio(
    codigo_paciente INT NOT NULL,
    codigo_convenio INT NOT NULL,
    carteirinha VARCHAR(30) NOT NULL,
    validade DATE,
    tipo_vinculo VARCHAR(30) NOT NULL,
    CONSTRAINT pk_paciente_convenio PRIMARY KEY (codigo_paciente,codigo_convenio),
    # RELACIONAMENTO paciente_convenio ENTRE paciente
    CONSTRAINT fk_pc_paciente
    FOREIGN KEY (codigo_paciente)
    REFERENCES paciente(codigo_paciente)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    # RELACIONAMENTO paciente_convenio ENTRE convenio
    CONSTRAINT fk_pc_convenio
    FOREIGN KEY (codigo_convenio)
    REFERENCES convenio(codigo_convenio)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA consultorio
CREATE TABLE consultorio(
    codigo_consultorio INT NOT NULL,
    identificacao VARCHAR(50) NOT NULL,
    localizacao VARCHAR(100),
    CONSTRAINT pk_consultorio PRIMARY KEY (codigo_consultorio)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA medico
CREATE TABLE medico(
    codigo_medico INT NOT NULL,
    codigo_consultorio INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL,
    uf_crm CHAR(2) NOT NULL,
    data_admissao DATE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    salario DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (codigo_medico),
    # CRM DO MEDICO NAO PODE SE REPETIR
    CONSTRAINT uq_medico_crm UNIQUE (crm),
    # O SALARIO NAO PODE SER NEGATIVO
    CONSTRAINT chk_medico_salario CHECK (salario >= 0),
    # RELACIONAMENTO medico ENTRE consultorio
    CONSTRAINT fk_medico_consultorio
    FOREIGN KEY (codigo_consultorio)
    REFERENCES consultorio(codigo_consultorio)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA especialidade
CREATE TABLE especialidade(
    codigo_especialidade INT NOT NULL,
    nome VARCHAR(80) NOT NULL,
    CONSTRAINT pk_especialidade PRIMARY KEY (codigo_especialidade)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA medico_especialidade
CREATE TABLE medico_especialidade(
    codigo_medico INT NOT NULL,
    codigo_especialidade INT NOT NULL,
    CONSTRAINT pk_medico_especialidade PRIMARY KEY (codigo_medico,codigo_especialidade),
    # RELACIONAMENTO medico_especialidade ENTRE medico
    CONSTRAINT fk_me_medico
    FOREIGN KEY (codigo_medico)
    REFERENCES medico(codigo_medico)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    # RELACIONAMENTO medico_especialidade ENTRE especialidade
    CONSTRAINT fk_me_especialidade
    FOREIGN KEY (codigo_especialidade)
    REFERENCES especialidade(codigo_especialidade)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA consulta
CREATE TABLE consulta(
    codigo_consulta INT NOT NULL,
    codigo_paciente INT NOT NULL,
    codigo_medico INT NOT NULL,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    CONSTRAINT pk_consulta PRIMARY KEY (codigo_consulta),
    # UM MEDICO NAO PODE TER DUAS CONSULTAS NO MESMO HORARIO
    CONSTRAINT uq_consulta_medico_horario UNIQUE (codigo_medico,data,hora),
    # RELACIONAMENTO consulta ENTRE paciente
    CONSTRAINT fk_consulta_paciente
    FOREIGN KEY (codigo_paciente)
    REFERENCES paciente(codigo_paciente)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    # RELACIONAMENTO consulta ENTRE medico
    CONSTRAINT fk_consulta_medico
    FOREIGN KEY (codigo_medico)
    REFERENCES medico(codigo_medico)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA prescricao
CREATE TABLE prescricao(
    codigo_prescricao INT NOT NULL,
    codigo_consulta INT NOT NULL,
    descricao VARCHAR(300) NOT NULL,
    CONSTRAINT pk_prescricao PRIMARY KEY (codigo_prescricao),
    # RELACIONAMENTO prescricao ENTRE consulta
    CONSTRAINT fk_prescricao_consulta
    FOREIGN KEY (codigo_consulta)
    REFERENCES consulta(codigo_consulta)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA solicitacao_exame
CREATE TABLE solicitacao_exame(
    codigo_solicitacao INT NOT NULL,
    codigo_consulta INT NOT NULL,
    data_solicitacao DATE NOT NULL,
    CONSTRAINT pk_solicitacao_exame PRIMARY KEY (codigo_solicitacao),
    # RELACIONAMENTO solicitacao_exame ENTRE consulta
    CONSTRAINT fk_solicitacao_consulta
    FOREIGN KEY (codigo_consulta)
    REFERENCES consulta(codigo_consulta)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA exame
CREATE TABLE exame(
    codigo_exame INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(200),
    valor_base DECIMAL(10,2) NOT NULL,
    prazo INT NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    CONSTRAINT pk_exame PRIMARY KEY (codigo_exame),
    # O VALOR DO EXAME NAO PODE SER NEGATIVO
    CONSTRAINT chk_exame_valor CHECK (valor_base >= 0),
    # O PRAZO DO EXAME NAO PODE SER NEGATIVO
    CONSTRAINT chk_exame_prazo CHECK (prazo >= 0)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA item_solicitacao
CREATE TABLE item_solicitacao(
    codigo_item INT NOT NULL,
    codigo_solicitacao INT NOT NULL,
    codigo_exame INT NOT NULL,
    data_realizacao DATE,
    resultado VARCHAR(300),
    status VARCHAR(20) NOT NULL,
    CONSTRAINT pk_item_solicitacao PRIMARY KEY (codigo_item),
    # STATUS DO EXAME DEVE SER PENDENTE, REALIZADO OU CANCELADO
    CONSTRAINT chk_item_status CHECK (status IN ('PENDENTE','REALIZADO','CANCELADO')),
    # RELACIONAMENTO item_solicitacao ENTRE solicitacao_exame
    CONSTRAINT fk_item_solicitacao
    FOREIGN KEY (codigo_solicitacao)
    REFERENCES solicitacao_exame(codigo_solicitacao)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    # RELACIONAMENTO item_solicitacao ENTRE exame
    CONSTRAINT fk_item_exame
    FOREIGN KEY (codigo_exame)
    REFERENCES exame(codigo_exame)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA pagamento
CREATE TABLE pagamento(
    codigo_pagamento INT NOT NULL,
    codigo_consulta INT,
    codigo_solicitacao INT,
    codigo_convenio INT,
    forma_pagamento VARCHAR(20) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATE,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT pk_pagamento PRIMARY KEY (codigo_pagamento),
    # UMA CONSULTA NAO PODE TER DOIS PAGAMENTOS
    CONSTRAINT uq_pagamento_consulta UNIQUE (codigo_consulta),
    # UMA SOLICITACAO NAO PODE TER DOIS PAGAMENTOS
    CONSTRAINT uq_pagamento_solicitacao UNIQUE (codigo_solicitacao),
    # FORMA DE PAGAMENTO DEVE SER UMA DAS OPCOES PERMITIDAS
    CONSTRAINT chk_pagamento_forma CHECK (forma_pagamento IN ('CONVENIO','DINHEIRO','DEBITO','CREDITO','PIX')),
    # VALOR DO PAGAMENTO NAO PODE SER NEGATIVO
    CONSTRAINT chk_pagamento_valor CHECK (valor >= 0),
    # STATUS DO PAGAMENTO DEVE SER PENDENTE, PAGO OU CANCELADO
    CONSTRAINT chk_pagamento_status CHECK (status IN ('PENDENTE','PAGO','CANCELADO')),
    # PAGAMENTO DEVE SER DE UMA CONSULTA OU SOLICITACAO, NUNCA DOS DOIS
    CONSTRAINT chk_pagamento_origem CHECK ((codigo_consulta IS NOT NULL AND codigo_solicitacao IS NULL) OR (codigo_consulta IS NULL AND codigo_solicitacao IS NOT NULL)),
    # PAGAMENTO POR CONVENIO DEVE TER UM CONVENIO INFORMADO
    CONSTRAINT chk_pagamento_convenio CHECK (forma_pagamento <> 'CONVENIO' OR codigo_convenio IS NOT NULL),
    # RELACIONAMENTO pagamento ENTRE consulta
    CONSTRAINT fk_pagamento_consulta
    FOREIGN KEY (codigo_consulta)
    REFERENCES consulta(codigo_consulta)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    # RELACIONAMENTO pagamento ENTRE solicitacao_exame
    CONSTRAINT fk_pagamento_solicitacao
    FOREIGN KEY (codigo_solicitacao)
    REFERENCES solicitacao_exame(codigo_solicitacao)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    # RELACIONAMENTO pagamento ENTRE convenio
    CONSTRAINT fk_pagamento_convenio
    FOREIGN KEY (codigo_convenio)
    REFERENCES convenio(codigo_convenio)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

#CRIANDO A TABELA funcionario
CREATE TABLE funcionario(
    matricula INT NOT NULL,
    matricula_supervisor INT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    data_admissao DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    telefone VARCHAR(20),
    CONSTRAINT pk_funcionario PRIMARY KEY (matricula),
    # MATRICULA DO FUNCIONARIO NAO PODE SE REPETIR
    CONSTRAINT uq_funcionario_matricula UNIQUE (matricula),
    # CPF DO FUNCIONARIO NAO PODE SE REPETIR
    CONSTRAINT uq_funcionario_cpf UNIQUE (cpf),
    # SALARIO DO FUNCIONARIO NAO PODE SER NEGATIVO
    CONSTRAINT chk_funcionario_salario CHECK (salario >= 0),
    # FUNCIONARIO NAO PODE SER SEU PROPRIO SUPERVISOR
    CONSTRAINT chk_funcionario_supervisor CHECK (matricula_supervisor IS NULL OR matricula_supervisor <> matricula),
    # RELACIONAMENTO funcionario ENTRE funcionario
    CONSTRAINT fk_funcionario_supervisor
    FOREIGN KEY (matricula_supervisor)
    REFERENCES funcionario(matricula)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


#INSERINDO DADOS NA TABELA paciente
INSERT INTO paciente VALUES (1,'Ana Souza','12345678901','1998-05-12','F','ana@email.com','Rua das Flores','10',NULL,'Centro','Rio de Janeiro','RJ','20000000');
INSERT INTO paciente VALUES (2,'Carlos Lima','12345678902','1987-09-20','M','carlos@email.com','Rua do Sol','25','Apto 201','Centro','Duque de Caxias','RJ','25000000');
INSERT INTO paciente VALUES (3,'Julia Costa','12345678903','2001-02-15','F','julia@email.com','Avenida Brasil','100',NULL,'Penha','Rio de Janeiro','RJ','21000000');

#INSERINDO DADOS NA TABELA telefone_paciente
INSERT INTO telefone_paciente VALUES (1,1,'21999990001','CELULAR');
INSERT INTO telefone_paciente VALUES (2,2,'21999990002','CELULAR');
INSERT INTO telefone_paciente VALUES (3,3,'21999990003','CELULAR');

#INSERINDO DADOS NA TABELA contato_emergencia
INSERT INTO contato_emergencia VALUES (1,1,'Maria Souza','21988880001','Mae');
INSERT INTO contato_emergencia VALUES (2,2,'Paulo Lima','21988880002','Irmao');
INSERT INTO contato_emergencia VALUES (3,3,'Pedro Costa','21988880003','Pai');

#INSERINDO DADOS NA TABELA convenio
INSERT INTO convenio VALUES (1,'Saude Vida','11111111000111','2130000001',80.00);
INSERT INTO convenio VALUES (2,'Bem Estar','22222222000122','2130000002',70.00);
INSERT INTO convenio VALUES (3,'Vida Total','33333333000133','2130000003',90.00);

#INSERINDO DADOS NA TABELA paciente_convenio
INSERT INTO paciente_convenio VALUES (1,1,'A100','2027-12-31','TITULAR');
INSERT INTO paciente_convenio VALUES (2,2,'B200','2028-06-30','TITULAR');
INSERT INTO paciente_convenio VALUES (3,3,'C300','2027-10-31','DEPENDENTE');

#INSERINDO DADOS NA TABELA consultorio
INSERT INTO consultorio VALUES (1,'Sala 101','Primeiro andar');
INSERT INTO consultorio VALUES (2,'Sala 102','Primeiro andar');
INSERT INTO consultorio VALUES (3,'Sala 201','Segundo andar');

#INSERINDO DADOS NA TABELA medico
INSERT INTO medico VALUES (1,1,'Roberto Alves','123456','RJ','2022-01-10','21977770001','roberto@clinica.com',9000.00);
INSERT INTO medico VALUES (2,2,'Fernanda Rocha','234567','RJ','2021-03-15','21977770002','fernanda@clinica.com',10000.00);
INSERT INTO medico VALUES (3,3,'Marcos Silva','345678','RJ','2023-07-20','21977770003','marcos@clinica.com',8500.00);

#INSERINDO DADOS NA TABELA especialidade
INSERT INTO especialidade VALUES (1,'Cardiologia');
INSERT INTO especialidade VALUES (2,'Dermatologia');
INSERT INTO especialidade VALUES (3,'Clinica Geral');

#INSERINDO DADOS NA TABELA medico_especialidade
INSERT INTO medico_especialidade VALUES (1,1);
INSERT INTO medico_especialidade VALUES (2,2);
INSERT INTO medico_especialidade VALUES (3,3);

#INSERINDO DADOS NA TABELA consulta
INSERT INTO consulta VALUES (1,1,1,'2026-11-10','09:00:00');
INSERT INTO consulta VALUES (2,2,2,'2026-11-10','10:00:00');
INSERT INTO consulta VALUES (3,3,3,'2026-11-11','11:00:00');

#INSERINDO DADOS NA TABELA prescricao
INSERT INTO prescricao VALUES (1,1,'Orientacoes de acompanhamento cardiologico');
INSERT INTO prescricao VALUES (2,2,'Uso de creme conforme orientacao medica');
INSERT INTO prescricao VALUES (3,3,'Repouso e acompanhamento clinico');

#INSERINDO DADOS NA TABELA solicitacao_exame
INSERT INTO solicitacao_exame VALUES (1,1,'2026-11-10');
INSERT INTO solicitacao_exame VALUES (2,2,'2026-11-10');
INSERT INTO solicitacao_exame VALUES (3,3,'2026-11-11');

#INSERINDO DADOS NA TABELA exame
INSERT INTO exame VALUES (1,'Hemograma','Exame de sangue',60.00,2,'LABORATORIAL');
INSERT INTO exame VALUES (2,'Ultrassonografia','Exame de imagem',150.00,3,'IMAGEM');
INSERT INTO exame VALUES (3,'Glicemia','Exame de glicose',40.00,1,'LABORATORIAL');

#INSERINDO DADOS NA TABELA item_solicitacao
INSERT INTO item_solicitacao VALUES (1,1,1,NULL,NULL,'PENDENTE');
INSERT INTO item_solicitacao VALUES (2,2,2,NULL,NULL,'PENDENTE');
INSERT INTO item_solicitacao VALUES (3,3,3,NULL,NULL,'PENDENTE');

#INSERINDO DADOS NA TABELA pagamento
INSERT INTO pagamento VALUES (1,1,NULL,1,'CONVENIO',100.00,'2026-11-10','PAGO');
INSERT INTO pagamento VALUES (2,2,NULL,NULL,'PIX',150.00,'2026-11-10','PAGO');
INSERT INTO pagamento VALUES (3,3,NULL,NULL,'CREDITO',120.00,NULL,'PENDENTE');
INSERT INTO pagamento VALUES (4,NULL,1,1,'CONVENIO',60.00,NULL,'PENDENTE');
INSERT INTO pagamento VALUES (5,NULL,2,NULL,'DINHEIRO',150.00,NULL,'PENDENTE');
INSERT INTO pagamento VALUES (6,NULL,3,NULL,'DEBITO',40.00,NULL,'PENDENTE');

#INSERINDO DADOS NA TABELA funcionario
INSERT INTO funcionario VALUES (1,NULL,'Mariana Santos','98765432101','Gerente','2020-02-01',5000.00,'21966660001');
INSERT INTO funcionario VALUES (2,1,'Joao Pereira','98765432102','Recepcionista','2022-04-10',2200.00,'21966660002');
INSERT INTO funcionario VALUES (3,1,'Beatriz Oliveira','98765432103','Auxiliar','2023-06-15',2100.00,'21966660003');

# UM MEDICO NAO PODE TER DUAS CONSULTAS NO MESMO HORARIO
# A CONSTRAINT uq_consulta_medico_horario TAMBEM CRIA UM INDICE
# O CPF DO PACIENTE NAO PODE SE REPETIR
# A CONSTRAINT uq_paciente_cpf TAMBEM CRIA UM INDICE
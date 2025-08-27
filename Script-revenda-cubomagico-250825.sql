CREATE DATABASE db_revenda_mathias;


--Revenda de cubos mágicos


CREATE TABLE clientes (
    id_cliente serial PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_cadastro DATE,
    status_atividade BOOLEAN DEFAULT TRUE
);

CREATE TABLE fornecedores (
    id_fornecedor serial PRIMARY KEY,
    nome_empresa VARCHAR(100) NOT NULL,
    contato VARCHAR(255),
    email VARCHAR(100) UNIQUE,
    pais VARCHAR(50) DEFAULT 'China',
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE produtos (
    id_produto serial PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    categoria varchar(255),
    preco DECIMAL(10,2) CHECK (preco > 0),
    estoque INT DEFAULT 0,
    id_fornecedor int,
    foreign key (id_fornecedor) REFERENCES fornecedores(id_fornecedor)
);

CREATE TABLE pedidos (
    id_pedido serial PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES clientes(id_cliente),
    data_pedido timestamp,
    status varchar(255) DEFAULT 'pendente',
    valor_total DECIMAL(10,2) DEFAULT 0 CHECK (valor_total >= 0)
);

CREATE TABLE itens_pedido (
    id_pedido INT,
    id_produto INT,
    quantidade varchar(255) not null,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

CREATE TABLE pagamentos (
    id_pagamento serial PRIMARY KEY,
    id_pedido INT NOT NULL REFERENCES pedidos(id_pedido),
    metodo varchar(255) NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL,
    data_pagamento TIMESTAMP,
    status varchar(255) DEFAULT 'pendente'
);

--Views
CREATE VIEW vw_pedidos_detalhados AS
SELECT 
    p.id_pedido,
    c.nome AS cliente,
    pr.nome_produto,
    ip.quantidade,
    ip.preco_unitario,
    p.valor_total,
    p.status AS status_pedido
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
JOIN produtos pr ON ip.id_produto = pr.id_produto;

CREATE VIEW vw_produtos_fornecedores AS
SELECT 
    pr.id_produto,
    pr.nome_produto,
    pr.categoria,
    pr.preco,
    pr.estoque,
    f.nome_empresa AS fornecedor
FROM produtos pr
JOIN fornecedores f ON pr.id_fornecedor = f.id_fornecedor;

--Inserts

INSERT INTO clientes (nome, email, telefone) VALUES
('Lucas Andrade', 'lucas@mail.com', '11999990001'),
('Maria Silva', 'maria@mail.com', '11999990002'),
('Pedro Costa', 'pedro@mail.com', '11999990003'),
('João Nunes', 'joao@mail.com', '11999990004'),
('Ana Paula', 'ana@mail.com', '11999990005'),
('Felipe Souza', 'felipe@mail.com', '11999990006'),
('Carla Mendes', 'carla@mail.com', '11999990007'),
('Rafael Gomes', 'rafael@mail.com', '11999990008'),
('Beatriz Rocha', 'bia@mail.com', '11999990009'),
('Thiago Almeida', 'thiago@mail.com', '11999990010');

INSERT INTO fornecedores (nome_empresa, contato, email) VALUES
('Shenzhen Cube Co', 'Li Wei', 'contact@szcube.cn'),
('Guangzhou Toys Ltd', 'Chen Yang', 'sales@gzt.cn'),
('Shanghai Speedcube', 'Wang Lei', 'info@ssc.cn'),
('Beijing Puzzle Import', 'Zhao Min', 'support@bpimport.cn'),
('Dongguan Cubes', 'Hu Xia', 'dg@cubeschina.cn'),
('Yiwu Trading', 'Chen Fang', 'yiwu@trade.cn'),
('Hong Kong Cubes', 'Lee Man', 'hk@cube.hk'),
('Ningbo Magic Co', 'Xu Ping', 'ningbo@magic.cn'),
('Suzhou Cube Export', 'Qin Yu', 'suzhou@cube.cn'),
('Hangzhou Toys', 'Sun Bo', 'hztoys@hz.cn');

INSERT INTO produtos (nome_produto, categoria, preco, estoque, id_fornecedor) VALUES
('Cubo Mágico 2x2 Básico', '2x2', 15.90, 100, 1),
('Cubo Mágico 3x3 Speed', '3x3', 35.50, 200, 2),
('Cubo 4x4 Profissional', '4x4', 55.00, 150, 3),
('Cubo 5x5 Avançado', '5x5', 75.00, 80, 4),
('Megaminx Clássico', 'Megaminx', 60.00, 50, 5),
('Pyraminx Speed', 'Pyraminx', 40.00, 70, 6),
('Cubo Mirror', 'Outros', 45.00, 40, 7),
('Cubo Fisher', 'Outros', 42.00, 30, 8),
('Cubo Windmill', 'Outros', 48.00, 25, 9),
('Cubo 3x3 Magnético', '3x3', 90.00, 60, 10);

INSERT INTO pedidos (id_cliente, status, valor_total) VALUES
(1, 'pendente', 0),
(2, 'enviado', 0),
(3, 'concluido', 0),
(4, 'pendente', 0),
(5, 'cancelado', 0),
(6, 'concluido', 0),
(7, 'pendente', 0),
(8, 'enviado', 0),
(9, 'pendente', 0),
(10, 'concluido', 0);

INSERT INTO itens_pedido VALUES
(1, 2, 1, 35.50),
(1, 1, 2, 15.90),
(2, 3, 1, 55.00),
(3, 5, 1, 60.00),
(4, 6, 2, 40.00),
(5, 4, 1, 75.00),
(6, 7, 1, 45.00),
(7, 8, 1, 42.00),
(8, 9, 1, 48.00),
(9, 10, 1, 90.00);

INSERT INTO pagamentos (id_pedido, metodo, valor_pago, status) VALUES
(1, 'pix', 67.30, 'pago'),
(2, 'cartao', 55.00, 'pago'),
(3, 'boleto', 60.00, 'pago'),
(4, 'pix', 80.00, 'pago'),
(5, 'cartao', 75.00, 'falhou'),
(6, 'pix', 45.00, 'pago'),
(7, 'boleto', 42.00, 'pendente'),
(8, 'cartao', 48.00, 'pago'),
(9, 'pix', 90.00, 'pago'),
(10, 'cartao', 120.00, 'pago');

--Consultando as views
SELECT * FROM vw_pedidos_detalhados;
SELECT * FROM vw_produtos_fornecedores;

--Consulta com Like

select 
	*
from
	produtos pr
where pr.nome_produto like '%2x2%'

--Adicionando Explain

explain select * from produtos pr where pr.nome_produto like '%2x2%'

--Fazendo a consulta com index

create index idx_tagproduto
on produtos(nome_produto, preco)

--Criando usuário e dando acesso total

create user mathias with password 'bazinga'; --Cria o usuário
grant connect on database db_revenda_mathias to mathias; --Concede acesso ao banco
grant all privileges on all tables in schema public to mathias; --Concende todos os privilégios para todas as tabelas
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO mathias; --Concete todos os privilégios para todas as tabelas que serão criadas no futuro

--Criando usuário colega e permissão de select
create user nicolas with password '23571113';
GRANT SELECT ON TABLE produtos TO nicolas;

--CONSULTAS COM INNERJOIN
SELECT pedidos.id_pedido, clientes.nome, produtos.nome_produto
FROM pedidos
INNER JOIN clientes ON pedidos.id_cliente = clientes.id_cliente
INNER JOIN itens_pedido ON pedidos.id_pedido = itens_pedido.id_pedido
INNER JOIN produtos ON itens_pedido.id_produto = produtos.id_produto;

--pedidos de cada cliente
SELECT clientes.nome, pedidos.id_pedido, pedidos.data_pedido
FROM clientes
INNER JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;

--produtos vendidos por fornecedor
SELECT fornecedores.nome_empresa, COUNT(produtos.id_produto) AS total_produtos
FROM fornecedores
INNER JOIN produtos ON fornecedores.id_fornecedor = produtos.id_fornecedor
GROUP BY fornecedores.nome_empresa;

--pagamentos e pedidos
SELECT pagamentos.id_pagamento, pedidos.id_pedido, pedidos.data_pedido
FROM pagamentos
INNER JOIN pedidos ON pagamentos.id_pedido = pedidos.id_pedido;

--CONSULTAS COM RIGHTJOIN
SELECT pedidos.id_pedido, clientes.nome, produtos.nome_produto
FROM pedidos
RIGHT JOIN clientes ON pedidos.id_cliente = clientes.id_cliente
RIGHT JOIN itens_pedido ON pedidos.id_pedido = itens_pedido.id_pedido
RIGHT JOIN produtos ON itens_pedido.id_produto = produtos.id_produto;

SELECT fornecedores.nome_empresa, COUNT(produtos.id_produto) AS total_produtos
FROM fornecedores
RIGHT JOIN produtos ON fornecedores.id_fornecedor = produtos.id_fornecedor
GROUP BY fornecedores.nome_empresa;

SELECT pagamentos.id_pagamento, pedidos.id_pedido, pedidos.data_pedido
FROM pagamentos
RIGHT JOIN pedidos ON pagamentos.id_pedido = pedidos.id_pedido;

SELECT clientes.nome, pedidos.id_pedido, pedidos.data_pedido
FROM clientes
RIGHT JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;


--CONSULTAS COM LEFTJOIN
SELECT pedidos.id_pedido, clientes.nome, produtos.nome_produto
FROM pedidos
LEFT JOIN clientes ON pedidos.id_cliente = clientes.id_cliente
LEFT JOIN itens_pedido ON pedidos.id_pedido = itens_pedido.id_pedido
LEFT JOIN produtos ON itens_pedido.id_produto = produtos.id_produto;

SELECT fornecedores.nome_empresa, COUNT(produtos.id_produto) AS total_produtos
FROM fornecedores
LEFT JOIN produtos ON fornecedores.id_fornecedor = produtos.id_fornecedor
GROUP BY fornecedores.nome_empresa;

SELECT pagamentos.id_pagamento, pedidos.id_pedido, pedidos.data_pedido
FROM pagamentos
LEFT JOIN pedidos ON pagamentos.id_pedido = pedidos.id_pedido;

SELECT clientes.nome, pedidos.id_pedido, pedidos.data_pedido
FROM clientes
LEFT JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;


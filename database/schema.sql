CREATE TABLE fornecedores (
    id SERIAL PRIMARY KEY, 
    nome VARCHAR(150) NOT NULL,
    cnpj_cpf VARCHAR(20) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(120), 
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY, 
    nome VARCHAR(150) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE, 
    telefone VARCHAR(20), 
    email VARCHAR(120), 
    ativo BOOLEAN DEFAULT TRUE, 
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE itens (
    id SERIAL PRIMARY KEY, 
    nome VARCHAR(150) NOT NULL, 
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('INSUMO', 'PRODUTO_ACABADO')),
    unidade_medida VARCHAR(10) NOT NULL,
    estoque_atual NUMERIC(10, 3) NOT NULL DEFAULT 0 CHECK (estoque_atual >= 0),
    estoque_minimo NUMERIC(10, 3) NOT NULL DEFAULT 0, 
    custo_unitario NUMERIC(10, 2) NOT NULL DEFAULT 0, 
    preco_venda NUMERIC(10, 2) NOT NULL DEFAULT 0, 
    ativo BOOLEAN DEFAULT TRUE, 
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE ficha_tecnica (
    id SERIAL PRIMARY KEY, 
    produto_id INT NOT NULL REFERENCES itens(id) ON DELETE CASCADE,
    insumo_id INT NOT NULL REFERENCES itens(id) ON DELETE RESTRICT, 
    quantidade_necessaria NUMERIC(10, 3) NOT NULL CHECK (quantidade_necessaria > 0), 
    CONSTRAINT uq_produto_insumo UNIQUE (produto_id, insumo_id)
);

CREATE TABLE compras (
    id SERIAL PRIMARY KEY, 
    fornecedor_id INT NOT NULL REFERENCES fornecedores(id) ON DELETE RESTRICT, 
    valor_total NUMERIC(10, 2) NOT NULL CHECK (valor_total >= 0), 
    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    usuario_email VARCHAR(120) NOT NULL
);

CREATE TABLE itens_compra (
    id SERIAL PRIMARY KEY,
    compra_id INT NOT NULL REFERENCES compras(id) ON DELETE CASCADE,
    insumo_id INT NOT NULL REFERENCES itens(id) ON DELETE RESTRICT, 
    quantidade NUMERIC(10, 3) NOT NULL CHECK (quantidade > 0),
    custo_unitario NUMERIC(10, 2) NOT NULL CHECK (custo_unitario >= 0) 
); 

CREATE TABLE ordens_producao (
    id SERIAL PRIMARY KEY, 
    produto_id INT NOT NULL REFERENCES itens(id) ON DELETE RESTRICT, 
    quantidade_produzida NUMERIC(10, 3) NOT NULL CHECK (quantidade_produzida > 0),
    custo_total_producao NUMERIC(10, 2) NOT NULL DEFAULT 0,
    data_producao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_email VARCHAR(120) NOT NULL
); 

CREATE TABLE vendas (
    id SERIAL PRIMARY KEY, 
    cliente_id INT NOT NULL REFERENCES clientes(id) ON DELETE SET NULL, 
    valor_total NUMERIC(10, 2) NOT NULL CHECK (valor_total >= 0), 
    forma_pagamento VARCHAR(50) NOT NULL, 
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    usuario_email VARCHAR(120) NOT NULL
); 

CREATE TABLE itens_venda (
    id SERIAL PRIMARY KEY, 
    vanda_id INT NOT NULL REFERENCES vendas(id) ON DELETE CASCADE, 
    produto_id INT NOT NULL REFERENCES itens(id) ON DELETE RESTRICT, 
    quantidade NUMERIC(10, 3) NOT NULL CHECK (quantidade > 0), 
    preco_unitario NUMERIC(10, 2) NOT NULL CHECK (preco_unitario >= 0)
); 

CREATE TABLE movimentacoes_estoque (
    id SERIAL PRIMARY KEY, 
    item_id INT NOT NULL REFERENCES itens(id) ON DELETE RESTRICT, 
    tipo_movimentacao VARCHAR(50) NOT NULL CHECK (tipo_movimentacao IN ('ENTRADA_COMPRA', 'SAIDA_PRODUCAO', 'ENTRADA_PRODUCAO')), 
    quantidade NUMERIC(10, 3) NOT NULL CHECK (quantidade > 0), 
    origem_modulo VARCHAR(50) NOT NULL, 
    origem_id INT NOT NULL, 
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    usuario_email VARCHAR(120) NOT NULL
);

CREATE TABLE movimentacoes_financeiras ( 
    id SERIAL PRIMARY KEY, 
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('RECEITA', 'DESPESA')), 
    categoria VARCHAR(50) NOT NULL, 
    descricao TEXT NOT NULL,
    valor NUMERIC(10, 2) NOT NULL CHECK (valor > 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDENTE', 'PAGO')), 
    data_vencimento DATE NOT NULL, 
    data_pagamento TIMESTAMP, 
    origem_modulo VARCHAR(50), 
    origem_id INT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    usuario_email VARCHAR(120) NOT NULL 
);
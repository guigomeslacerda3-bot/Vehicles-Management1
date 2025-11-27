-- 1. Criação do Banco de Dados (Schema)
CREATE DATABASE IF NOT EXISTS gwm_parking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE gwm_parking;

-- 2. Tabela Principal de Registro de Vagas
CREATE TABLE IF NOT EXISTS parking_log (
    -- Chave Primária Artificial (Garante unicidade e performance)
    log_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    -- Identificador Único da Vaga
    -- Formato: CHAR(3) ex: 'A01', 'F34' (para spots 1-9) ou CHAR(4) ex: 'A10' (para spots 10-34)
    -- VARCHAR(4) é usado para flexibilidade.
    spot_key VARCHAR(4) NOT NULL, 

    -- Dados da Localização
    parking_row CHAR(1) NOT NULL,   -- Ex: 'A', 'B', 'C'
    spot_number TINYINT UNSIGNED NOT NULL, -- Ex: 1 a 34

    -- Dados do Carro (VIN)
    vin_number CHAR(17) NOT NULL UNIQUE, -- O VIN é sempre único e tem 17 caracteres

    -- Metadados de Tempo (para registro de auditoria e exportação CSV)
    -- TIMESTAMP é ideal pois registra a hora automaticamente em UTC
    allocation_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    -- Restrições e Otimizações
    -- Garante que cada vaga só possa ser ocupada uma vez (chave candidata)
    UNIQUE KEY uk_spot (spot_key),
    
    -- Índices para consultas rápidas
    -- Índice no VIN (para checar se o carro já está estacionado)
    INDEX idx_vin (vin_number), 
    -- Índice na fileira (para visualização no mapa)
    INDEX idx_row (parking_row)
)
ENGINE=InnoDB 
DEFAULT CHARSET=utf8mb4 
COLLATE=utf8mb4_unicode_ci;
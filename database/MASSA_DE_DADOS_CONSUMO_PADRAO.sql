USE ENCANTO_ODONTO;
GO

-- =================================================================================
-- 1. TRUNCATE: Limpa a tabela para garantir que não haja duplicatas
-- =================================================================================
TRUNCATE TABLE CONSUMO_PADRAO;
GO

-- =================================================================================
-- 2. INSERÇÃO COMPLETA para os 11 Procedimentos
-- =================================================================================
INSERT INTO CONSUMO_PADRAO (ID_PROCEDIMENTO, ID_PRODUTO, QTD_PADRAO)
VALUES
    -- PROCEDIMENTOS JÁ INSERIDOS (REORGANIZADOS)
    -- ID 2: REST. RESINA ESTÉTICA
    (2, 1, 0.50),   
    (2, 2, 0.10),   
    (2, 3, 0.05),   
    (2, 7, 1.00),   
    (2, 9, 0.15),   

    -- ID 3: CLAREADOR DE CONSULTÓRIO
    (3, 15, 1.00),  
    (3, 10, 1.00),  
    (3, 7, 1.00),   

    -- ID 7: LENTE DE CONTATO DENTAL
    (7, 5, 0.50),   
    (7, 9, 0.50),   
    (7, 7, 1.00),   
    (7, 12, 0.05),  

    -- ID 5: TRATAMENTO DE CANAL
    (5, 4, 2.00),   
    (5, 7, 1.00),   
    (5, 12, 0.10),  

    -- ID 6: EXTRAÇÃO DENTAL SIMPLES
    (6, 4, 1.00),   
    (6, 13, 0.50),  
    (6, 7, 1.00),   

    -- NOVOS PROCEDIMENTOS
    -- ID 1: LIMPEZA E PROFILAXIA
    (1, 6, 0.20),   
    (1, 7, 1.00),   
    (1, 8, 0.10),   
    (1, 14, 1.00),  

    -- ID 4: PLACA DE BRUXISMO
    (4, 11, 0.50),  
    (4, 20, 0.10),  
    (4, 7, 1.00),   

    -- ID 8: CIRURGIA DE SISOS
    (8, 21, 1.00),  
    (8, 13, 1.00),  
    (8, 4, 2.00),   
    (8, 22, 5.00),  
    (8, 7, 2.00),   

    -- ID 9: FACETAS DE PORCELANA
    (9, 5, 1.00),   
    (9, 9, 1.00),   
    (9, 3, 0.10),   
    (9, 7, 1.00),   

    -- ID 10: TRATAMENTO DE GENGIVA
    (10, 23, 0.20), 
    (10, 7, 1.00),  
    (10, 12, 0.05), 

    -- ID 11: PRÓTESE TOTAL (DENTADURA)
    (11, 11, 1.00), 
    (11, 24, 0.50), 
    (11, 20, 0.50), 
    (11, 7, 1.00);  
GO

-- =================================================================================
-- 3. CONFIRMAÇÃO DA INSERÇÃO
-- =================================================================================
SELECT 
    CP.ID_PROCEDIMENTO, 
    P.NOME AS Nome_Procedimento, 
    CP.ID_PRODUTO, 
    CP.QTD_PADRAO
FROM CONSUMO_PADRAO CP
JOIN PROCEDIMENTO P ON CP.ID_PROCEDIMENTO = P.ID_PROCEDIMENTO
ORDER BY 1;
GO
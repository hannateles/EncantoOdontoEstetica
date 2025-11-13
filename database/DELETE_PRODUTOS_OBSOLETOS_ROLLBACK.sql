USE ENCANTO_ODONTO;
GO

BEGIN TRANSACTION;

-- Guarda os IDs dos produtos que serão deletados (os que estão com estoque zerado e não foram usados)
DECLARE @ProdutosParaExcluir TABLE (ID_PRODUTO INT);
INSERT INTO @ProdutosParaExcluir (ID_PRODUTO)
SELECT 
    ID_PRODUTO 
FROM 
    PRODUTO_ESTOQUE
WHERE 
    ID_PRODUTO NOT IN (SELECT ID_PRODUTO FROM USO_MATERIAL)
    AND QTD_ESTOQUE = 0.00;


-- ====================================================================
-- LIMPEZA DA INTEGRIDADE REFERENCIAL 
-- Remove as referências desses produtos na tabela CONSUMO_PADRAO.
-- ====================================================================
DELETE FROM CONSUMO_PADRAO
WHERE ID_PRODUTO IN (SELECT ID_PRODUTO FROM @ProdutosParaExcluir);


-- ====================================================================
-- 3. EXECUÇÃO DO DELETE PRINCIPAL
-- Deleta os produtos obsoletos (que não têm uso registrado, estoque zerado e não têm mais referências).
-- ====================================================================
DELETE FROM PRODUTO_ESTOQUE
WHERE 
    ID_PRODUTO IN (SELECT ID_PRODUTO FROM @ProdutosParaExcluir); -- Usa a lista segura

SELECT * FROM PRODUTO_ESTOQUE
WHERE 
    ID_PRODUTO IN (SELECT ID_PRODUTO FROM @ProdutosParaExcluir); -- COMPROVA QUE FUNCIONOU
-- ====================================================================
-- 4. REVERSÃO
-- ====================================================================
ROLLBACK TRANSACTION; 
-- COMMIT TRANSACTION;

GO

SELECT 
    'Produtos DEPOIS do ROLLBACK' AS Etapa,
    COUNT(ID_PRODUTO) AS Total_Produtos 
FROM 
    PRODUTO_ESTOQUE;

GO
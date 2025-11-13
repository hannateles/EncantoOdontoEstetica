USE ENCANTO_ODONTO;
GO

-- 1. DROP VIEW
IF OBJECT_ID('RELATORIO_ESTOQUE_CRITICO') IS NOT NULL
    DROP VIEW RELATORIO_ESTOQUE_CRITICO;
GO

-- 2. CREATE VIEW
CREATE VIEW RELATORIO_ESTOQUE_CRITICO AS
WITH ConsumoTotal AS (
    -- Calcula a quantidade total consumida de cada produto.
    SELECT
        ID_PRODUTO,
        SUM(QTD_REAL_CONSUMIDA) AS QTD_CONSUMIDA_TOTAL
    FROM
        USO_MATERIAL
    GROUP BY
        ID_PRODUTO
)

SELECT
    PE.ID_PRODUTO,
    PE.NOME_PRODUTO AS Nome_Produto,
    PE.QTD_ESTOQUE AS Saldo_Atual_Estoque,
    COALESCE(CT.QTD_CONSUMIDA_TOTAL, 0) AS Qtd_Consumida_Total, -- COALESCE para produtos sem consumo
    PE.CUSTO_UNITARIO AS Custo_Unitario,
    
    -- Métrica de Alerta e Status
    CASE
        WHEN PE.QTD_ESTOQUE <= 0 THEN '1 - Esgotado (Prioridade Máxima)'
        WHEN PE.QTD_ESTOQUE < 100 THEN '2 - Crítico (Requer Compra Imediata)' -- Limite de segurança de 100
        WHEN PE.QTD_ESTOQUE < 300 THEN '3 - Atenção (Monitorar Consumo)'     -- Limite de atenção de 500
        ELSE '4 - OK'
    END AS STATUS_ESTOQUE
    
FROM
    PRODUTO_ESTOQUE PE
LEFT JOIN
    ConsumoTotal CT ON PE.ID_PRODUTO = CT.ID_PRODUTO;

GO

-- 3. Teste da View
SELECT TOP 1000 * FROM RELATORIO_ESTOQUE_CRITICO
ORDER BY Saldo_Atual_Estoque ASC; -- Ordena para ver os críticos no topo
GO
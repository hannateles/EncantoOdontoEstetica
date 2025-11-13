-- POPULANDO A TABELA ATENDIMENTO_PROCEDIMENTO COM MASSA DE DADOS BASEADO EM CONSULTAS PARA A INTEGRIDADE DO BANCO.
-- INSERÇÃO OTIMIZADA USANDO CROSS APPLY E CTEs
;WITH ConsultasRealizadas AS (
    -- Seleciona todas as consultas realizadas
    SELECT 
        ID_CONSULTA,
        -- Gera a quantidade de procedimentos diferentes para esta consulta (1 a 3)
        CAST(ABS(CHECKSUM(NEWID())) % 3 + 1 AS INT) AS QtdProcedimentos
    FROM CONSULTA 
    WHERE STATUS = 'REALIZADA'
),
ProcedimentosBase AS (
    -- Gera N linhas de IDs de Procedimento por Consulta.
    SELECT 
        CR.ID_CONSULTA,
        P.ID_PROCEDIMENTO,
        P.VALOR_BASE,
        P.PERCENTUAL_COMISSAO,
        -- Gera a Qtd de unidades (1 para a maioria, 1 a 7 para LENTE DE CONTATO DENTAL - ID 7)
        CASE 
            WHEN P.ID_PROCEDIMENTO = 7 
            THEN CAST(ABS(CHECKSUM(NEWID())) % 7 + 1 AS INT) -- 1 a 7 dentes
            ELSE 1 
        END AS QtdUnidades
    FROM ConsultasRealizadas CR
    CROSS APPLY (
        -- Seleciona aleatoriamente o número de procedimentos definido em QtdProcedimentos
        SELECT TOP (CR.QtdProcedimentos) 
            ID_PROCEDIMENTO, VALOR_BASE, PERCENTUAL_COMISSAO
        FROM PROCEDIMENTO
        ORDER BY NEWID() -- Randomiza a seleção de procedimentos
    ) AS P
)
INSERT INTO ATENDIMENTO_PROCEDIMENTO (ID_CONSULTA, ID_PROCEDIMENTO, VALOR_COBRADO, VALOR_COMISSAO)
SELECT 
    PB.ID_CONSULTA,
    PB.ID_PROCEDIMENTO,
    PB.VALOR_BASE, -- O valor cobrado é o valor base (tratamos as unidades no passo 4)
    (PB.VALOR_BASE * (PB.PERCENTUAL_COMISSAO / 100.00)) AS VALOR_COMISSAO
FROM ProcedimentosBase PB
-- 4. Expande a tabela: Faz um JOIN para multiplicar as linhas pela QtdUnidades.
-- Isso insere 4 linhas se QtdUnidades for 4, simulando 4 Lentes de Contato.
CROSS APPLY (
    SELECT TOP (PB.QtdUnidades) 1 AS N -- Gera N linhas
    FROM sys.objects -- Tabela de sistema para gerar N linhas
) AS Unidades
ORDER BY PB.ID_CONSULTA;
GO

SELECT 'STATUS: População da tabela ATENDIMENTO_PROCEDIMENTO concluída com sucesso. Total de Registros: ' + CAST(COUNT(*) AS VARCHAR)
FROM ATENDIMENTO_PROCEDIMENTO;
GO
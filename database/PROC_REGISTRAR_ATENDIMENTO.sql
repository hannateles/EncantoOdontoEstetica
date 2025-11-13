USE ENCANTO_ODONTO;
GO

-- ====================================================================
-- 1. STORED PROCEDURE: SP_REGISTRAR_ATENDIMENTO
-- ====================================================================

IF OBJECT_ID('SP_REGISTRAR_ATENDIMENTO') IS NOT NULL
    DROP PROCEDURE SP_REGISTRAR_ATENDIMENTO;
GO

CREATE PROCEDURE SP_REGISTRAR_ATENDIMENTO
    @ID_CONSULTA INT,
    @ID_PROCEDIMENTO INT
AS
BEGIN
    -- Variáveis de cálculo
    DECLARE @ValorBase DECIMAL(10, 2);
    DECLARE @PercentualComissao DECIMAL(5, 2);
    DECLARE @ValorComissaoCalculado DECIMAL(10, 2);
    DECLARE @QtdUnidades INT = 1;

    BEGIN TRANSACTION;

    -- Obter informações básicas
    SELECT
        @ValorBase = P.VALOR_BASE,
        @PercentualComissao = P.PERCENTUAL_COMISSAO,
        @QtdUnidades = CASE 
                            WHEN @ID_PROCEDIMENTO = 7 THEN CAST(ABS(CHECKSUM(NEWID())) % 7 + 1 AS INT) 
                            ELSE 1 
                        END
    FROM PROCEDIMENTO P
    WHERE P.ID_PROCEDIMENTO = @ID_PROCEDIMENTO;

    IF @ValorBase IS NULL
    BEGIN
        RAISERROR('Procedimento com ID %d não encontrado.', 16, 1, @ID_PROCEDIMENTO);
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Cálculo da comissão (aplicável a cada unidade)
    SET @ValorComissaoCalculado = (@ValorBase * (@PercentualComissao / 100.00));

    -- Loop para inserir linhas de atendimento e material
    WHILE @QtdUnidades > 0
    BEGIN
        -- INSERÇÃO 1: ATENDIMENTO_PROCEDIMENTO
        INSERT INTO ATENDIMENTO_PROCEDIMENTO (ID_CONSULTA, ID_PROCEDIMENTO, VALOR_COBRADO, VALOR_COMISSAO)
        VALUES (@ID_CONSULTA, @ID_PROCEDIMENTO, @ValorBase, @ValorComissaoCalculado);

        DECLARE @ID_ATENDIMENTO_PROCEDIMENTO INT = SCOPE_IDENTITY();

        -- INSERÇÃO 2: USO_MATERIAL (Calculando o custo real de material)
        INSERT INTO USO_MATERIAL (ID_ATENDIMENTO_PROCEDIMENTO, ID_PRODUTO, QTD_REAL_CONSUMIDA, CUSTO_TOTAL_MATERIAL)
        SELECT
            @ID_ATENDIMENTO_PROCEDIMENTO,
            CP.ID_PRODUTO,
            CP.QTD_PADRAO,
            PE.CUSTO_UNITARIO * CP.QTD_PADRAO
        FROM
            CONSUMO_PADRAO CP
        JOIN
            PRODUTO_ESTOQUE PE ON CP.ID_PRODUTO = PE.ID_PRODUTO
        WHERE
            CP.ID_PROCEDIMENTO = @ID_PROCEDIMENTO;
            
        SET @QtdUnidades = @QtdUnidades - 1;
    END

    -- UPDATE: Atualiza o VALOR_TOTAL da CONSULTA (Soma todos os procedimentos)
    UPDATE C
    SET C.VALOR_TOTAL = (SELECT SUM(AP.VALOR_COBRADO) FROM ATENDIMENTO_PROCEDIMENTO AP WHERE AP.ID_CONSULTA = C.ID_CONSULTA)
    FROM CONSULTA C
    WHERE C.ID_CONSULTA = @ID_CONSULTA;

    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;
END
GO


-- ====================================================================
-- 2. STORED PROCEDURE: SP_REGISTRAR_PAGAMENTO
-- ====================================================================

IF OBJECT_ID('SP_REGISTRAR_PAGAMENTO') IS NOT NULL
    DROP PROCEDURE SP_REGISTRAR_PAGAMENTO;
GO

CREATE PROCEDURE SP_REGISTRAR_PAGAMENTO
    @ID_CONSULTA INT,
    @FORMA_PAGAMENTO VARCHAR(50)
AS
BEGIN
    DECLARE @ValorTotal DECIMAL(10, 2);
    
    -- 1. Captura o valor total da consulta
    SELECT @ValorTotal = VALOR_TOTAL FROM CONSULTA WHERE ID_CONSULTA = @ID_CONSULTA;
    
    IF @ValorTotal IS NULL OR @ValorTotal = 0.00
    BEGIN
        RAISERROR('Erro: Valor total da consulta não calculado. Execute a primeira PROC antes.', 16, 1);
        RETURN;
    END
    
    -- 2. Insere o registro de pagamento
    INSERT INTO PAGAMENTO_PACIENTE (ID_CONSULTA, VALOR_PAGO, DATA_PAGAMENTO, FORMA_PAGAMENTO)
    VALUES (@ID_CONSULTA, @ValorTotal, GETDATE(), @FORMA_PAGAMENTO);
END
GO


-- ====================================================================
-- 3. FLUXO COMPLETO (TESTE DE EXECUÇÃO)
-- ====================================================================

DECLARE @NovoIDConsulta INT;
DECLARE @ID_PROC_EXEC INT = 2; -- Exemplo: ID=2 (Clareamento)
DECLARE @FormaPgto VARCHAR(50) = 'CARTAO_CREDITO';
DECLARE @Nome_Profissional VARCHAR(100);

-- A. INSERÇÃO (1/4): CRIAÇÃO DA CONSULTA (AGORA COM AS COLUNAS CORRETAS)
INSERT INTO CONSULTA (
    ID_PACIENTE, 
    ID_PROFISSIONAL, 
    DATA_HORA,        
    STATUS, 
    VALOR_TOTAL      -- As colunas da tabela CONSULTA, sem DATA_CRIACAO
)
VALUES (
    (SELECT TOP 1 ID_PACIENTE FROM PACIENTE ORDER BY NEWID()),
    (SELECT TOP 1 ID_PROFISSIONAL FROM PROFISSIONAL ORDER BY NEWID()),
    GETDATE(),
    'REALIZADA',
    0.00
    -- Apenas 5 valores, correspondendo às 5 colunas acima.
);

SET @NovoIDConsulta = SCOPE_IDENTITY();
SELECT @Nome_Profissional = NOME FROM PROFISSIONAL P JOIN CONSULTA C ON P.ID_PROFISSIONAL = C.ID_PROFISSIONAL WHERE C.ID_CONSULTA = @NovoIDConsulta;

PRINT N'----------------------------------------------------------------------------------------------------------------';
PRINT N'INICIANDO FLUXO COMPLETO PARA CONSULTA ID: ' + CAST(@NovoIDConsulta AS VARCHAR) + N' (' + @Nome_Profissional + N')';
PRINT N'----------------------------------------------------------------------------------------------------------------';

-- B. EXECUÇÃO (2/4): REGISTRO DO PROCEDIMENTO, CUSTO REAL E ATUALIZAÇÃO DO VALOR TOTAL
EXEC SP_REGISTRAR_ATENDIMENTO 
    @ID_CONSULTA = @NovoIDConsulta, 
    @ID_PROCEDIMENTO = @ID_PROC_EXEC; 
PRINT N'Etapa 2/4: Procedimento, Comissão e Custo do Material registrados com sucesso.';

-- C. CAIXA (3/4): PAGAMENTO DO CLIENTE
EXEC SP_REGISTRAR_PAGAMENTO 
    @ID_CONSULTA = @NovoIDConsulta, 
    @FORMA_PAGAMENTO = @FormaPgto;
PRINT N'Etapa 3/4: Pagamento do Cliente registrado via ' + @FormaPgto + N' com sucesso.';


-- D. RELATÓRIO FINAL (4/4): COMPROVAÇÃO DE COMISSIONAMENTO E MARGEM
SELECT 
    'FLUXO FINALIZADO' AS Status,
    C.ID_CONSULTA,
    @Nome_Profissional AS Profissional,
    PP.FORMA_PAGAMENTO AS Pagamento_Cliente,
    AP.VALOR_COBRADO AS Receita_Bruta,
    AP.VALOR_COMISSAO AS Comissao_Devida,
    (SELECT SUM(CUM.CUSTO_TOTAL_MATERIAL) FROM USO_MATERIAL CUM JOIN ATENDIMENTO_PROCEDIMENTO CAP ON CUM.ID_ATENDIMENTO_PROCEDIMENTO = CAP.ID_ATENDIMENTO_PROCEDIMENTO WHERE CAP.ID_CONSULTA = C.ID_CONSULTA) AS Custo_Material_Real,
    C.VALOR_TOTAL - AP.VALOR_COMISSAO - (SELECT SUM(CUM.CUSTO_TOTAL_MATERIAL) FROM USO_MATERIAL CUM JOIN ATENDIMENTO_PROCEDIMENTO CAP ON CUM.ID_ATENDIMENTO_PROCEDIMENTO = CAP.ID_ATENDIMENTO_PROCEDIMENTO WHERE CAP.ID_CONSULTA = C.ID_CONSULTA) AS Margem_Liquida
FROM 
    CONSULTA C
JOIN ATENDIMENTO_PROCEDIMENTO AP ON C.ID_CONSULTA = AP.ID_CONSULTA
JOIN PAGAMENTO_PACIENTE PP ON C.ID_CONSULTA = PP.ID_CONSULTA
WHERE 
    C.ID_CONSULTA = @NovoIDConsulta;

-- Verificação do Custo Real de Material
SELECT 
    'USO REAL DE MATERIAL (Detalhe)' AS Etapa,
    PE.NOME_PRODUTO,
    UM.QTD_REAL_CONSUMIDA,
    UM.CUSTO_TOTAL_MATERIAL
FROM USO_MATERIAL UM
JOIN ATENDIMENTO_PROCEDIMENTO AP ON UM.ID_ATENDIMENTO_PROCEDIMENTO = AP.ID_ATENDIMENTO_PROCEDIMENTO
JOIN PRODUTO_ESTOQUE PE ON UM.ID_PRODUTO = PE.ID_PRODUTO
WHERE AP.ID_CONSULTA = @NovoIDConsulta;
GO
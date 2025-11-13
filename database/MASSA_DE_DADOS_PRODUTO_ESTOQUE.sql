

--  POPULAÇÃO COM LOOP WHILE (500 Registros)
DECLARE @Contador INT = 1;
DECLARE @TotalRegistros INT = 500; -- Total de registros desejados
DECLARE @Random INT;
DECLARE @NomeBase VARCHAR(50);
DECLARE @TipoProduto VARCHAR(20);

WHILE @Contador <= @TotalRegistros
BEGIN
    -- Gera um número aleatório (para diversificação)
    SET @Random = CAST((RAND() * 10) + 1 AS INT);

    -- Determina o nome base do produto e o tipo
    IF @Random % 5 = 0
        SET @NomeBase = 'RESINA A';
    ELSE IF @Random % 5 = 1
        SET @NomeBase = 'AGULHA HIPODÉRMICA';
    ELSE IF @Random % 5 = 2
        SET @NomeBase = 'CIMENTO PROVISÓRIO';
    ELSE IF @Random % 5 = 3
        SET @NomeBase = 'LUVA DE LATEX';
    ELSE
        SET @NomeBase = 'FIO DE SUTURA';
        
    -- Determina um tipo de produto (ex: Cor, Espessura, Marca)
    IF @Contador % 3 = 0
        SET @TipoProduto = 'MARCA X';
    ELSE IF @Contador % 3 = 1
        SET @TipoProduto = 'COR B' + CAST((@Contador % 5) AS VARCHAR);
    ELSE
        SET @TipoProduto = 'TAMANHO P';

    -- INSERÇÃO DE DADOS
    INSERT INTO PRODUTO_ESTOQUE (NOME_PRODUTO, QTD_ESTOQUE, CUSTO_UNITARIO)
    VALUES (
        -- Nome único combinando base, tipo e um ID aleatório (para garantir UNIQUE)
        @NomeBase + ' ' + @TipoProduto + ' - ' + SUBSTRING(CAST(NEWID() AS VARCHAR(36)), 1, 4),
        
        -- QTD_ESTOQUE: Aleatório entre 10 e 500
        CAST((RAND() * 450) + 10 AS INT), 
        
        -- CUSTO_UNITARIO: Aleatório entre 5.00 e 150.00
        CAST((RAND() * 145.00) + 5.00 AS DECIMAL(10, 2))
    );

    SET @Contador = @Contador + 1;
END
GO

-- 4. VERIFICAÇÃO FINAL
SELECT 'STATUS: População da tabela PRODUTO_ESTOQUE concluída com sucesso. Total de Registros: ' + CAST(COUNT(*) AS VARCHAR)
FROM PRODUTO_ESTOQUE;
GO
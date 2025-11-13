DECLARE @Contador INT = 1;
DECLARE @TotalRegistros INT = 100;
DECLARE @Random INT;

WHILE @Contador <= @TotalRegistros
BEGIN
    SET @Random = CAST((RAND() * 1000) AS INT);
    
    INSERT INTO ENDERECO (LOGRADOURO, NUMERO, BAIRRO, CIDADE, CEP)
    VALUES (
        -- CAST NEWID() COMO VARCHAR(36) E DEPOIS USA SUBSTRING.
        'AVENIDA ' + SUBSTRING(CAST(NEWID() AS VARCHAR(36)), 1, 10),
        CAST((RAND() * 999) + 1 AS INT),
        CASE WHEN @Random % 3 = 0 THEN 'CENTRO' ELSE 'BAIRRO ' + CAST(@Random AS VARCHAR) END,
        CASE WHEN @Random % 2 = 0 THEN 'SAO PAULO' ELSE 'RIO DE JANEIRO' END,
        RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 99999999 AS VARCHAR), 8)
    );

    SET @Contador = @Contador + 1;
END
GO

-- VERIFICAÇÃO FINAL
SELECT 'STATUS: População da tabela ENDERECO concluída com sucesso. Total de Registros: ' + CAST(COUNT(*) AS VARCHAR)
FROM ENDERECO;
GO
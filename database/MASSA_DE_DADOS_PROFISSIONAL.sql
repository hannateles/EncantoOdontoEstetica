-- POPULAÇÃO DA TABELA PROFISSIONAL (10 REGISTROS)
DECLARE @Contador INT = 1;
DECLARE @TotalRegistros INT = 10; 
DECLARE @NomeProfissional VARCHAR(50);
DECLARE @SobrenomeProfissional VARCHAR(50);
DECLARE @ID_Endereco_Max INT = (SELECT MAX(ID_ENDERECO) FROM ENDERECO); 
DECLARE @ID_Endereco_Min INT = (SELECT MIN(ID_ENDERECO) FROM ENDERECO);  
DECLARE @RangeID INT = @ID_Endereco_Max - @ID_Endereco_Min + 1;

WHILE @Contador <= @TotalRegistros
BEGIN
    -- Lista de Nomes e Sobrenomes para construir o NOME
    SELECT @NomeProfissional = CASE (ABS(CHECKSUM(NEWID())) % 5) 
                                WHEN 0 THEN 'DR. ANDRÉ' WHEN 1 THEN 'DRA. CAMILA' WHEN 2 THEN 'DR. FABIO' WHEN 3 THEN 'DRA. LAURA' WHEN 4 THEN 'DRA. LUCELMA' ELSE 'DR. PEDRO' END;
    SELECT @SobrenomeProfissional = CASE (ABS(CHECKSUM(NEWID())) % 5) 
                                WHEN 0 THEN 'FERREIRA' WHEN 1 THEN 'RODRIGUES' WHEN 2 THEN 'GOMES' WHEN 3 THEN 'VIEIRA' WHEN 4 THEN 'COSTA' ELSE 'FREITAS' END;
    
    -- Cálculo do ID_ENDERECO aleatório e válido
    DECLARE @ID_Endereco_FK INT = CAST(RAND(CHECKSUM(NEWID())) * @RangeID AS INT) + @ID_Endereco_Min;

    INSERT INTO PROFISSIONAL (NOME, CRO, ID_ENDERECO, TELEFONE)
    VALUES (
        @NomeProfissional + ' ' + @SobrenomeProfissional,
        -- CRO: 20 dígitos aleatórios e únicos
        RIGHT('00000000000000000000' + CAST(ABS(CHECKSUM(NEWID())) % 99999999999999999999 AS VARCHAR), 20),
        @ID_Endereco_FK,
        -- Telefone
        '(' + CAST(ABS(CHECKSUM(NEWID())) % 90 + 10 AS VARCHAR) + ') 9' + RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 99999999 AS VARCHAR), 8)
    );

    SET @Contador = @Contador + 1;
END
GO

SELECT 'STATUS: População da tabela PROFISSIONAL concluída com sucesso. Total de Registros: ' + CAST(COUNT(*) AS VARCHAR)
FROM PROFISSIONAL;
GO
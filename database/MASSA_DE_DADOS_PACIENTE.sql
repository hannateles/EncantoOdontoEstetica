
--  POPULAÇÃO DA TABELA PACIENTE (500 REGISTROS)
DECLARE @Contador INT = 1;
DECLARE @TotalRegistros INT = 500;
DECLARE @NomeAleatorio VARCHAR(50);
DECLARE @SobrenomeAleatorio VARCHAR(50);
DECLARE @Historico VARCHAR(100);
DECLARE @ID_Endereco_Max INT = (SELECT MAX(ID_ENDERECO) FROM ENDERECO); -- Pega o maior ID_ENDERECO (500)
DECLARE @ID_Endereco_Min INT = (SELECT MIN(ID_ENDERECO) FROM ENDERECO);  -- Pega o menor ID_ENDERECO (1)
DECLARE @RangeID INT = @ID_Endereco_Max - @ID_Endereco_Min + 1;

WHILE @Contador <= @TotalRegistros
BEGIN
    -- Lista de Nomes e Sobrenomes para construir o NOME
    SELECT @NomeAleatorio = CASE (ABS(CHECKSUM(NEWID())) % 5) 
                                WHEN 0 THEN 'ANA' WHEN 1 THEN 'BRUNO' WHEN 2 THEN 'CARLA' WHEN 3 THEN 'DANIEL' ELSE 'ELISA' END;
    SELECT @SobrenomeAleatorio = CASE (ABS(CHECKSUM(NEWID())) % 5) 
                                WHEN 0 THEN 'SILVA' WHEN 1 THEN 'SANTOS' WHEN 2 THEN 'PEREIRA' WHEN 3 THEN 'OLIVEIRA' ELSE 'ALMEIDA' END;
    
    -- Histórico Médico
    SELECT @Historico = CASE (@Contador % 4)
                        WHEN 0 THEN 'NENHUMA ALERGIA CONHECIDA.'
                        WHEN 1 THEN 'PACIENTE COM BRUXISMO.'
                        WHEN 2 THEN 'ALÉRGICO A PENICILINA.'
                        ELSE 'HIPERTENSO CONTROLADO.' END;

    -- Cálculo do ID_ENDERECO aleatório e válido
    -- Garante que o ID de Endereço seja aleatório dentro do range válido (1 a 500)
    DECLARE @ID_Endereco_FK INT = CAST(RAND(CHECKSUM(NEWID())) * @RangeID AS INT) + @ID_Endereco_Min;

    INSERT INTO PACIENTE (NOME, CPF, ID_ENDERECO, TELEFONE, HISTORICO_MEDICO)
    VALUES (
        @NomeAleatorio + ' ' + @SobrenomeAleatorio,
        -- CPF: 11 dígitos aleatórios
        RIGHT('00000000000' + CAST(ABS(CHECKSUM(NEWID())) % 99999999999 AS VARCHAR), 11),
        @ID_Endereco_FK,
        -- Telefone: (XX) 9XXXX-XXXX
        '(' + CAST(ABS(CHECKSUM(NEWID())) % 90 + 10 AS VARCHAR) + ') 9' + RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 99999999 AS VARCHAR), 8),
        @Historico
    );

    SET @Contador = @Contador + 1;
END
GO

SELECT 'STATUS: População da tabela PACIENTE concluída com sucesso. Total de Registros: ' + CAST(COUNT(*) AS VARCHAR)
FROM PACIENTE;
GO
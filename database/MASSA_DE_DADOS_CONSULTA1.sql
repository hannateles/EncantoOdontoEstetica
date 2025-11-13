
--  POPULAÇÃO COM LOOP WHILE (1500 Registros)
DECLARE @Contador INT = 1;
DECLARE @TotalRegistros INT = 1500;
DECLARE @StatusConsulta VARCHAR(50);

-- Parâmetros FKs
DECLARE @ID_Paciente_Min INT = (SELECT MIN(ID_PACIENTE) FROM PACIENTE);
DECLARE @ID_Paciente_Max INT = (SELECT MAX(ID_PACIENTE) FROM PACIENTE);
DECLARE @RangePaciente INT = @ID_Paciente_Max - @ID_Paciente_Min + 1;

DECLARE @ID_Profissional_Min INT = (SELECT MIN(ID_PROFISSIONAL) FROM PROFISSIONAL);
DECLARE @ID_Profissional_Max INT = (SELECT MAX(ID_PROFISSIONAL) FROM PROFISSIONAL);
DECLARE @RangeProfissional INT = @ID_Profissional_Max - @ID_Profissional_Min + 1;


WHILE @Contador <= @TotalRegistros
BEGIN
    -- 1. Geração de IDs aleatórios (garantindo que sejam válidos)
    DECLARE @ID_Paciente_FK INT = CAST(RAND(CHECKSUM(NEWID())) * @RangePaciente AS INT) + @ID_Paciente_Min;
    DECLARE @ID_Profissional_FK INT = CAST(RAND(CHECKSUM(NEWID())) * @RangeProfissional AS INT) + @ID_Profissional_Min;
    
    -- 2. Geração da DATA_HORA (Aleatória nos últimos 30 dias)
    -- Gera dia aleatório nos últimos 30 dias
    DECLARE @DataAleatoria DATE = DATEADD(DAY, (RAND(CHECKSUM(NEWID())) * -30), GETDATE());
    -- Gera hora aleatória (entre 8h e 18h)
    DECLARE @HoraAleatoria TIME = DATEADD(HOUR, CAST((RAND(CHECKSUM(NEWID())) * 10) + 8 AS INT), 
                                     DATEADD(MINUTE, CAST(RAND(CHECKSUM(NEWID())) * 60 AS INT), 
                                     '00:00:00'));
    
    -- Combina Data e Hora
    DECLARE @DataHoraCompleta DATETIME = CAST(@DataAleatoria AS DATETIME) + CAST(@HoraAleatoria AS DATETIME);

    -- 3. Geração de STATUS
    SELECT @StatusConsulta = CASE (ABS(CHECKSUM(NEWID())) % 5) 
                             WHEN 0 THEN 'CANCELADA' -- 20% de chance
                             WHEN 1 THEN 'AGENDADA' -- 20% de chance
                             ELSE 'REALIZADA'       -- 60% de chance
                             END;

    -- INSERÇÃO DE DADOS
    INSERT INTO CONSULTA (ID_PACIENTE, ID_PROFISSIONAL, DATA_HORA, STATUS)
    VALUES (
        @ID_Paciente_FK,
        @ID_Profissional_FK,
        @DataHoraCompleta,
        @StatusConsulta
    );

    SET @Contador = @Contador + 1;
END
GO

-- 3. VERIFICAÇÃO FINAL
SELECT 'STATUS: População da tabela CONSULTA concluída com sucesso. Total de Registros: ' + CAST(COUNT(*) AS VARCHAR)
FROM CONSULTA;
GO
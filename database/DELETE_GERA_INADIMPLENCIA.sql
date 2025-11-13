USE ENCANTO_ODONTO;
GO

-- 1. IDENTIFICAR CONSULTAS PARA INADIMPLÊNCIA
-- Selecionamos 5 IDs de Consulta realizadas que já foram pagas para forçar a inadimplência.
DECLARE @ConsultasParaInadimplencia TABLE (ID_CONSULTA INT);

INSERT INTO @ConsultasParaInadimplencia (ID_CONSULTA)
SELECT TOP 50 
    C.ID_CONSULTA
FROM 
    CONSULTA C
JOIN 
    PAGAMENTO_PACIENTE PP ON C.ID_CONSULTA = PP.ID_CONSULTA
WHERE 
    C.STATUS = 'REALIZADA'
ORDER BY 
    C.DATA_HORA DESC; -- Seleciona as 5 mais recentes

-- 2. EXECUTAR A INADIMPLÊNCIA (Deletar os pagamentos)
-- Deleta os registros de pagamento associados às consultas selecionadas.
DELETE FROM PAGAMENTO_PACIENTE
WHERE ID_CONSULTA IN (SELECT ID_CONSULTA FROM @ConsultasParaInadimplencia);

GO

-- 3. VERIFICAÇÃO FINAL
SELECT 'STATUS: Inadimplência forçada para ' + 
       CAST(COUNT(*) AS VARCHAR) + ' consultas.' 
FROM CONSULTA C
LEFT JOIN PAGAMENTO_PACIENTE PP ON C.ID_CONSULTA = PP.ID_CONSULTA
WHERE C.STATUS = 'REALIZADA' AND PP.ID_PAGAMENTO IS NULL;

GO

-- Agora, rode a VIEW 5 novamente para ver a métrica de inadimplência aparecer:
SELECT * FROM RELATORIO_FLUXO_PAGAMENTO
ORDER BY Valor_Total_Pago DESC;
GO
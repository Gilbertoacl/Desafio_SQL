-- Consulta contendo a quantidade de tarefas de ressuprimentos solicitadas por dia.
SELECT 
    DATE(H.DATA_HORA) AS DATA_SOLICITACAO,
    COUNT(*) AS QUANTIDADE_TAREFAS
FROM HISTORICO H
JOIN TAREFA T ON H.ID_LOJA = T.ID_LOJA AND H.ID_TAREFA = T.ID_TAREFA
WHERE H.TIPO = 1  
AND T.TIPO = 1   
GROUP BY DATE(H.DATA_HORA)
ORDER BY DATA_SOLICITACAO;

-- Consulta contendo a quantidade de tarefas de ressuprimento por situação por dia.
SELECT 
    DATE(T.DATA_HORA) AS DATA_TAREFA,
    T.SITUACAO,
    COUNT(*) AS QUANTIDADE_TAREFAS
FROM TAREFA T
WHERE T.TIPO = 1 
GROUP BY DATE(T.DATA_HORA), T.SITUACAO
ORDER BY DATA_TAREFA, T.SITUACAO;

-- Consulta com a quantidade de tarefas por dia por usuário e a quantidade distinta de produtos ressuprimentos.
SELECT 
    DATE(T.DATA_HORA) AS DATA_TAREFA,
    T.ID_USUARIO,
    COUNT(T.ID_TAREFA) AS QUANTIDADE_TAREFAS,
    COUNT(DISTINCT R.ID_PRODUTO) AS PRODUTOS_DISTINTOS
FROM TAREFA T
JOIN RESSUPRIMENTO R ON T.ID_LOJA = R.ID_LOJA AND T.ID_TAREFA = R.ID_TAREFA
WHERE T.TIPO = 1 
GROUP BY DATE(T.DATA_HORA), T.ID_USUARIO
ORDER BY DATA_TAREFA, T.ID_USUARIO;

-- Consulta com todos os dados da primeira e da ultima tarefa executada, por tipo e por dia.
SELECT * FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY DATE(DATA_HORA), TIPO ORDER BY DATA_HORA ASC) AS PRIMEIRA,
        ROW_NUMBER() OVER (PARTITION BY DATE(DATA_HORA), TIPO ORDER BY DATA_HORA DESC) AS ULTIMA
    FROM TAREFA
) AS TAREFAS_ORDENADAS
WHERE PRIMEIRA = 1 OR ULTIMA = 1
ORDER BY DATA_HORA, TIPO;

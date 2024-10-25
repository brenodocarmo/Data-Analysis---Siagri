CREATE OR REPLACE VIEW vw_valor_agrupado_razao_social as 

WITH cte_parceiro_varejo AS (
    SELECT  
        v.cnpj_cpf,
        SUBSTR(v.cnpj_cpf, 1, 8) AS corte_cnpj_cpf,
        v.razao_social,
        v.valor_total        
    FROM vw_painel_cliente_varejo v
    --WHERE v.cnpj_cpf IN ('06268889000179', '06268889000330', '01318353000105', '32627353000374', '32627353000293', '29565704000193', '29565704000274', '07951727000101', '07951727000284')
),

cte_valor_agrupado AS (
    SELECT
    
        MAX(v.razao_social) KEEP (DENSE_RANK FIRST ORDER BY v.valor_total DESC) AS razao_social,
        SUM(v.valor_total) AS soma_valores
    FROM
        cte_parceiro_varejo v
    GROUP BY
        v.corte_cnpj_cpf
)

SELECT
    ROW_NUMBER() OVER (ORDER BY v.soma_valores DESC) AS posicao,
    v.*
FROM cte_valor_agrupado v
;

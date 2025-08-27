--Consulta com Like

select 
	*
from
	produtos pr
where pr.nome_produto like '%2x2%'

--Adicionando Explain

explain select * from produtos pr where pr.nome_produto like '%2x2%'

--Fazendo a consulta com index

create index idx_tagproduto
on produtos(nome_produto, preco)
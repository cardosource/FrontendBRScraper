# frontendBRScraper


Script para buscar vagas no repositório [**frontendbr/vagas**](https://github.com/frontendbr/vagas/issues)  da forma mais simples possível, sem necessidade de tokens ou autenticação.

## Recursos
- Busca vagas por nível de experiência (ex: "Pleno", "Sênior", "Júnior").

- Suporta variações de termos (ex: "PJ", "pj", "CLT").

- Exibe informações como título, labels, autor e descrição da vaga.

- Verifica o limite de requisições da API do GitHub para evitar bloqueios.

##  Limitações

- A API do GitHub tem um limite de 60 requisições por hora (sem autenticação).

- Se ultrapassar o limite, o script informa e pede para aguardar 1 hora.

## Buscando vagas

``./FrontendBRScraper.sh Pleno``

Pré-requisitos
- Bash (v4.0+)

- curl

- Ferramentas básicas: grep, sed, awk

saida:
```
Issue #1234:
Title: [Vaga] Back-end Pleno (PJ - Remoto)
Labels: Pleno,PJ,Remoto
Author: empresa-tech-fantasia
State: open
Body: Estamos em buscando de um desenvolvedor back-end pleno ...
::: ====================================================== :::

```


![BASH](https://img.shields.io/badge/GNU%20Bash-4EAA25.svg?style=for-the-badge&logo=GNU-Bash&logoColor=white)   ![GITHUB](https://img.shields.io/badge/GitHub-181717.svg?style=for-the-badge&logo=GitHub&logoColor=white)

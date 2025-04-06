#!/bin/bash
#  frontendBRScraper busca por vagas especificas no repostorio https://github.com/frontendbr/vagas/issues
#  modo de uso simples sem uso de token
#  define na função "vagasAbertas" nível de experiência ex: "Pleno" e variações
# a variação "Pleno","pleno", "pj" "PJ" é usada pois em alguns caso não mantem um padrão
# uso:
# ./frontendBRScraper.sh



API_URL="https://api.github.com/repos/frontendbr/vagas/issues"
LIMIT="https://api.github.com/rate_limit"

check_limit() {
    response=$(curl -s $LIMIT)
    rate_section=$(echo "$response" | sed -n '/"rate": {/,/}/p')
    rate_used=$(echo "$rate_section" | grep '"used"' | head -1 | cut -d':' -f2 | tr -d ' ,')
    echo "$rate_used"
}

vagasAbertas() {
    if [ "$#" -eq 0 ]; then
        echo "Busque pela vagas usando Pleno e variações"
        return 1
    fi
    used=$(check_limit)
    if [ "$used" -lt 60 ]; then
        echo "Executando, requisições usadas: $used"      
        curl -s "$API_URL" | grep -o "\"url\": \"$API_URL/[0-9]\+\"" | awk -F'"' '{print $4}' | while read -r issue_url; do
            issue_number=$(echo "$issue_url" | grep -o '[0-9]\+$')
            issue_data=$(curl -s "$issue_url")

            fetched_number=$(echo "$issue_data" | grep -o '"number": [0-9]\+' | awk '{print $2}')
            labels=$(echo "$issue_data" | grep -o '"name": "[^"]*"' | awk -F'"' '{print $4}')
            match_found=false
            for termo in "$@"; do
                if echo "$labels" | grep -iq "$termo"; then
                    match_found=true
                    break
                fi
            done

            if [ "$fetched_number" = "$issue_number" ] && [ "$match_found" = true ]; then
                title=$(echo "$issue_data" | grep -o '"title": "[^"]*"' | awk -F'"' '{print $4}')
                login=$(echo "$issue_data" | grep -o '"login": "[^"]*"' | awk -F'"' '{print $4}' | head -n 1)
                state=$(echo "$issue_data" | grep -o '"state": "[^"]*"' | awk -F'"' '{print $4}')
                body=$(echo "$issue_data" | grep -o '"body": ".*"' | sed 's/"body": "//; s/"$//')
                labels_formatado=$(echo "$labels" | tr '\n' ',' | sed 's/,$//')
                echo "Issue #$issue_number:"
                echo "Title: $title"
                echo "Labels: $labels_formatado"
                echo "Author: $login"
                echo "State: $state"
                echo "Body: $body"
                echo "::: ====================================================== :::"
            fi
        done
    else
        echo "[ attention ] ::: $used requisições usadas, aguarde 1 hora para o reset."
    fi
}

vagasAbertas "Pleno" "pj" "PJ"

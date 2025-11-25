#!/bin/bash

echo "========================"
echo " Monitoramento Simples "
echo "========================"

# MISSao 1 - verificar diretorio
echo
echo "digite o diretorio q quer verificar:"
read pastaUser

if [ -d "$pastaUser" ]
then
    echo "diretorio existe :)"
else
    echo "erro!! diretorio nao encontrado"
    exit 1
fi

# tentando ver permissoes, jeito simples
permis=$(ls -ld "$pastaUser" | awk '{print $1}')
echo "permissoes encontradas: $permis"

if [[ "$permis" != *r* || "$permis" != *w* || "$permis" != *x* ]]; then
   echo "aviso: pode faltar alguma permissao rwx ai"
else
   echo "td certo com permissoes"
fi

# MISSao 2 - disco
echo
echo "checando uso do disco (/) ..."

usoDisco=$(df / | grep / | awk '{print $5}' | tr -d '%')
echo "uso atual: $usoDisco%"

if [ $usoDisco -gt 90 ]; then
    echo "estado: CRITICO"
elif [ $usoDisco -gt 70 ]; then
    echo "estado: ALTAO cuidado ai"
else
    echo "estado: ok"
fi

# MISSao 3 - processos
echo
echo "processos do usuario: $USER"

qtd=$(ps -u $USER | wc -l)
echo "total de processos: $qtd"

echo
echo "top 5 processos q tao usando mais memoria:"
ps -u $USER -o pid,comm,%mem --sort=-%mem | head -n 6

echo
echo "fim do monitoramento :)"

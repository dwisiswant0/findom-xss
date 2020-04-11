#!/bin/bash

LINKFINDER="/home/dw1/Tools/LinkFinder/linkfinder.py"

echo -en "\033[0;35m"
echo "  ___ _      ___   ___  __  __   __  _____ ___ ";
echo " | __(_)_ _ |   \ / _ \|  \/  |__\ \/ / __/ __|";
echo " | _|| | ' \| |) | (_) | |\/| |___>  <\__ \__ \\";
echo " |_| |_|_||_|___/ \___/|_|  |_|  /_/\_\___/___/";
echo -en "\n dw1@noobsec.org\n --"
echo -en "\n Find for Possible DOM Based XSS Vulnerability"
echo -e "\033[0m\n"

_findomXSS() {
	PATTERN="(document|location|window)\.(URL|documentURI|href|search|hash|referrer|location\.href|name)"
	BODY=$(curl -sL ${1})
	SCAN=($(echo ${BODY} | grep -Eoin ${PATTERN}))
	if [[ ! -z "${SCAN}" ]]; then
		echo -en "---\n\033[0;32m[!] ${1}\033[0m\n${SCAN}\n"
		echo -e "---\n${1}\n${SCAN}" >> ${2}
	fi
}

_healthCheck() {
	curl ${1} -m 30 -sfo /dev/null || { echo -e "\033[0;31mThe ${2} host is unreachable!\033[0m" && exit; } && return
}

_validateTarget() {
	[[ "${1}" != "http"* ]] && { echo -e "\033[0;33mThe target must start with 'http'.\033[0m" && exit; }
}

_extractDomain() {
	echo ${1} | cut -d'/' -f3 | cut -d':' -f1
}

MAIN="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
RESULT="${MAIN}/results"
mkdir -p ${RESULT}
_validateTarget ${1}
DOMAIN=$(_extractDomain ${1})
[[ -z "${2}" ]] && OUTPUT="${RESULT}/${DOMAIN}.txt" || OUTPUT="${2}"
_healthCheck ${1} ${DOMAIN}
echo "[$(date +'%m/%d/%Y %R')] Scanning against ${1}"
_findomXSS ${1} ${OUTPUT} &
python3 ${LINKFINDER} -d -i ${1} -o cli | grep -Eoi "https?://[^\"\\'> ]+" | grep "${DOMAIN}" | grep "\.js" | uniq |
{
	while IFS="" read -r JS
	do
		_findomXSS ${JS} ${OUTPUT} &
	done

	wait

	[[ -f "${OUTPUT}" ]] && echo -e "\n\033[1mOutput saved into ${OUTPUT}\033[0m" || echo -e "\n\033[0;33mFound nothing. ¯\_(ツ)_/¯\033[0m"
}

#!/bin/bash

echo -en "\033[0;35m"
echo "  ___ _      ___   ___  __  __   __  _____ ___ ";
echo " | __(_)_ _ |   \ / _ \|  \/  |__\ \/ / __/ __|";
echo " | _|| | ' \| |) | (_) | |\/| |___>  <\__ \__ \\";
echo " |_| |_|_||_|___/ \___/|_|  |_|  /_/\_\___/___/";
echo -en "\n me@dw1.io\n --"
echo -en "\n Find for Possible DOM Based XSS Vulnerability"
echo -e "\033[0m"

_findomXSS() {
	PATTERN="(document|location|window)\.(URL|documentURI|search|hash|referrer|(location\.)?href|name)"
	BODY=$(curl -sL ${1})
	SCAN=($(echo ${BODY} | grep -Eoin ${PATTERN}))
	if [[ ! -z "${SCAN}" ]]; then
		echo -en "---\n\033[0;32m[!] ${1}\033[0m\n${SCAN}\n"
		echo -e "---\n${1}\n${SCAN}" >> ${2}
	fi
}

_healthCheck() {
	curl ${1} -m 10 -sfo /dev/null || echo "0" && echo "1"
	return
}

_validateTarget() {
	[[ "${1}" != "http"* ]] && echo "0" || echo "1"
	return
}

_extractDomain() {
	echo ${1} | cut -d'/' -f3 | cut -d':' -f1
}

_help() {
	echo -e "\n\033[0;31mPlease specify a target.\n\033[0m"
	echo -e "\033[0;33mUsage:\n  ${0} http://domain.tld/\n  cat urls.txt | ${0}\033[0m"
	exit
}

_main() {
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		MAIN="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		MAIN="$(dirname $(stat -f ${BASH_SOURCE[0]}))"
	fi
	RESULT="${MAIN}/results"
	DOMAIN=$(_extractDomain ${1})
	LINKFINDER="${MAIN}/LinkFinder/linkfinder.py"

	if [[ ! -f "${LINKFINDER}" ]]; then
		echo -en "\n\033[0;31mFile '${LINKFINDER}' doesn't exist!\033[0m"
		echo -e "\n\033[0;33mUpdating submodules...\033[0m"
		git submodule update > /dev/null
	fi

	[[ ! -d "${RESULT}" ]] && mkdir -p ${RESULT}
	[[ -z "${2}" ]] && OUTPUT="${RESULT}/${DOMAIN}.txt" || OUTPUT="${2}"
	
	if [[ `_validateTarget ${1}` -eq "0" ]]; then
		echo -e "\n\033[0;33mThe target must start with 'http'.\033[0m" && return;
	fi

	if [[ `_healthCheck ${1} ${DOMAIN}` -eq "0" ]]; then
		echo -e "\n\033[0;31mThe '${DOMAIN}' host is unreachable!\033[0m" && return;
	fi
	
	echo -e "\n[$(date +'%m/%d/%Y %R')] Scanning against ${1}"
	_findomXSS ${1} ${OUTPUT} &

	python3 ${LINKFINDER} -d -i ${1} -o cli | grep -Eoi "https?://[^\"\\'> ]+" | grep "${DOMAIN}" | grep "\.js" | uniq |
	{
		while IFS="" read -r JS
		do
			_findomXSS ${JS} ${OUTPUT} &
		done

		wait

		[[ -f "${OUTPUT}" ]] && echo -e "\n\033[1mOutput saved into ${OUTPUT}\033[0m\n-----" || echo -e "\n\033[0;33mFound nothing. ¯\_(ツ)_/¯\033[0m\n-----"
	}
}

if [[ $# == 0 ]]; then
	if [[ -p /dev/stdin ]]; then
		while IFS="" read line; do
			_main ${line}
		done
	else
		_help
	fi
else
	_main ${1} ${2}
fi

#!/bin/bash

ARGUMENT_TARGET="/home/mmccoo-deps"
ARGUMENT_BINARY="basic_test"

mkdir -p "${ARGUMENT_TARGET}"

cp --verbose --parents "${ARGUMENT_BINARY}" "${ARGUMENT_TARGET}"

ldd "${ARGUMENT_BINARY}" | cut -d '>' -f 2 | awk '{print $1}'

for library in $(ldd "${ARGUMENT_BINARY}" | cut -d '>' -f 2 | awk '{print $1}')
do
	[ -f "${library}" ] && cp --verbose --parents "${library}" "${ARGUMENT_TARGET}"
done
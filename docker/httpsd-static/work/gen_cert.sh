#!/bin/sh
set -e

if ! which openssl > /dev/null; then
  echo
  echo "ERROR: The openssl executable was not found. This script requires openssl."
  echo
  usage
fi

DOMAIN=localhost
COMPANY=SSL

# Create a temporary build dir and make sure we clean it up. For
# debugging, comment out the trap line.
BUILDDIR=`mktemp -d /tmp/ssl-XXXXXX`
trap "rm -rf $BUILDDIR" INT TERM EXIT

echo "Creating site cert"

mkdir -p /cert

OS=$(uname -s)
BASE="/cert/site"
CSR="${BASE}.csr"
KEY="${BASE}.key"
CRT="${BASE}.crt"
SITESSLCONF=${BUILDDIR}/site_selfsigned_openssl.cnf

cp /work/openssl.cnf ${SITESSLCONF}
(cat <<EOF
[ alt_names ]
DNS.1 = ${DOMAIN}
DNS.6 = www.${DOMAIN}
EOF
) >> $SITESSLCONF

# MinGW/MSYS issue: http://stackoverflow.com/questions/31506158/running-openssl-from-a-bash-script-on-windows-subject-does-not-start-with
if [[ "${OS}" == "MINGW32"* || "${OS}" == "MINGW64"* || "${OS}" == "MSYS"* ]]; then
  SUBJ="//C=US\ST=California\L=San Francisco\O=${COMPANY}\OU=${BASE}\CN=${DOMAIN}"
else
  SUBJ="/C=US/ST=California/L=San Francisco/O=${COMPANY}/OU=${BASE}/CN=${DOMAIN}"
fi

#cd $3
openssl genrsa -out $KEY 2048
openssl req -new -out $CSR -key $KEY -subj "${SUBJ}" -config $SITESSLCONF
openssl x509 -req -days 3650 -in $CSR -signkey $KEY -out $CRT -extensions v3_req -extfile $SITESSLCONF

#echo ">> exec docker CMD"
echo "$@"
#exec "$4"

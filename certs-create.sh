#!/bin/bash

pwd=$(pwd)
cd src/main/resources
rm -rf secrets
mkdir secrets
cd secrets


# Generate CA key
openssl req -new -x509 -keyout ca.key -out ca.crt -days 1000 -subj '/CN=neointegration.com/OU=TEST/O=NeoIntegration/L=London/ST=LN/C=GB' -passin pass:passw0rd -passout pass:passw0rd

    echo "------------------------------- $i -------------------------------"

    # Create host keystore
    keytool -genkey -noprompt \
                 -alias githubapp \
                 -dname "CN=githubapp.neointegration.com,OU=TEST,O=NeoIntegration,L=London,S=LN,C=GB" \
                 -ext "SAN=dns:githubapp.neointegration.com,dns:githubapp,dns:localhost" \
                 -keystore githubapp.keystore.jks \
                 -keyalg RSA \
                 -storepass passw0rd \
                 -keypass passw0rd \
                 -storetype pkcs12

    # Create the certificate signing request (CSR)
    keytool -keystore githubapp.keystore.jks -alias githubapp -certreq -file githubapp.csr -storepass passw0rd -keypass passw0rd -ext "SAN=dns:githubapp,dns:githubapp.neointegration.com,dns:localhost"
    #openssl req -in $i.csr -text -noout

    # Sign the host certificate with the certificate authority (CA)
    openssl x509 -req -CA ca.crt -CAkey ca.key -in githubapp.csr -out githubapp-ca-signed.crt -days 9999 -CAcreateserial -passin pass:passw0rd -extensions v3_req -extfile <(cat <<EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
CN = githubapp.neointegration.com
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS.1 = githubapp.neointegration.com
DNS.2 = localhost
DNS.3 = githubapp
EOF
)

  # Sign and import the CA cert into the keystore
  keytool -noprompt -keystore githubapp.keystore.jks -alias CARoot -import -file ca.crt -storepass passw0rd -keypass passw0rd


  # Sign and import the host certificate into the keystore
  keytool -noprompt -keystore githubapp.keystore.jks -alias githubapp -import -file githubapp-ca-signed.crt -storepass passw0rd -keypass passw0rd -ext "SAN=dns:githubapp.neointegration.com,dns:githubapp,dns:localhost"

  # Create truststore and import the CA cert
  keytool -noprompt -keystore githubapp.truststore.jks -alias CARoot -import -file ca.crt -storepass passw0rd -keypass passw0rd

cd $pwd

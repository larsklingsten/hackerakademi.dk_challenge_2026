#!/bin/bash

#make CA
##################################################################################
openssl asn1parse -genconf "key_in_text.txt" -out "key_ca.der"

openssl rsa -inform DER -in key_ca.der -out key_ca.pem

openssl req -x509 -new -key key_ca.pem -days 365 -sha256 -out ca.pem -config con_ca.cnf


#make server cert
##################################################################################
HOST="hostcontainer"
openssl genrsa -out server-key.pem 2048

openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr

echo subjectAltName = DNS:$HOST,IP:127.0.0.1,IP:172.17.0.1 >> extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf

openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey key_ca.pem \
  -CAcreateserial -out server-cert.pem -extfile extfile.cnf


#make client cert
##################################################################################
openssl genrsa -out key.pem 2048

openssl req -subj '/CN=client' -new -key key.pem -out client.csr

echo extendedKeyUsage = clientAuth > extfile-client.cnf

openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey key_ca.pem \
  -CAcreateserial -out cert.pem -extfile extfile-client.cnf

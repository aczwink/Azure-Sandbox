openssl req -x509 -newkey rsa:2048 \
  -keyout root.key \
  -out root.crt \
  -days 365 \
  -nodes \
  -config root.cnf


openssl x509 -outform der -in root.crt -out rootcert.cer

openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr
openssl x509 -req \
  -in client.csr \
  -CA root.crt \
  -CAkey root.key \
  -CAcreateserial \
  -out client.crt \
  -days 365 \
  -extfile client-ext.cnf
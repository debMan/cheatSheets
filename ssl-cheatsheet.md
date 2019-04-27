# SSL: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **SSL** command cheatsheet.

## Basics:

### Create self-signed certificate

``` bash
# create a new key
openssl genrsa  -out private.key 2048
# add -des3 or -aes256 to lock key with passphrase

# Generate a CSR from an Existing Private Key
openssl req -new -key privkey.pem -out signreq.csr

# To avoid the interactive prompt and fill out the information in the command, you can add this
openssl req -new -key privkey.pem -out signreq.csr \ 
    -subj "/C=US/ST=NRW/L=Earth/O=CompanyName/OU=IT/CN=www.example.com/emailAddress=email@example.com"

# Sign the certificate signing request
openssl x509 -req -days 365 -in signreq.csr -signkey privkey.pem -out certificate.pem

# Single command to generate a key and certificate
openssl req -new -sha256 -subj "/C=IR/CN=*.carrene.com" -key carrene.com.key -out carrene.com.csr
openssl req -newkey rsa:2048 -nodes -keyout privkey.pem -x509 -days 36500 -out certificate.pem
openssl req -newkey rsa:2048 -nodes -keyout privkey.pem -x509 -days 36500 -out certificate.pem \ 
    -subj "/C=US/ST=NRW/L=Earth/O=CompanyName/OU=IT/CN=www.example.com/emailAddress=email@example.com"

```

### More commands

``` bash
# debug mode
openssl s_client -connect host:443 -state -debug
# The -state flag is responsible for displaying the end of the previous section:

# connect with client certificate
openssl s_client -connect host:443 -cert cert_and_key.pem \
    -key cert_and_key.pem -state -debug
# you can add -cipher ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH   -tls1 flags

# fetch SSL chain of a server
openssl s_client -connect digikala.com:443 -showcerts

# Extract information from the CSR
openssl req -in carrene.com.csr -text -noout

# View old certificate subject, add -noout to skip certificate plain text
openssl x509 -in certificate.pem -text

# if yout got error unable to load certificate 
# 12626:error:0906D06C:PEM routines:PEM_read_bio:no start line:pem_lib.c:647:Expecting: 
# TRUSTED CERTIFICATE, then add -noout to skip certificate plain text
openssl x509 -in certificate.der -inform der -text

# conevrt PEM to DER
openssl x509 -in cert.crt -outform der -out cert.der

# conevrt DER to PEM
openssl x509 -in cert.crt -inform der -outform pem -out cert.pem

# Export the encrypted private key and certificates from .pfx, .p12, or etc. files.
openssl pkcs12 -in [yourfile.pfx] -out [keyfile-encrypted.key] -passin 'pass:1234' 

# extract the certificate from .pfx, .p12, or etc. files.
openssl pkcs12 -in [yourfile.pfx] -nokeys -out [certificate.crt] -passin 'pass:1234'

# extract the client certificate from .pfx, .p12, or etc. files.
openssl pkcs12 -in [yourfile.pfx] -nokeys -clcerts -out [certificate.crt] -passin 'pass:1234'

# extract the CA certificate from .pfx, .p12, or etc. files.
openssl pkcs12 -in [yourfile.pfx] -nokeys -cacerts -out [certificate.crt] -passin 'pass:1234'

# Export just the encrypted private key from .pfx, .p12, or etc. files.
openssl pkcs12 -in [yourfile.pfx] -out [keyfile-encrypted.key] -nocerts -passin 'pass:1234' 

# to extract unencrypted .key directly, add -nodes, means OpenSSL will not 
# encrypt the private key in a PKCS#12 file.

# get unencrypted RSA .key file from encrypted one.
openssl rsa -in [keyfile-encrypted.key] -out [keyfile-decrypted.key]

# convert your private key to PEM format
openssl rsa -in [keyfile-encrypted.key] -out [keyfile-encrypted-pem.key] -outform PEM

# Convert Certificate and Private Key to PKCS#12 format
openssl pkcs12 –export –out sslcert.pfx –inkey key.pem –in sslcert.pem
# you can also include chain certificate by passing –chain as below
openssl pkcs12 –export –out sslcert.pfx –inkey key.pem –in sslcert.pem -chain cacert.pem
```

Also to using a strong DH group for key-exchange:

``` bash
openssl dhparam -out dhparams.pem 2048
```

## More info:

A website to extract info from CSR: [click here](https://www.sslshopper.com/csr-decoder.html)  

Click [here](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs).  
[and here](https://www.sslshopper.com/article-most-common-openssl-commands.html)
And [here](https://support.rackspace.com/how-to/generate-a-csr/)
And [here](https://geekflare.com/openssl-commands-certificates/)

Also a good configs for webservers is [here](https://cipherli.st/).  
Also  [Guide to Deploying Diffie-Hellman for TLS](https://weakdh.org/sysadmin.html). 
To test SSLs use [SSL Labs](https://www.ssllabs.com/).



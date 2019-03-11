# SSL: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **SSL** command cheatsheet.

## Basics:

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

# Create a new CSR
openssl req -new -sha256 -subj "/C=IR/CN=*.carrene.com" -key carrene.com.key -out carrene.com.csr

# Generate a CSR from an Existing Private Key
openssl req -key carrene.com.key -new -out carrene.com.csr

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
## More info:

A website to extract info from CSR: [click here](https://www.sslshopper.com/csr-decoder.html)  

Click [here](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs).  
[and here](https://www.sslshopper.com/article-most-common-openssl-commands.html)
And [here](https://support.rackspace.com/how-to/generate-a-csr/)
And [here](https://geekflare.com/openssl-commands-certificates/)

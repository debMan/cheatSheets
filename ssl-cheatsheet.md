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

# Generate a CSR from an Existing Private Key
openssl req -key carrene.com.key -new -out carrene.com.csr

# View old certificate subject
openssl x509 -noout -subject -in old.cert

# Create CSR
openssl req -new -sha256 -subj "/C=IR/CN=*.carrene.com" -key carrene.com.key -out carrene.com.csr

# Extract information from the CSR
openssl req -in carrene.com.csr -text -noout
```
## More info:

A website to extract info from CSR: [click here](https://www.sslshopper.com/csr-decoder.html)  

Click [here](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs).  
And [here](https://support.rackspace.com/how-to/generate-a-csr/)

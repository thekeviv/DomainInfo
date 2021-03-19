# DomainInfo

The script takes as input a domain name/IP Address/Email and prints info about the domain name. The info is collected by using 
whois, dig and host UNIX commands and it then uses awk and sed to format the input. Since it uses the mentioned UNIX commands,
the script will not work on Windows unless you use WSL.

## Sample 
```shell

./domaininfo.sh cnn.com
domaininfo - Querying domain info for domain: cnn.com

Domain Name:              | CNN.COM
IP Address:               | 151.101.129.67
Created On:               | 1993-09-22T04:00:00Z
Last Updated On:          | 2018-04-10T16:43:38Z
Registrant Name:          | Domain Name Manager
Registrant Organization:  | Turner Broadcasting System, Inc.
Registrant Country:       | US
Registrar Name:           | CSC Corporate Domains, Inc.
Registrar URL:            | http://cscdbs.com
Registrar WHOIS Server:   | whois.corporatedomains.com
Admin Name:               | Domain Name Manager
Admin Organization:       | Turner Broadcasting System, Inc.
Admin Email:              | tmgroup@turner.com
Tech Name:                | Turner Broadcasting System, Inc.
Tech Email:               | hostmaster@turner.com
Abuse Contact Email:      | domainabuse@cscglobal.com
Abuse Contact Phone:      | 8887802723
DNS Server Address:       | NS-1086.AWSDNS-07.ORG

The following A Records for the domain/IP Address were found:

151.101.129.67
151.101.65.67
151.101.1.67
151.101.193.67


The following TXT Records for the domain/IP Address were found:

126953328-4422040
133461244-4422058
178953534-4422001
186844776-4422028
228426766-4422034
267933795-4422004
287893558-4422013
294913881-4422049
299762315-4422055
2baPGrmeo+RwsWdIdq/gIVSEWNb4tC9mLGQu0j4l/mduqhm06T+V9vNLXsauLyH9FwMZJSRHvj/YHGKOVWRylw==
321159687-4422031
349997471-4422043
353665828-4422052
528183251-4422019
553992719-4400647
598362927-4422061
667921863-4422007
688162515-4422037
691244352-4422022
714321471-4421998
754516718-4422064
755973593-4422016
764482256-4422025
782989862-4417942
826218936-4422046
882269757-4422010
MS=ms66433104
_globalsign-domain-verification=-lBuNJDFRxDkLkNbYOLBU03PlWjnPqAzBPAVUokhAw
_globalsign-domain-verification=2lybn8Z2GKCTHNehPEREKdz_jh5SahShpwOeRqCWjl
_globalsign-domain-verification=5ckEJ4VIhQ6weCdCfmfzQPVP6ED1LtCX9jw1OKX5Mv
_globalsign-domain-verification=B57sRQpmte4G4w-gavZbVNmmNsMxGp5kcL19UP2599
_globalsign-domain-verification=MK_ZKmss4D_DdzGOsssHxxBOK6hJc6LGycFvNOESdZ
_globalsign-domain-verification=S6DssfjyL_2kgK4I2Ae_1cdPfwqRRBfB9-3ZhRGMRj
_globalsign-domain-verification=yTw3T3KnyIyTB1xG2GvVhl1zWJlFp-WqmNskdVI_65
adobe-idp-site-verification=279ead95-3581-42b7-82f4-73c97f8cebfa
adobe-sign-verification=c3dc3217f76deddcb413a23e4e665fad
cisco-ci-domain-verification=4a1c92ef69fe42f8125c3ca9ce0696dcf6cc16fa80243257de578af593d19548
d1xTs9+kADZZSz3bPphLpkMXXxBGjqn5vsQHhi2M6lo0r8AdIbm6j8LfQXPujsywVgeGSP+AXWX0vO9Iep5cUg==
facebook-domain-verification=xszi21kow2trmw3xt3ph6s631zyu3i
globalsign-domain-verification=-Q7umwx2mj164XwLa0PsoUaWe2HBhta50GjggsT98f
globalsign-domain-verification=2lI5pahhCu_jg_2RC5GEdolQmAa4K7rhP7_OA-lZBK
google-site-verification=R-Btow3Z8oU_9H1IWU4Gm4lvUQ_OVmsfxonIKhIaiPE
google-site-verification=_QivaXNjhXy-V1y_YqrycXdAWZi2mVrcwbXerX6THeY
ms=ms97284866
v=spf1


The following MX Records for the domain/IP Address were found:

mxb-00241e02.gslb.pphosted.com.
mxa-00241e02.gslb.pphosted.com.
```

The script was written for the lab assignment of SENG460 course at the University of Victoria taken in Spring 2021.

## Future TODO

1. Improve regex logic for parsing domain from url (will fail if the URL has query params or a path in it or the URL has subdomains in it.

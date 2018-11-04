# Bind9 Nameserver
You will need:
* two machines with static IP addresses.
* one domain for your dns servers
* one domain for your aplication

## Install Bind9 on both machines
```
apt-get install bind9
```

## Primary server:
`/etc/bind/named.conf.local`
```
zone "APPDOMAIN.TLD" {
    type master;
    file "/etc/bind/APPDOMAIN.TLD.db";
};
```

`/etc/bind/APPDOMAIN.TLD.db`
```
; Zone file for APPDOMAIN.TLD
APPDOMAIN.TLD. 1D IN SOA ns1.DNSDOMAIN.TLD. EMAIL.DOMAIN.TLD. (
        200608085 ; serial number
        8H ; refresh
        2H ; retry
        4W ; expire
        1D ; minimum
)
@ 86400  IN  NS ns1.DNSDOMAIN.TLD.
@ 86400  IN  NS ns2.DNSDOMAIN.TLD.
@ 600 IN A IPADDRESS
* 600 IN A IPADDRESS
```

`/etc/bind/named.conf.options`
```
options {
        directory "/var/cache/bind";

        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

        // If your ISP provided one or more IP addresses for stable
        // nameservers, you probably want to use them as forwarders.
        // Uncomment the following block, and insert the addresses replacing
        // the all-0's placeholder.

        forwarders {
                8.8.8.8;
                8.8.4.4;
        };

        //========================================================================
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //========================================================================
        dnssec-validation auto;

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };

        notify yes;
        also-notify { IPSECONDARY;  };
        allow-transfer { IPSECONDARY; };
};
```


## Secondary server:
`/etc/bind/named.conf.local`
```
zone "APPDOMAIN.TLD" {
        type slave;
        file "/var/lib/bind/db.APPDOMAIN.TLD";
        masters { PRIMARY-SERVER-IP; };
};
```

`/etc/bind/named.conf.options`
```
options {
        directory "/var/cache/bind";

        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

        // If your ISP provided one or more IP addresses for stable
        // nameservers, you probably want to use them as forwarders.
        // Uncomment the following block, and insert the addresses replacing
        // the all-0's placeholder.

        // forwarders {
        //      0.0.0.0;
        // };

        //========================================================================
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //========================================================================
        dnssec-validation auto;

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
```

## Restart Bind9
```
sudo /etc/init.d/bind9 restart
```

## APPDOMAIN.TLD
Set NS for APPDOMAIN.TLD to ns1.DNSDOMAIN.TLD and ns2.DNSDOMAIN.TLD

## DNSDOMAIN.TLD
Create two A records.
ns1.DNSDOMAIN.TLD -> IPPRIMARY
ns2.DNSDOMAIN.TLD -> IPSECONDARY
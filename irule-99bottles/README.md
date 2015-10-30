irule-99bottles
===============

99 Bottles of Beer in iRules.

1. Add iRule irule.99bottles to your BIG-IP
2. Create virtual service with iRule associated
3. ???
4. profit

```
  tmsh create / ltm virtual vip.99bottles.10000 { \
     destination x.x.x.x:10000 ip-protocol tcp \
     mask 255.255.255.255 rules { irule.99bottles } \
     profiles add { tcp {} http {} } }

```

cURL to see the result.

```
  curl -x '' -s0 http://x.x.x.x:10000/
```

.

# MsgPack

Perl 6 Interface to libmsgpack

This module is totally **experimental** at the moment. You have been warned.

```Perl6
use v6;
use MsgPack;

my $data   = [1, True, "Example"];
my $packed = MsgPack::pack($data);

say $data.perl;
say $packed.perl;
```

More documentation will come soon... it is currently being unpacked :)

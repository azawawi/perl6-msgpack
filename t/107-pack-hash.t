use v6;

use Test;
use MsgPack;

plan 3;

ok MsgPack::pack({ key => 'value' }) ~~ Blob.new(129,163,107,101,121,165,118,97,108,117,101), "hash packed correctly 1";

ok MsgPack::unpack(MsgPack::pack( { a => Any, b => [ 1.1 ], c => { aa => 3, bb => [] } } )) == { a => Any, b => [ 1.1 ], c => { aa => 3, bb => [] } }, "hash packed correctly 2"; #

my %hh;
for ^16 -> $i {
    %hh{$i} = $i
};

ok MsgPack::unpack(MsgPack::pack(%hh)) == %hh,"hash packed correctly 3";

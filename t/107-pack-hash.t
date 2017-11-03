use v6;

use Test;
use MsgPack;

plan 3;

ok MsgPack::pack( { key => 'value' } ) ~~ Blob.new(129,163,107,101,121,165,118,97,108,117,101), "hash packed correctly";

ok MsgPack::pack( { a => Any, b => [ 1.1 ], c => { aa => 3, bb => [] } } ) ~~ Blob.new(131,161,97,192,161,99,130,162,98,98,144,162,97,97,3,161,98,145,203,63,241,153,153,153,153,153,154), "hash packed correctly";

my %hh;
for ^16 -> $i {
    %hh{$i} = $i
};
ok MsgPack::pack( %hh ) ~~ Blob.new(222,0,16,161,56,8,162,49,49,11,161,53,5,161,49,1,162,49,53,15,162,49,52,14,162,49,51,13,162,49,50,12,161,54,6,161,52,4,161,48,0,161,57,9,162,49,48,10,161,55,7,161,51,3,161,50,2),"hash packed correctly";
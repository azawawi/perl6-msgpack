use v6;

use Test;
use MsgPack;

plan 3;

unless ?%*ENV<EXPERIMENTAL> {
    skip-rest "Skipping experimental tests";
    exit;
}

my $array;

$array = MsgPack::unpack( Blob.new( 0x90 ) );
ok $array ~~ [], "Array unpacked correctly";;

$array = MsgPack::unpack( Blob.new( 0xdc, 0x00, 0x10, (0xcc, 0xfa) xx 16 ) );
ok $array ~~ [ 250 xx 16 ], "Array unpacked correctly";

$array = MsgPack::unpack( Blob.new(148,160,161,97,162,98,99,163,100,101,102) );
ok $array ~~ ["", "a", "bc", "def"], "Array unpacked correctly";

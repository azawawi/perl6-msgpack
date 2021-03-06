
use v6;

unit class MsgPack::Packer;

use NativeCall;
use MsgPack::Native;

has msgpack_packer  $.pk   is rw;

method pack( $data ) returns Blob
{
    # Create simple buffer and packer C structures
    my $sbuf = msgpack_sbuffer.new;
    $.pk     = msgpack_packer.new;

    # Initialize simple buffer and packer C structures
    msgpack_sbuffer_init($sbuf);
    msgpack_packer_init($.pk, $sbuf);

    # Start packing our data filling the simple buffer
    self._pack($data);

    # Create a binary blob out from a slice of the simple buffer
    my $result = Blob.new( $sbuf.data[ ^$sbuf.size ] );

    # Cleanup
    msgpack_sbuffer_destroy($sbuf);

    return $result;
}

multi method _pack(List:D $list) {
    msgpack_pack_array($.pk, $list.elems);
    self._pack( $_ ) for @$list;
}

multi method _pack(Hash:D $hash) {
    msgpack_pack_map($.pk, $hash.elems);
    self._pack( $_ ) for $hash.kv;
}

multi method _pack(Any:U $thing) {
    msgpack_pack_nil($.pk);
}

multi method _pack(Numeric:D $f) {
    if $f.Int == $f {
        return self._pack( $f.Int );
    }
    #TODO when to use msgpack_pack_float?
    msgpack_pack_double($.pk, $f.Num);
}

multi method _pack(Blob:D $blob) {
    my $len    = $blob.elems;
    my $carray = CArray[uint8].new($blob);
    msgpack_pack_bin($.pk, $len);
    msgpack_pack_bin_body($.pk, $carray, $len);
}

multi method _pack(Bool:D $bool) {
    if $bool {
        msgpack_pack_true($.pk);
    } else {
        msgpack_pack_false($.pk);
    }
}

multi method _pack(Int:D $integer) {
    msgpack_pack_int($.pk, $integer);
}

multi method _pack(Str:D $string) {
    my $len = $string.chars;
    msgpack_pack_str($.pk, $len);
    msgpack_pack_str_body($.pk, $string, $len);
}

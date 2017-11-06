
use v6;

unit class MsgPack::Unpacker;

use NativeCall;
use MsgPack::Native;

constant UNPACKED_BUFFER_SIZE = 2048;

method unpack(Blob $packed) {
    # Copy our Blob bytes to simple buffer
    my $sbuf = msgpack_sbuffer.new;
    my $data = CArray[uint8].new($packed);
    msgpack_sbuffer_init($sbuf);
    msgpack_sbuffer_write($sbuf, $data, $data.elems);

    # Initialize unpacker
    my $result          = msgpack_unpacked.new;
    my $unpacked_buffer = CArray[uint8].new([0 xx UNPACKED_BUFFER_SIZE]);
    msgpack_unpacked_init($result);

    # Start unpacking
    my size_t $off     = 0;
    my ($buffer, $len) = ($sbuf.data, $sbuf.size);
    my $ret            = msgpack_unpack_next($result, $buffer, $len, $off);
    my $unpacked;
    while $ret == MSGPACK_UNPACK_SUCCESS.value {
        my msgpack_object $obj = $result.data;

        #TODO remove debuggy say :)
        say "Object type #" ~ $obj.type;
        $unpacked = self.unpack-object($obj);

        $ret = msgpack_unpack_next($result, $buffer, $len, $off);
    }

    # Cleanup
    msgpack_sbuffer_destroy($sbuf);
    msgpack_unpacked_destroy($result);

    #TODO throw a proper typed exception
    die "The data in the buf is invalid format with ret = $ret"
        if $ret != MSGPACK_UNPACK_CONTINUE;

    return $unpacked;
}

method unpack-object(msgpack_object $obj) {
    given $obj.type {
        when MSGPACK_OBJECT_NIL              { return Any; }
        when MSGPACK_OBJECT_BOOLEAN          { return Int($obj.via.boolean); }
        when MSGPACK_OBJECT_POSITIVE_INTEGER { return Int($obj.via.u64); }
        when MSGPACK_OBJECT_NEGATIVE_INTEGER { return Int($obj.via.i64); }
        when MSGPACK_OBJECT_FLOAT32          { return Int($obj.via.f64); }
        when MSGPACK_OBJECT_FLOAT64          { return Int($obj.via.f64); }
        when MSGPACK_OBJECT_STR              { return "TODO Str"; }
        when MSGPACK_OBJECT_ARRAY {
            my $array = $obj.via.array;
            my $o = nativecast(Pointer[msgpack_object], $array.ptr);
            return [ self.unpack-object($o.deref[0]) ];
        }
        when MSGPACK_OBJECT_MAP              { say "Hash" }
        when MSGPACK_OBJECT_BIN              { say "Bin" }
        when MSGPACK_OBJECT_EXT              { say "Extension" }
        default {
            say "Unknown object type: " ~ $obj.type;
        }
    }
}

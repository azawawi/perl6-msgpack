
use v6;

unit class MsgPack::Unpacker;

use NativeCall;
use MsgPack::Native;

constant UNPACKED_BUFFER_SIZE = 2048;

method unpack(Blob $packed) {
    warn "unpack(Blob) is currently experimental....";

    my $sbuf = msgpack_sbuffer.new;
    msgpack_sbuffer_init($sbuf);
    my $data = CArray[uint8].new($packed);
    say $data.map( { $_ +& 0xff } ).list;

    msgpack_sbuffer_write($sbuf, $data, $data.elems);
    my msgpack_unpacked $result = msgpack_unpacked.new;
    my $unpacked_buffer         = CArray[uint8].new(UNPACKED_BUFFER_SIZE);
    my size_t $off              = 0;
    msgpack_unpacked_init($result);
    my $ret = msgpack_unpack_next($result, $sbuf.data, $sbuf.size, $off);
    while $ret == MSGPACK_UNPACK_SUCCESS.value {
        my msgpack_object $obj = $result.data;

        given $obj.type {
            when MSGPACK_OBJECT_NIL     { say "Any"   }
            when MSGPACK_OBJECT_ARRAY   { say "Array" } 
            when MSGPACK_OBJECT_POSITIVE_INTEGER { say "+ive Int" }
            when MSGPACK_OBJECT_NEGATIVE_INTEGER { say "-ive Int" }
            when MSGPACK_OBJECT_MAP     { say "Hash" } 
            when MSGPACK_OBJECT_STR     { say "Str" } 
            when MSGPACK_OBJECT_BOOLEAN { say "Bool" } 
            default { say "Unknown object type: " ~ $obj.type; }
        }

        #TODO reconstruct the Perl 6 object
        $ret = msgpack_unpack_next($result, $sbuf.data, $sbuf.size, $off);
    }

    # Cleanup
    msgpack_sbuffer_destroy($sbuf);
    msgpack_unpacked_destroy($result);
    
    if $ret == MSGPACK_UNPACK_CONTINUE {
        #TODO this should be our success criteria to return the result object
        say "All msgpack_object(s) in the buffer are consumed.";
    } elsif $ret == MSGPACK_UNPACK_PARSE_ERROR {
         #TODO exception
         die "The data in the buf is invalid format.";
    } else {
        say "Return type is $ret";
    }
}

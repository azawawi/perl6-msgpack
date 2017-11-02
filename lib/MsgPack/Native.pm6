
use v6;

unit module MsgPack::Native;

use NativeCall;
use LibraryCheck;

# ....
sub library {
    my $lib-name = sprintf($*VM.config<dll>, "msgpack-perl6");
    return ~(%?RESOURCES{$lib-name});    
}

# ....
sub libmsgpack {
    constant LIB = 'msgpackc';

	# Linux/Unix
	if library-exists(LIB, v2) {
		return sprintf('lib%s.so.2', LIB);
	} else {
		return sprintf('lib%s.so', LIB);
	}
}

class msgpack_sbuffer is repr('CStruct') is export {
    has size_t        $.size;
    has CArray[uint8] $.data;
    has size_t        $.alloc;
}

class msgpack_packer is repr('CStruct') is export {
	has Pointer $.data;
	has Pointer $.callback;
}

sub msgpack_sbuffer_init(msgpack_sbuffer $sbuf is rw)
    is native(&library)
    is symbol('wrapped_msgpack_sbuffer_init')
    is export
    { * }

sub msgpack_sbuffer_destroy(msgpack_sbuffer $sbuf is rw)
    is native(&library)
    is symbol('wrapped_msgpack_sbuffer_destroy')
    is export
    { * }

sub msgpack_packer_init(msgpack_packer $pk is rw, msgpack_sbuffer $sbuf is rw)
	is native(&library)
    is symbol('wrapped_msgpack_packer_init')
    is export
    { * }

sub msgpack_pack_true(msgpack_packer $pk is rw)
    is native(&library)
    is symbol('wrapped_msgpack_pack_true')
    is export
    { * }

sub msgpack_pack_false(msgpack_packer $pk is rw)
    is native(&library)
    is symbol('wrapped_msgpack_pack_false')
    is export
    { * }

sub msgpack_pack_array(msgpack_packer $pk is rw, size_t $n)
    is native(&library)
    is symbol('wrapped_msgpack_pack_array')
    is export
    { * }

sub msgpack_pack_int(msgpack_packer $pk is rw, int32 $d)
    is native(&library)
    is symbol('wrapped_msgpack_pack_int')
    is export
    { * }

sub msgpack_pack_str(msgpack_packer $pk is rw, size_t $l)
    is native(&library)
    is symbol('wrapped_msgpack_pack_str')
    is export
    { * }

sub msgpack_pack_str_body(msgpack_packer $pk is rw, Str $b, size_t $l)
    is native(&library)
    is symbol('wrapped_msgpack_pack_str_body')
    is export
    { * }
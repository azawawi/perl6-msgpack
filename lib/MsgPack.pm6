
use v6;

unit module MsgPack;

use NativeCall;
use MsgPack::Native;
use MsgPack::Packer;

our sub pack( $data ) returns Blob
{
    return Packer.new.pack($data);
}

our sub unpack( Blob $blob ) {
    ...
}

our sub version returns Hash {
    return %(
        major    => msgpack_version_major,
        minor    => msgpack_version_minor,
        string   => msgpack_version);
}

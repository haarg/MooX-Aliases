use strictures 1;
use Test::More;
use Test::Fatal;

{
  package Foo;
  use Moo;
  use MooX::Aliases;
  use namespace::clean;
  has attr1 => ( is => 'ro', required =>1, alias => 'attr1_alias' );
}

is exception { Foo->new( attr1_alias => 1 ); }, undef,
  'aliases work when using namespace::clean';

done_testing;

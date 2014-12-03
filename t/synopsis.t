use strictures 1;
use Test::More;

package MyApp;
use Moo;
use MooX::Aliases;

has this => (
    is    => 'rw',
    alias => 'that',
);

sub foo { my $self = shift; print $self->that }
alias bar => 'foo';

my $o = MyApp->new();
$o->this('Hello World');


package MyApp::Role;
use Moo::Role;
use MooX::Aliases;

has this => (
    is    => 'rw',
    alias => 'that',
);

sub foo { my $self = shift; print $self->that }
alias bar => 'foo';

package MyApp::Role::Test;
use Moo;
with 'MyApp::Role';

my $o2 = MyApp::Role::Test->new();
$o2->this('Hello World');

package main;
{
  local *STDOUT;
  open STDOUT, '>', \(my $out = '');
  $o->bar;
  is $out, "Hello World", "correct output";
}
{
  local *STDOUT;
  open STDOUT, '>', \(my $out = '');
  $o2->bar;
  is $out, "Hello World", "correct output";
}

done_testing;

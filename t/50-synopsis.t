use strictures 1;
use Test::More;
BEGIN {
    eval "use Test::Output;";
    plan skip_all => "Test::Output is required for this test" if $@;
}

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
stdout_is { $o->bar } "Hello World", "correct output";
stdout_is { $o2->bar } "Hello World", "correct output";

done_testing;

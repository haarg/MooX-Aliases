use strictures 1;
use Test::More;

my ($foo_called, $baz_called);

{
    package MyTest;
    use Moo;
    use MooX::Aliases;

    has foo => (
        is      => 'rw',
        alias   => 'bar',
        trigger => sub { $foo_called++ },
    );

    has baz => (
        is      => 'rw',
        alias   => [qw/quux quuux/],
        trigger => sub { $baz_called++ },
    );

    has wark => (
        is      => 'rw',
    );
}

($foo_called, $baz_called) = (0, 0);
my $t = MyTest->new;
$t->foo(1);
$t->bar(1);
$t->baz(1);
$t->quux(1);
$t->quuux(1);
$t->wark(1);
is($foo_called, 2, 'all aliased methods were called from foo');
is($baz_called, 3, 'all aliased methods were called from baz');

done_testing;

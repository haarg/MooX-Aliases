use strictures 1;
use Test::More;

my ($foo_called, $baz_called, $override_called);

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

    package MyTest::Sub;
    use Moo;
    use MooX::Aliases;

    extends qw(MyTest);
    has '+foo' => (
        is      => 'rw',
        alias   => 'override',
        trigger => sub { $override_called++ },
    );
}

($foo_called, $baz_called, $override_called) = (0, 0, 0);
my $t = MyTest->new;
$t->foo(1);
$t->bar(1);
$t->baz(1);
$t->quux(1);
$t->quuux(1);
$t->wark(1);
is($foo_called, 2, 'all aliased methods were called from foo');
is($baz_called, 3, 'all aliased methods were called from baz');

my $t2 = MyTest::Sub->new;
$t2->override(1);
is($override_called, 1, 'all subclassed aliases were called from override');

done_testing;

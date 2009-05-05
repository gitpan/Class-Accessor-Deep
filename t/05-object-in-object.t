package Foo;

use base 'Class::Accessor::Deep';

sub new {
    bless {
        a => 'c',
    }, 'Foo'
}

1;

package Bar;

use base 'Class::Accessor::Deep';

sub new {
    bless {
        d => 'e',
        f => Foo->new,
    }, 'Bar'
}

1;

package main;

use Test::More tests => 3;

my $foo = Foo->new;
my $bar = Bar->new;

is $foo->get_a, 'c', 'accessor';
is ref($bar->get_f), 'Foo', 'accessor';
is $bar->get_a, undef, 'objects inside objects are not handled'
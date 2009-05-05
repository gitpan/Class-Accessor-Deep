package Foo;

use base 'Class::Accessor::Deep';

sub new {
    bless {
        a => 'b',
        c => [qw(d e)],
        f => {
            g => 'h',
            i => [qw(j k)],
            l => {
                m => 'n',
                o => [qw(p q)],
                r => {},
            },
        },
        _s  => '_t',
        __u => '__v',
    }, 'Foo'
}

1;

package main;

use Test::More tests => 3;

my $foo = Foo->new;

foreach(qw(x y z)) {
    my $accessor = "get_$_";
    #diag "method: $accessor; field: $_";
    is $foo->$accessor, undef, 'accessor for non-existent field'
}
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

use Test::More tests => 10;

my $expected = {
    a => 'a',
    c => 'c',
    f => {
        g => 'g',
        i => 'i',
        l => {
            m => 'm',
            o => 'o',
            r => 'r',
        },
    },
    _s  => '_s',
    __u => '__u',
};
my $foo = Foo->new;

foreach(qw(c a _s __u)) {
    $foo->$_($_);
    #diag "method: $_; field: $_";
    is $foo->$_, $expected->{$_}, "accessor/mutator"
}

foreach(qw(g i)) {
    $foo->$_($_);
    #diag "method: $_; field: $_";
    is $foo->$_, $expected->{f}->{$_}, "accessor/mutator"
}

foreach(qw(o r m)) {
    $foo->$_($_);
    #diag "method: $_; field: $_";
    is $foo->$_, $expected->{f}->{l}->{$_}, "accessor/mutator"
}

is_deeply $foo, $expected, 'object structure has not been changed'
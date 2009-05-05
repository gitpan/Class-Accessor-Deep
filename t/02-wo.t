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
    _s => '_s',
    __u => '__u',
};
my $foo = Foo->new;

foreach(qw(c a _s __u)) {
    my($mutator, $accessor) = ("set_$_", "get_$_");
    #diag "method: $mutator; field: $_";
    $foo->$mutator($_);
    is_deeply $foo->$accessor, $expected->{$_}, "mutator"
}

foreach(qw(g i)) {
    my($mutator, $accessor) = ("set_$_", "get_$_");
    #diag "method: $mutator; field: $_";
    $foo->$mutator($_);
    is_deeply $foo->$accessor, $expected->{f}->{$_}, "mutator"
}

foreach(qw(o r m)) {
    my($mutator, $accessor) = ("set_$_", "get_$_");
    #diag "method: $mutator; field: $_";
    $foo->$mutator($_);
    is_deeply $foo->$accessor, $expected->{f}->{l}->{$_}, "mutator"
}

is_deeply $foo, $expected, 'object structure has not been changed'
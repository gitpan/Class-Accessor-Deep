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

use Test::More tests => 11;

my $expected = {
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
};
my $foo = Foo->new;

foreach(qw(c a f _s __u)) {
    my $accessor = "get_$_";
    #diag "method: $accessor; field: $_";
    is_deeply $foo->$accessor, $expected->{$_}, "accessor"
}

foreach(qw(g i l)) {
    my $accessor = "get_$_";
    #diag "method: $accessor; field: $_";
    is_deeply $foo->$accessor, $expected->{f}->{$_}, "accessor"
}

foreach(qw(o r m)) {
    my $accessor = "get_$_";
    #diag "method: $accessor; field: $_";
    is_deeply $foo->$accessor, $expected->{f}->{l}->{$_}, "accessor"
}
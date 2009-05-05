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

use Test::More tests => 7;

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

foreach(qw(x y z)) {
    my($mutator, $accessor) = ("set_$_", "get_$_");
    #diag "method: $mutator; field: $_";
    is $foo->$mutator($_), undef, 'mutator for non-existent field';
    is $foo->$accessor, undef, 'mutator for non-existent field'
}

is_deeply $foo, $expected, 'object structure has not been changed'
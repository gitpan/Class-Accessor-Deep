package Class::Accessor::Deep;

use strict;
use warnings;

our $VERSION = '0.01';

use Exporter;
our @EXPORT = qw(AUTOLOAD);

require Scalar::Util;

sub AUTOLOAD {
    no strict 'refs';
    
    my $called = our $AUTOLOAD;
    $called =~ s/.*:://;
    return if $called eq 'DESTROY';
    
    *$called = create_method($called); # inject method into caller's namespace
    goto &$called                      # call injected method
}

sub create_method {
    my $method = shift;
    
    my($field) = $method =~ /^(?:(?:get|set)_)?(\w+)$/o;
    my $closure;
    if($method =~ /^get_/) {
        $closure = sub {
            return ${_lookup(shift, $field) || \undef}  # avoid "Can't use an undefined value as a SCALAR reference"
        }
    }
    elsif($method =~ /^set_/) {
        $closure = sub {
            my $ref = _lookup(shift, $field) || return; # avoid "Modification of a read-only value attempted"
            $$ref = +shift
        }
    }
    else {
        $closure = sub {
            my $self = shift;
            
            if(@_) {
                my $ref = _lookup($self, $field) || return;      # avoid "Modification of a read-only value attempted"
                $$ref = +shift
            }
            else {
                return ${_lookup($self, $field) || \undef}       # avoid "Can't use an undefined value as a SCALAR reference"
            }
        }
    }
    
    return $closure
}

sub _lookup {
    my($hashref, $field) = @_;
    
    return unless ref $hashref;
    return \$hashref->{$field} if exists $hashref->{$field};
    
    foreach(values %$hashref) {
        next if not ref
                or Scalar::Util::blessed($_) # do not handle objects
                or not Scalar::Util::reftype($_) eq 'HASH'
                or not scalar keys %$_;
        
        return _lookup($_, $field)
    }
    
    return
}

1

__END__

=head1 NAME

Class::Accessor::Deep - Automated accessor generation for nested structures inside objects

=head1 SYNOPSIS

Foo.pm:

    package Foo;
    
    use base 'Class::Accessor::Deep';
    
    sub new {
        bless {
            a => {
                b => 'c',
            },
        }, 'Foo'
    }


bar.pl:

    use Foo;
    
    my $foo = Foo->new;
    print $foo->get_b; # prints 'c'
    $foo->set_b('d');  # sets $foo->{a}->{b} to 'd'

=head1 DESCRIPTION

This module generates accessors/mutators for structures with nesting level >= 1.

Using this module you don't have to write

    $obj->hashref->{key1}->{key2}

Now you can just

    $obj->key2 # the same is $obj->{hashref}->{key1}->{key2}

This is done by exporting an AUTOLOAD subroutine to caller's namespace. Every time you call an
undefined method, AUTOLOAD walks your object structure and tries to find a field with the name of method you called.

Indeed this is done only first time you call unique method. After this it will be injected into caller's symtable.
So next time you call the same method it will be executed directly, not via AUTOLOAD.

=head1 METHODS

Class::Accessor::Deep handles these methods:

=over 4

=item * get_I<attr_name> - Readonly accessor

=item * set_I<attr_name>($value) - Writeonly mutator

=item * I<attr_name>($value?) - Read/write accessor/mutator

=back

=head1 CAVEATS

Behaviour for duplicate attributes on different nesting level is not defined.

Objects inside other objects are not handled. This means that you can not access attributes of nested object using this module.

=head1 AUTHOR

sir_nuf_nuf E<lt>mialinx@rambler.ruE<gt>

Aleksey Surikov E<lt>ksuri@cpan.orgE<gt>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
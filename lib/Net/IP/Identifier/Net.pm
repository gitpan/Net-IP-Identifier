#===============================================================================
#      PODNAME:  Net::IP::Identifier::Net
#     ABSTRACT:  subclass Net::IP to add net_or_ip method and stringification
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Sun Jul 20 17:48:21 PDT 2014
#===============================================================================

use 5.002;
use strict;
use warnings;

package Net::IP::Identifier::Net;
use parent 'Net::IP';

our $VERSION = '0.054'; # VERSION

use overload (
    fallback => 1,
    '""' => 'net_or_ip',
);

# Accept any of:
#   Net::IP::Identifier::Net object or class
#   Net::IP                  object
sub new {
    my ($class, @args) = @_;

    die "Must have exactly one argument to 'new'\n" if (@args != 1);
    if (ref $args[0]) {
        return $args[0] if ($args[0]->isa($class)); # already correct
    }
    else {
        $args[0] = Net::IP->new(@args);   # create from parent class
    }
my $xxx = bless $args[0], $class;   # rebless to this package
    return bless $args[0], $class;   # rebless to this package
}

# add a method to print the IP without prefixlen (for single IPs) or
# network with prefixlength
sub net_or_ip {
    my ($self) = @_;

    return $self->ip if ($self->prefixlen == 32);
    return sprintf "%s/%s", $self->ip, $self->prefixlen;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Net - subclass Net::IP to add net_or_ip method and stringification

=head1 VERSION

version 0.054

=head1 SYNOPSIS

  use Net::IP::Identifier::Net;

=head1 DESCRIPTION

Net::IP::Identifier::Net subclasses Net::IP to add the B<net_or_ip> method.

Stringification is provided, and uses the B<net_or_ip> method to produce
the string.

=head2 Methods

=over

=item my $str = $ip->net_or_ip

Returns a string.  For Net::IP::Identifier::Net objects which represent a
single IP, the string is a dotted decimal (N.N.N.N).  If B<$ip> represents
a netblock, the string is a CIDR (N.N.N.N/W).

=back

=head1 AUTHOR

Reid Augustin <reid@hellosix.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Reid Augustin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

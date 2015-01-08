#===============================================================================
#      PODNAME:  Net::IP::Identifier::Plugin::WholeSale
#     ABSTRACT:  identify WholeSale Internet owned IP addresses
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Tue Nov 11 13:13:47 PST 2014
#===============================================================================

use 5.008;
use strict;
use warnings;

package Net::IP::Identifier::Plugin::WholeSale;

use Role::Tiny::With;
with qw( Net::IP::Identifier_Role );

our $VERSION = '0.054'; # VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, (ref $class || $class);

    # List of known WholeSale Internet IP blocks as of Nov 2014
    # (apparently associated with Datashack and Zhou Pizhong)
    $self->ips(qw(
        69.30.192.0/18
        69.197.128.0/18
        173.208.128.0/17
        204.12.192.0/18
        208.67.0.0/21
        208.110.64.0/19
    ));
    return $self;
}

sub name {
    return 'WholeSale';
}

sub children {
    return 'DataShack';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Plugin::WholeSale - identify WholeSale Internet owned IP addresses

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Plugin::WholeSale;

=head1 DESCRIPTION

Net::IP::Identifier::Plugin::WholeSale identifies WholeSale Internet host IPs.

=head2 Methods

=over

=item new

Creates a new Net::IP::Identifier::Plugin::WholeSale object.

=back

=head1 SEE ALSO

=over

=item IP::Net

=item IP::Net::Identifier

=item IP::Net::Identifier_Role

=back

=head1 AUTHOR

Reid Augustin <reid@hellosix.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Reid Augustin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

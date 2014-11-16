#===============================================================================
#      PODNAME:  Net::IP::Identifier::Plugin::B2_Net
#     ABSTRACT:  identify B2_Net Solutions (AS55286) owned IP addresses
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Sun Oct 12 19:32:46 PDT 2014
#===============================================================================

use 5.008;
use strict;
use warnings;

package Net::IP::Identifier::Plugin::B2_Net;

use Role::Tiny::With;
with qw( Net::IP::Identifier_Role );

our $VERSION = '0.054'; # VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, (ref $class || $class);

    # List of known B2_Net Solutions (AS55286) IP blocks as of Sept 2014
    $self->ips(qw(
        23.229.0.0/17
        23.250.0.0/17
        23.236.128.0/17
        23.254.0.0/17
        104.144.0.0/16
        107.152.128.0/17
        138.128.0.0/17
        192.186.128.0/18
        192.241.124.0/24
    ));
    return $self;
}

sub name {
    return 'B2_Net';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Plugin::B2_Net - identify B2_Net Solutions (AS55286) owned IP addresses

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Plugin::B2_Net;

=head1 DESCRIPTION

Net::IP::Identifier::Plugin::B2_Net identifies B2_Net Solutions (AS55286) host IPs.

=head2 Methods

=over

=item new

Creates a new Net::IP::Identifier::Plugin::B2_Net object.

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

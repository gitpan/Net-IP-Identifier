#===============================================================================
#      PODNAME:  Net::IP::Identifier::Plugin::ColoCrossing
#     ABSTRACT:  identify ColoCrossing (AS36352) owned IP addresses
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Sun Oct 12 19:33:06 PDT 2014
#===============================================================================

use 5.008;
use strict;
use warnings;

package Net::IP::Identifier::Plugin::ColoCrossing;

use Role::Tiny::With;
with qw( Net::IP::Identifier_Role );

our $VERSION = '0.054'; # VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, (ref $class || $class);

    # List of known ColoCrossing (AS36352) IP blocks as of Sept 2014
    $self->ips(qw(
        5.226.171.0/24
        8.17.250.0/23
        8.17.252.0/24
        23.94.0.0/15
        23.249.160.0/21
        23.249.168.0/23
        23.249.170.0/24
        23.249.172.0/23
        65.99.193.0/24
        65.99.246.0/24
        66.225.194.0/23
        66.225.198.0/24
        66.225.231.0/24
        66.225.232.0/24
        69.31.134.0/24
        72.249.94.0/24
        72.249.124.0/24
        75.102.10.0/24
        75.102.27.0/24
        75.102.34.0/24
        75.102.38.0/23
        75.127.0.0/20
        96.8.112.0/20
        104.168.0.0/17
        107.161.144.0/21
        107.161.152.0/24
        107.161.155.0/24
        107.161.156.0/23
        107.161.158.0/24
        107.172.0.0/20
        108.174.48.0/20
        162.218.88.0/22
        162.218.92.0/23
        162.218.94.0/24
        162.221.176.0/21
        172.245.0.0/16
        192.3.0.0/16
        192.210.128.0/17
        192.227.128.0/17
        198.12.64.0/18
        198.23.128.0/17
        198.46.128.0/17
        198.144.176.0/20
        198.206.8.0/21
        199.21.112.0/22
        199.188.100.0/22
        204.86.16.0/20
        205.234.152.0/23
        205.234.159.0/24
        205.234.203.0/24
        206.123.95.0/24
        206.217.128.0/20
        207.210.239.0/24
        207.210.254.0/24
        216.246.49.0/24
        216.246.108.0/23
    ));
    return $self;
}

sub name {
    return 'ColoCrossing';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier::Plugin::ColoCrossing - identify ColoCrossing (AS36352) owned IP addresses

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier::Plugin::ColoCrossing;

=head1 DESCRIPTION

Net::IP::Identifier::Plugin::ColoCrossing identifies ColoCrossing (AS36352) host IPs.

=head2 Methods

=over

=item new

Creates a new Net::IP::Identifier::Plugin::ColoCrossing object.

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

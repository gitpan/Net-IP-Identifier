#!/usr/bin/perl
#===============================================================================
#      PODNAME:  Net::IP::Identifier
#     ABSTRACT:  Identify IPs that fall within collections of network blocks
#
#       AUTHOR:  Reid Augustin (REID)
#        EMAIL:  reid@hellosix.com
#      CREATED:  Mon Oct  6 10:20:33 PDT 2014
#===============================================================================

use 5.002;
use strict;
use warnings;

package Local::Payload;
use Moo;

has entity => (
    is => 'rw',
    isa => sub { die "Not a Net::IP::Identifier::Plugin\n"
                    if (not $_[0]->does('Net::IP::Identifier_Role')); },
);
has ip => (
    is => 'rw',
    isa => sub { die "Not a Net::IP::Identifier::Net\n"
                    if (not $_[0]->isa('Net::IP::Identifier::Net')); },
);
package Net::IP::Identifier;
use Moo;

use IO::File;
use File::Spec;
use Readonly;
use Getopt::Long qw(:config pass_through);
use Module::Pluggable;
use Net::IP::Identifier::Net;
use Net::IP::Identifier::Binode;
use Try::Tiny;
#use Regexp::Common qw /net/;

our $VERSION = '0.054'; # VERSION

has joiner => (
    is => 'rw',
    isa => sub { die "Not a string\n" if (ref $_); },
    default => sub { ':' },
);
has cidr => (
    is => 'rw',
);
has parents => (
    is => 'rw',
);
has overlaps => (
    is => 'rw',
);
has tree_overlaps => (
    is => 'rw',
    isa => sub { die "Not an array ref\n"
                    if (not ref $_[0] eq 'ARRAY'); },
);


# some class variables
#my $ipv4_width = qr{\s*/\s*\d\d?};
#my $ipv4_range = qr{\s*-\s*$RE{net}{IPv4}};
#my $add        = qr{\s*\+\s*\d+};
# I need this to work with an older version of perl, so I have copied some
# regexes created from Regexp::Common::net elements:
#my $ipv4       = qr{\b$RE{net}{IPv4}(?:$ipv4_width|$ipv4_range|$add)?\b};
 my $ipv4       = qr/\b(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))(?:\s*\/\s*\d\d?|\s*-\s*(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|\s*\+\s*\d+)?\b/;

#my $ipv6_width = qr{\s*/\s*\d+};
#my $ipv6_range = qr{\s*-\s*$RE{net}{IPv6}};
#my $ipv6       = qr{\b$RE{net}{IPv6}(?:$ipv6_width|$ipv6_range|$add)?\b};
 my $ipv6       = qr/\s*-\s*(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4})|(?::(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?::(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?::(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?::(?:)(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?::(?:)(?:)(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?::(?:)(?:)(?:)(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}))|(?::(?:)(?:)(?:)(?:)(?:)(?:)(?:)(?:):)|(?:(?:[0-9a-fA-F]{1,4}):(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:)(?:)(?:)(?:):)|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:)(?:)(?:):)|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:)(?:):)|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:)(?:):)|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:):(?:[0-9a-fA-F]{1,4}))|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:)(?:):)|(?:(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:[0-9a-fA-F]{1,4}):(?:)(?:):))/;
 my $imports;

 my (undef, undef, $myName) = File::Spec->splitpath($0);
 my $help_msg = <<EO_HELP

$myName [ options ] IP [ IP... ]

If IP belongs to a known entity (a Net::IP::Identifier::Plugin),
print the entity.

IP may be dotted decimal format: N.N.N.N, CIDR format: N.N.N.N/W,
or a filename from which IPs will be extracted.  If no IP is found,
STDIN is opened.

Options (may be abbreviated):
    parents   => prepend Net::IP::Identifier objects of parent entities
    cidr      => append Net::IP::Identifier::Net objects to entities
    filename  => read from file(s) instead of command line args
    overlaps  => show overlapping netblocks during binary tree construction
    help      => this message

EO_HELP
;

__PACKAGE__->run unless caller;     # modulino

sub run {
    my ($class) = @_;

    my %opts;
    my $overlaps;
    my $filename;
    my $help;

    exit 0 if (not
        GetOptions(
            'parents'    => \$opts{parents},
            'cidr'       => \$opts{cidr},
            'overlaps'   => \$overlaps,
            'filename=s' => \$filename,
            'help'       => \$help,
        )
    );

    if ($help) {
        print $help_msg;
        exit;
    }

    my $identifier = __PACKAGE__->new(%opts);

    unshift @ARGV, $filename if ($filename);
    if (not @ARGV) {
        push @ARGV, '-';    # STDIN
    }

    for my $ii (0 .. $#ARGV) {
        my $arg = $ARGV[$ii];
        next if not defined $arg;
        if (-f $arg) {
            open my $fh, '<', $arg;
            die "Can't open $arg for reading\n" if not $fh;
            $identifier->parse_fh($fh);
            close $fh;
            next
        }
        elsif (    $ARGV[$ii + 1]      # accept N.N.N.N - N.N.N.N for network blocks too
                and $ARGV[$ii + 1] eq '-'
                and $ARGV[$ii + 2]) {
            $arg = "$arg-$ARGV[$ii + 2]";
            $ii += 2;
        }
        elsif ($arg eq '-') {   # use STDIN?
            $identifier->parse_fh(\*STDIN);
        }
        elsif ($arg) {
            my ($ip, $error);
            try {
                $ip = Net::IP::Identifier::Net->new($arg);
            } catch {
                $error = $_;
            };
            if ($error) {
                print "$myName: don't understand $arg\n";
                print $error;
            }
            else {
                print $identifier->identify($ip) || $ip, "\n";
            }
        }
    }
    if ($overlaps) {
        for my $return (@{$identifier->tree_overlaps}) {
            my @r = map { join $identifier->joiner, $_->payload->entity, $_->payload->ip; } @{$return};
            warn join(' => ', @r), "\n";
        }
    }
}

sub import {
    my ($class, @imports) = @_;

    $imports = \@imports;   # save import list in class variable
}

sub parse_fh {
    my ($self, $fh) = @_;

    while(<$fh>) {
        my (@ips) = m/($ipv4|$ipv6)/;
        for my $ip (@ips) {
            print $self->identify($ip) || $ip, "\n";
        }
    }
}

sub entities {
    my ($self, @plugins) = @_;

    if (@_ > 1) {
        undef $imports;         # override imports with @plugins
        my $plugins = ref $plugins[0] eq 'ARRAY'    # accept array or ref
            ? $plugins[0]       # a ref was passed in
            : \@plugins;        # convert array to ref
        delete $self->{parent_of};
        delete $self->{entities};
        for my $plugin (@{$plugins}) {
#print "requiring $plugin\n";
            if (not $plugin =~ m/::/) {
                $plugin = __PACKAGE__ . "::Plugin::$plugin";
            }
            eval "CORE::require $plugin";   ## no critic # attempt to read in the plugin
            warn $@ if $@;
            my $p = $plugin && $plugin->new;
            next if not $p;
            if (not $p->does('Net::IP::Identifier_Role')) {
                print "$plugin doesn't satisfy the Net::IP::Identifier_Role - skipping\n";
                next;
            }
            push @{$self->{entities}}, $p;
            for my $child ($p->children) {
                $self->{parent_of}{$child} = $p;
            }
        }
        if (     @$plugins and
            (not   $self->{entities} or
             not @{$self->{entities}})) {
            die "No plugins installed\n";
        }
        delete $self->{ip_tree};
    }

    if (not   $self->{entities} or
        not @{$self->{entities}}) {
        # if no plugins yet loaded, check import list
        # no import list? load everything we can find
        my $load;
        if ($imports) {
            $load = $imports;
            undef $imports;     # only the first time
        }
        else {
            $load = [ $self->plugins ];
        }
        if (@$load) {
            $self->entities($load);
        }
        else {
            die "No entity Plugins found\n";
        }
    }

    return wantarray
        ? @{$self->{entities}}
        : $self->{entities};
}

sub ip_tree {
    my ($self) = @_;

    if (not $self->{ip_tree}) {
        my $root = Net::IP::Identifier::Binode->new;
        my @tree_overlaps;
        for my $entity ($self->entities) {
            for my $ip ($entity->ips) {
                my $masked_ip = substr($ip->binip, 0, $ip->prefixlen);
                my @return = $root->descend(
                    $masked_ip,
                    Local::Payload->new(
                        entity => $entity,
                        ip => $ip,
                    ),
                );
                if (@return > 1) {
                    push @tree_overlaps, \@return;
                }
            }
        }
        $self->tree_overlaps(\@tree_overlaps);
        $self->{ip_tree} = $root;
    }
    return $self->{ip_tree};
}

sub identify {
    my ($self, $ip) = @_;

    $ip = Net::IP::Identifier::Net->new($ip);
    my $masked_ip = substr($ip->binip, 0, $ip->prefixlen);
    my @return = $self->ip_tree->descend($masked_ip);
    if (not @return) {
        return; # not found.
    }

    if (not $self->parents) {
        @return = ($return[-1]);    # just the last child
    }

    @return = map { $_->payload } @return;   # remove the Binode layer

    if (wantarray) {
        return $self->cidr
        ? map { $_->entity, $_->ip } @return
        : @return;
    }

    if ($self->cidr) {
        my @e = map { join ( $self->joiner, $_->entity, $_->ip) } @return;
        return join ' => ', @e;
    }
    my $r = join (' => ', map {
        $_->entity->name
        } @return);
    return $r;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::IP::Identifier - Identify IPs that fall within collections of network blocks

=head1 VERSION

version 0.054

=head1 SYNOPSIS

 use Net::IP::Identifier;
       or
 use Net::IP::Identifier ( qw( Microsoft Google ) );

=head1 DESCRIPTION

Net::IP::Identifier represents...

=head2 Methods

=over

=item run

This module is a modulino, meaning it may be used as a module or as a
script.  The B<run> method is called when there is no caller and it is used
as a script.  B<run> parses the command line arguments, calls B<new()> to
create the object.  If a filename is specified, that file is read and 

=item new( [ options ] );

Creates a new Net::IP::Identifier object.  The following options are available,
and are also available as accessors:

=over

=item parents => boolean

A format modifier.  See B<identify> below.

=item cidr => boolean

A format modifier.  See B<identify> below.

=item joiner => string

The string to use when 'join'ing pieces.  The default is to use ':' on IPv4
addresses and '.' on  IPv6 addresses.

=back

=item entities ( [ @modules ] )

Returns the list of Plugin objects currently in use.

If @modules is defined, they should be the names of the Plugin objects to
'require':

    $identifier->entities( qw(
        Net::IP::Identifier::Plugin::Microsoft
        Net::IP::Identifier::Plugin::Google
        ...
    ) );

If no plugin modules are loaded, and @modules is not defined, the import
list (defined at 'use' time) is loaded.  If there is no import list, all
available modules found in Net::IP::Identifier::Plugins are 'required' and
matched against.  Loading a reference to an empty array:

    $identifier->entities( [] );

also loads all available plugins.

B<modules> may be passed as a reference to an array:

    $identifier->entities ( \@modules );

Plugins can also be loaded selectively at 'use' time (see SYNOPSIS).

=item identify( IP )

Try to identify IP with an entity.  IP may be a B<Net::IP::Identifier::Net>
object or any of the formats acceptable to B<Net::IP::Identifier::Net>.

If the IP cannot be identified with an entity, B<undef> is returned.

If the IP belongs to an included identity (see PLUGINS), the return value is
modified by the format flags.

When all modifiers false, the return value is the name of
the entity (e.g: 'Yahoo').

When B<cidr> is true, the Net::IP::Identifier::Net object of the matching
netblock is appended to the result.

When B<parents> is true, any parent (and grandparent, etc) entities are
prepended to the result.

Flags may be used concurrently.

In scalar context, a string is return where the pieces are joined using
B<joiner>.  In array context, the array of pieces is returned.

=item tree_overlaps

During construction of the binary tree, there may be netblocks that overlap
with existing netblocks.  The return value from B<tree->descend()>
containing more than a single node indicates an such an overlap, and those
return values are stored to the B<tree_overlaps> array reference.

When used as a modulino, the B<overlaps> command line argument causes these
overlaps to generate warning messages.

=back

=head1 PLUGINS

Net::IP::Identifier uses the Module::Pluggable module to support plugins.
See B<entities> for details on controlling which Plugins are loaded.

Plugins uploaded to CPAN should be well known entities, or entities with
wide netblocks.  Let's not congest CPAN with a multitude of class C
netblocks.

Entities with child netblocks can name them in a B<children> subroutine
(see Microsoft and Yahoo for examples).  If you want to add a netblock as a
child, you'll need to arrange with the parent's CPAN owner to add it.  This
relationship is independant of the network hierarchy, and is currently ignored
by Net::IP::Identifier.

Plugins must satisfy the Net::IP::Identifier_Role (see Role::Tiny).

Make sure to test your plugin by running Identifier with the C<overlaps>
flag.  C<overlaps> causes overlapping netblocks to be reported.  Overlaps
are not necessarily an error and there may be overlaps caused by modules other than
your new Plugin.

Note: there is no checking of overlapping or conflicting netblocks, so
double check your information.

=head1 SEE ALSO

=over

=item Net::IP

=item Net::IP::Identifier::Net

=item Net::IP::Identifier::Plugins::Google (and other plugins in this directory)

=item Role::Tiny

=item Module::Pluggable

=back

=head1 AUTHOR

Reid Augustin <reid@hellosix.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Reid Augustin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

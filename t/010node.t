#===============================================================================
#  DESCRIPTION:  test for Net::IP::Identifier::Binode.pm
#
#       AUTHOR:  Reid Augustin
#        EMAIL:  reid@LucidPort.com
#      CREATED:  11/11/2014 04:46:22 PM
#===============================================================================

use 5.008;
use strict;
use warnings;


use Test::More
    tests => 14;

# VERSION

my $NIIB = 'Net::IP::Identifier::Binode';
use_ok $NIIB;   # the module under test
my $n0 = $NIIB->new;

isa_ok $n0, $NIIB,                        'create top node';
is $n0->zero, undef,                      'no zero subnode';
is $n0->one,  undef,                      'no one subnode';

my @mask0 = (qw( 1 1 0 0 ) );
my @ip0   = (qw( 0 0 0 1 ) );

my @return = $n0->descend('00', 'abc');
is     $n0->one, undef,                  'level one child node(0)';
isa_ok $n0->zero, $NIIB,                 'level one child node(1)';
isa_ok $n0->zero->zero, $NIIB,           'level two child node(1)';
is_deeply $n0->zero->zero->payload, ('abc'), 'level two child node payload';

@return = $n0->descend('011', 'XyZ');
is $return[0]->payload, 'XyZ',           'level three child node';
@return = $n0->descend('00');
is        $return[0]->payload, 'abc', 'level 2 child intact';
@return = $n0->descend('011');
is        $return[0]->payload, 'XyZ', 'level 3 child intact';
@return = $n0->descend('0001', '987');
is scalar @return, 2,                  '2 return items';
is        $return[0]->payload, 'abc',  '   item 1 correct';
is        $return[1]->payload, '987',  '   item 2 correct';



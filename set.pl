#!/usr/bin/perl -w

# set.pl -- solver for the card game "Set".
# by Neil Kandalgaonkar

# Copyright (c) 2007, Neil Kandalgaonkar
# Released under the BSD license
# http://www.opensource.org/licenses/bsd-license.php

# How to use it:
#
# run program
# on standard input, enter in a group of cards encoded like so
#   1rfo 2pss 3ged
# followed by a newline
# 
# the example set means "one red filled oval", "two purple shaded squiggles",
#  "3 green empty diamonds"
#
# program will output all valid sets

my $ALL_FIRST  = 0b001;
my $ALL_SECOND = 0b010;
my $ALL_THIRD  = 0b100;
my $ALL_DIFFERENT = 0b111;

my @attr_allowed = ( 
  ["number", "123"], # 1, 2, 3
  ["color",  "rgp"], # red, green, purple
  ["shade",  "fse"], # filled, shaded, empty
  ["shape",  "sod"], # squiggle, oval, diamond
);

while (<>) {
  chomp;
  my @input_card = split ' ' => $_;
  my @bcard;
  
  # for every card, convert it to a binary representation -- this 
  # is useful for fast evaluation of the set
  for my $card (@input_card) {
    my $bcard;
    for my $attr_idx (0..$#attr_allowed) {
      my ($attrname, $allowed) = @{$attr_allowed[$attr_idx]};
      my $attr = substr($card, $attr_idx, 1);
      my $found_idx = index($allowed, $attr);
      if ($found_idx == -1)  {
        die "did not recognize $attrname = $attr";
      }
      $bcard |= 1 << ($attr_idx * 4 + $found_idx);
    }      
    push @bcard, $bcard;
  }

  # we send off an array with a binary representation of the cards,
  # and get back an array of arrays of positions of cards that are sets
  my @allSetIndex = allSetIndex(@bcard);

  if (@allSetIndex) { 
    # remap the indices back to the original string representations of the cards.
    for my $setIndex (@allSetIndex) {
      my $printableSet = join " & ",  map { $input_card[$_] } @$setIndex;
      print "$printableSet\n";
    }
  } else {
    warn "no valid sets found\n";
  }

}

sub allSetIndex {
  my (@bcard) = @_;
  my @setIndex;
  for my $i (0..$#bcard) {
    for my $j ($i+1..$#bcard) {
      for my $k ($j+1..$#bcard) {
        if (isSet($bcard[$i] | $bcard[$j] | $bcard[$k])) {
          push @setIndex, [$i, $j, $k];
        }
      }
    }
  }
  return @setIndex;
}

# compare each combined property to an expected bitmask.
# a property, such as color, can only be 001, 010, 100, or 111
# just do that for each property
sub isSet {
  my $set = shift;
  for my $i (0..3) { 
    # bitshift to get a group of three over, then zero out all
    # else
    $allAttr = ($set >> ($i * 4)) & 7; 
    if ($allAttr != $ALL_FIRST and
        $allAttr != $ALL_SECOND and
        $allAttr != $ALL_THIRD and
        $allAttr != $ALL_DIFFERENT) {
       return 0;
     }
  }
  return 1;
}

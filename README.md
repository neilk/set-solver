set-solver
==========

A Perl script to solve games of Set.

This program accepts lines describing deals of cards, on standard input, and outputs all valid sets on standard output.

The code to describe the cards works like this:

Cards are four-character sequences are separated by spaces.

For each card, there is one letter to describe number, then color, then shade, then shape (in that order).

- number: 1, 2, 3
- color: r = red, g = green, p = purple
- shade: f = filled, s = shaded, e = empty
- shape: s = squiggle, o = oval, d = diamond


For instance, if we had cards like 
    3 green empty ovals       1 red filled squiggle     3 green shaded ovals      3 red empty diamonds 
    2 purple empty ovals      1 red empty oval          1 purple empty diamond    3 purple shaded squiggles
    3 purple empty squiggles  3 purple filled diamonds  2 purple shaded diamonds  3 green empty diamonds

we could run it like this:

    $ perl set.pl
    3geo 1rfs 3gso 3red 2peo 1reo 1ped 3pss 3pes 3pfd 2psd 3ged   (typed)
    
and the output would be:
    
    3geo & 1rfs & 2psd
    3geo & 3red & 3pes
    3geo & 2peo & 1reo
    2peo & 1ped & 3pes
    1ped & 3pfd & 2psd

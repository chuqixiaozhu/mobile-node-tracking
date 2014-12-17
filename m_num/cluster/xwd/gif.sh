#! /bin/bash

j=0
for i in *.xwd; do
    xwdtopnm <$i |
#    ppmtogif -interlace -transparent’#e5e5e5’ >‘basename $i .xwd‘.gif;
    ppmtogif -interlace -transparent '#e5e5e5' >`basename $i .xwd`.gif;
#    ppmtogif >"$j".gif;
#    j="$(expr $j + 1)"
done
gifmerge -l0 -2 -229,229,229 *.gif >movie.gif

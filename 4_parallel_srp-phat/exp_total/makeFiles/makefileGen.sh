#!/bin/bash
# Release date: June 2015
# Author: Taewoo Lee, (twlee@speech.korea.ac.kr)
#
# Copyright (C) 2015 Taewoo Lee
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# In: Makefile_head, Makefile_tail
# Out: Makefile_M?_Q?_TD?_CC?_SRP?_FD?_SRP?.txt
#
# Reference:
# [1] Taewoo Lee, Sukmoon Chang, and Dongsuk Yook, "Parallel SRP-PHAT for
#     GPUs," Computer Speech and Language, vol. 35, pp. 1-13, Jan. 2016.
#
CheckError () {
  if [ $? -ne 0 ]; then
    exit 0
	fi
}

rm -f ./*.txt
CheckError

for q in 3888 97200 388800; do
  for m in 8 16 32; do
    #FD_GPU
    echo $q $m
    
    for fdgpu in 2 4; do
      cat Makefile_head > "Makefile_M""$m""_Q""$q""_TD0_CC0_SRP0_FD1_SRP""$fdgpu"".txt"
      CheckError
      echo "COMMONFLAGS += \$(INCLUDES) -w -DM=""$m"" -DQ=""$q"" -DTD_GPU=0 -DTD_GPU_CC=0 -DTD_GPU_SRP=0 -DFD_GPU=1 -DFD_GPU_SRP=$fdgpu" >> "Makefile_M""$m""_Q""$q""_TD0_CC0_SRP0_FD1_SRP""$fdgpu"".txt"
      CheckError
      cat Makefile_tail >> "Makefile_M""$m""_Q""$q""_TD0_CC0_SRP0_FD1_SRP""$fdgpu"".txt"
      CheckError
    done

    #TD_GPU
    for tdcc in 3; do       #3=Proposed(shared+reg memory version)
      for tdsrp in 43; do   #43=Proposed
        cat Makefile_head > "Makefile_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0"".txt"
        CheckError
        echo "COMMONFLAGS += \$(INCLUDES) -w -DM=""$m"" -DQ=""$q"" -DTD_GPU=1 -DTD_GPU_CC=$tdcc -DTD_GPU_SRP=""$tdsrp"" -DFD_GPU=0 -DFD_GPU_SRP=0" >> "Makefile_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0"".txt"
        CheckError
        cat Makefile_tail >> "Makefile_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0"".txt"
        CheckError
      done 
    done

    for tdcc in 13; do      #13=Minotto
      for tdsrp in 41; do   #41=Minotto
        cat Makefile_head > "Makefile_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0"".txt"
        CheckError
        echo "COMMONFLAGS += \$(INCLUDES) -w -DM=""$m"" -DQ=""$q"" -DTD_GPU=1 -DTD_GPU_CC=$tdcc -DTD_GPU_SRP=""$tdsrp"" -DFD_GPU=0 -DFD_GPU_SRP=0" >> "Makefile_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0"".txt"
        CheckError
        cat Makefile_tail >> "Makefile_M""$m""_Q""$q""_TD1_CC""$tdcc""_SRP""$tdsrp""_FD0_SRP0"".txt"
        CheckError
      done 
    done

  done
done

find -name '*.txt' > makefileList.tmp
sort makefileList.tmp > makefileList
rm -f makefileList.tmp


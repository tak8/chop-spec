#!/usr/bin/python
#
# Pass 7: Calculates the ID of each text chunk.
#
##############################################################################
# Copyright (C) 2013  Cable Television Laboratories, Inc.
# Contact: http://www.cablelabs.com/
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL CABLELABS OR ITS CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
##############################################################################

import fileinput
import hashlib
import re
import sys


################

# Use as the ID the first eight digits of SHA-1(section_ID + SPC + text).
# For example, "An img element represents an image." in section
# "the-img-element" yields 88c91716.  If multiple entries have the same
# SHA-1 (most likely from the same content in same section), their IDs get a
# suffix (".1", ".2", ...)  to be unique.

def assign_id(lines, hashes, output):
    for l in lines:
        m1 = re.search('^ *<section .* id="(.*?)".*>$', l)
        if m1:
            section_id = m1.group(1)

        m2 = re.search('^ *<t .*>(.*)</t>$', l)
        if m2:
            text = section_id + ' ' + m2.group(1)
            h = hashlib.sha1(text).hexdigest()[0 : 8]
            if not output:
                if h in hashes:         # Hash collision
                    hashes[h] = 0
                else:
                    hashes[h] = -1
            else:
                id = section_id + '@' + h
                if hashes[h] >= 0:      # Hash collision
                    hashes[h] += 1
                    id += '.' + str(hashes[h])
                l = re.sub('(?<= id-hash=").*?(?=".*?>)', id, l)

        if output:
            output.write(l)


################

lines = []
for l in fileinput.input():
    lines.append(l)

hashes = {}
assign_id(lines, hashes, None)
assign_id(lines, hashes, sys.stdout)

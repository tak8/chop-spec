#!/usr/bin/python
#
# Pass 8: Maps each text chunk ID to its original location in spec.
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
import re
import sys

id_file = sys.argv[1]
del sys.argv[1:2]

ids = {}
for l in fileinput.input(files = (id_file)):
    m = re.search('^ *<t __addr="(:[0-9:]+?)" id-hash="(.+@.+)">', l)
    if m:
        ids[m.group(1)] = m.group(2)

def lookup(m):
    key = m.group(1)
    if key in ids:
        return ' __addr_id="' + ids[key] + '">'
    else:
        return m.group(0)

for l in fileinput.input():
    sys.stdout.write(re.sub(' __addr="(:[0-9:]+?)">', lookup, l))

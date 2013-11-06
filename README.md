Description
===========

chop-spec chops a W3C specification document in HTML into text chunks
and assigns an ID to each chunk.  It generates the list of text chunks
and IDs and the input document with embedded IDs.


Usage Example
=============

chop-spec requires `xsltproc` and `python`.

    $ wget --output-document=original.html http://www.w3.org/TR/2012/CR-html5-20121217/document-metadata.html
    $ chop-spec original.html tagged.html ids.xml

Now open `tagged.html` with a browser, feed `ids.xml` into database, etc.


Processing Details
==================

Chopping
--------

It chops the spec into text chunks roughly by [Grouping
Content](http://www.w3.org/TR/html5/grouping-content.html#grouping-content).
A big exception is `<table>`s.  It flattens them by joining all the
cells with `&#13;` as delimiter.  This might be arguable, but chopping
them down to cells is too choppy IMO.

It associates each text chunk to the preceding heading
(`<h1>`...`<h6>`).  The document structure drawn by `<section>`s and
etc are currently ignored.


Trimming
--------

It removes text decorations such as `<strong>` and `<a>` from text
chunks, shrinks whitespaces in them, and encodes them in US-ASCII with
XML character references.

It skips parts of spec that appear nonnormative (e.g. sections saying
"nonnormative", examples, unnumbered sections).

Text chunk IDs
--------------

Each text chunk gets an ID based on the hash value of its content.  For
example, a paragraph `An img element represents an image.` in section
`the-img-element` (HTML5 Section 4.8.1) gets 88c91716.  It is the first
eight digits of SHA-1 of `the-img-element An img element represents an
image.`.  Trimming above helps this ID be stable.

If multiple text chunks get the same hash value, their IDs get a suffix
(".1", ".2", ...).  This is most likely from multiple occurences of the
same text chunk in the same section, rather than ones from different
sections.  Adding the section ID to chunk ID calculation helps avoiding
the latter kind of hash collisions.


Limitation
==========

* Input HTML needs to be nice to `xsltproc --html`.  Unescaped `<`s and
  `&`s could cause a problem for example.


License
=======

Copyright (C) 2013  Cable Television Laboratories, Inc.
Contact: http://www.cablelabs.com/

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL CABLELABS OR ITS CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

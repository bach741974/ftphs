{- arch-tag: MIMETypes tests main file
Copyright (C) 2004 John Goerzen <jgoerzen@complete.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-}

module MIMETypestest(tests) where
import HUnit
import MissingH.MIMETypes

test_guessType =
    let f strict inp exp = exp @=? guessType defaultmtd strict inp in 
        do
        f True "" (Nothing, Nothing)
        f True "foo" (Nothing, Nothing)
        f True "foo.txt" (Just "text/plain", Nothing)
        f True "foo.txt.gz" (Just "text/plain", Just "gzip")
        f True "foo.txt.blah" (Nothing, Nothing)
        f True "foo.tar" (Just "application/x-tar", Nothing)
        f True "foo.tar.gz" (Just "application/x-tar", Just "gzip")
        f True "foo.tgz" (Just "application/x-tar", Just "gzip")
        f True "http://foo/test.dir/blah.rtf" (Nothing, Nothing)
        f False "http://foo/test.dir/blah.rtf" (Just "application/rtf", Nothing)
        f True "foo.pict" (Nothing, Nothing)
        f False "foo.pict" (Just "image/pict", Nothing)

tests = TestList [TestLabel "guessType" (TestCase test_guessType)
                 ]
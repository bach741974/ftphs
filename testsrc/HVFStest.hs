{- arch-tag: HVFS tests main file
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

module HVFStest(tests) where
import HUnit
import MissingH.IO.HVIO
import MissingH.IO.HVFS
import MissingH.IO.HVFS.InstanceHelpers
import Testutil
import System.IO
import System.IO.Error
import Control.Exception

ioeq :: (Show a, Eq a) => a -> IO a -> Assertion
ioeq exp inp = do x <- inp
                  exp @=? x

testTree = [("test.txt", MemoryFile "line1\nline2\n"),
            ("file2.txt", MemoryFile "line3\nline4\n"),
            ("emptydir", MemoryDirectory []),
            ("dir1", MemoryDirectory
             [("file3.txt", MemoryFile "line5\n"),
              ("test.txt", MemoryFile "subdir test"),
              ("dir2", MemoryDirectory [])
             ]
            )
           ]

test_structure =
    let f msg testfunc = TestLabel msg $ TestCase $ do x <- newMemoryVFS testTree
                                                       testfunc x
        in
        [
         f "root" (\x -> ["test.txt", "file2.txt", "emptydir", "dir1"]
                         `ioeq` vGetDirectoryContents x "/")
        ]
                            

tests = TestList [TestLabel "structure" (TestList test_structure)

                 ]
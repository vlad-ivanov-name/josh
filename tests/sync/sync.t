  $ export TESTTMP=${PWD}
  $ export PATH=${TESTDIR}/../../target/debug/:${PATH}

  $ cd ${TESTTMP}
  $ git init libs 1> /dev/null
  $ cd libs

  $ mkdir sub1
  $ echo contents1 > sub1/file1
  $ git add sub1
  $ git commit -m "add file1" 1> /dev/null

  $ echo contents2 > sub1/file2
  $ git add sub1
  $ git commit -m "add file2" 1> /dev/null

  $ git checkout -b foo
  Switched to a new branch 'foo'

  $ mkdir sub2
  $ echo contents1 > sub2/file3
  $ git add sub2
  $ git commit -m "add file3" 1> /dev/null

  $ cd ${TESTTMP}
  $ git init apps 1> /dev/null
  $ cd apps

  $ git remote add libs ${TESTTMP}/libs
  $ git fetch --all
  Fetching libs
  From * (glob)
   * [new branch]      foo        -> libs/foo
   * [new branch]      master     -> libs/master


  $ cat > syncinfo <<EOF
  > [libs(master)]
  > c = :/sub1
  > [libs(foo)]
  > a/b = :/sub2
  > EOF

  $ git add syncinfo
  $ git commit -m "initial" 1> /dev/null

  $ git ls-tree -r HEAD
  100644 blob 078fc2cc27af0d3d32e98f297a7e315019474562\tsyncinfo (esc)
  $ tree
  .
  `-- syncinfo
  
  0 directories, 1 file

  $ josh-sync --file syncinfo -m "sync libraries"

  $ tree
  .
  |-- a
  |   `-- b
  |       `-- file3
  |-- c
  |   |-- file1
  |   `-- file2
  `-- syncinfo
  
  3 directories, 4 files

  $ git ls-files --with-tree=HEAD
  a/b/file3
  c/file1
  c/file2
  syncinfo

  $ git status
  On branch master
  nothing to commit, working tree clean

  $ git log
  commit a50d9fdc8f14b3fad8f4676ca786bb9040e7cb32
  Author: Christian Schilling <christian.schilling@esrlabs.com>
  Date:   Thu Dec 17 01:45:58 2020 +0000
  
      sync libraries
      
      Synced: libs(master) rev: 082294dbe63c7c4a9299314a4f30616beca64992
      Synced: libs(foo) rev: d6c5e59451f90a077bdc324ec9737d646be8315a
  
  commit f760fa129a2853fcb250f827c64896bee9e18b56
  Author: Christian Schilling <christian.schilling@esrlabs.com>
  Date:   Thu Dec 17 01:45:58 2020 +0000
  
      initial


  $ cat > syncinfo <<EOF
  > [libs(master)]
  > d/f/g = :/sub1
  > [libs(foo)]
  > xx = :/sub2
  > EOF

  $ josh-sync --file syncinfo -m "sync libraries"

  $ tree
  .
  |-- a
  |   `-- b
  |       `-- file3
  |-- c
  |   |-- file1
  |   `-- file2
  |-- d
  |   `-- f
  |       `-- g
  |           |-- file1
  |           `-- file2
  |-- syncinfo
  `-- xx
      `-- file3
  
  7 directories, 7 files

  $ git ls-files --with-tree=HEAD
  a/b/file3
  c/file1
  c/file2
  d/f/g/file1
  d/f/g/file2
  syncinfo
  xx/file3

  $ git status
  On branch master
  Changes to be committed:
    (use "git restore --staged <file>..." to unstage)
  \tmodified:   syncinfo (esc)
  
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
  \tmodified:   syncinfo (esc)

  

  $ git log
  commit 1e2cabdfaafeb1ec03f709a03dc56e8c9c3e2897
  Author: Christian Schilling <christian.schilling@esrlabs.com>
  Date:   Thu Dec 17 01:45:58 2020 +0000
  
      sync libraries
      
      Synced: libs(master) rev: 082294dbe63c7c4a9299314a4f30616beca64992
      Synced: libs(foo) rev: d6c5e59451f90a077bdc324ec9737d646be8315a
  
  commit a50d9fdc8f14b3fad8f4676ca786bb9040e7cb32
  Author: Christian Schilling <christian.schilling@esrlabs.com>
  Date:   Thu Dec 17 01:45:58 2020 +0000
  
      sync libraries
      
      Synced: libs(master) rev: 082294dbe63c7c4a9299314a4f30616beca64992
      Synced: libs(foo) rev: d6c5e59451f90a077bdc324ec9737d646be8315a
  
  commit f760fa129a2853fcb250f827c64896bee9e18b56
  Author: Christian Schilling <christian.schilling@esrlabs.com>
  Date:   Thu Dec 17 01:45:58 2020 +0000
  
      initial


  $ gitk

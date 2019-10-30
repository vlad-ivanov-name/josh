  $ export TESTTMP=${PWD}
  $ export PATH=${TESTDIR}/../../target/debug/:${PATH}

  $ cd ${TESTTMP}
  $ git init real_repo &>/dev/null
  $ cd real_repo

  $ mkdir sub2
  $ echo contents1 > sub2/file2
  $ git add sub2
  $ git commit -m "add sub2" &> /dev/null

  $ mkdir sub1
  $ echo contents1 > sub1/file1
  $ git add sub1
  $ git commit -m "add file1" &> /dev/null
  $ git branch branch1

  $ echo contents1 > sub1/file2
  $ git add sub1
  $ git commit -m "add file2" &> /dev/null

  $ git log --graph --pretty=%s
  * add file2
  * add file1
  * add sub2

  $ josh-filter branch1:refs/heads/hidden_branch1 :hide=sub2
  $ git checkout hidden_branch1
  Switched to branch 'hidden_branch1'
  $ tree
  .
  `-- sub1
      `-- file1
  
  1 directory, 1 file
  $ echo contents3 > sub1/file3
  $ git add sub1/file3
  $ git commit -m "add file3" &> /dev/null

  $ josh-filter master:refs/heads/hidden_master :hide=sub2
  $ git checkout hidden_master
  Switched to branch 'hidden_master'
  $ tree
  .
  `-- sub1
      |-- file1
      `-- file2
  
  1 directory, 2 files
  $ echo contents4 > sub1/file4
  $ git add sub1/file4
  $ git commit -m "add file4" &> /dev/null

  $ git log hidden_master --graph --pretty=%s
  * add file4
  * add file2
  * add file1
  $ git log hidden_branch1 --graph --pretty=%s
  * add file3
  * add file1

  $ git merge hidden_branch1 --no-ff
  Merge made by the 'recursive' strategy.
   sub1/file3 | 1 +
   1 file changed, 1 insertion(+)
   create mode 100644 sub1/file3
  $ git log --graph --pretty=%s
  *   Merge branch 'hidden_branch1' into hidden_master
  |\  
  | * add file3
  * | add file4
  * | add file2
  |/  
  * add file1

  $ josh-filter --reverse master:refs/heads/hidden_master :hide=sub2

  $ git checkout master
  Switched to branch 'master'

  $ tree
  .
  |-- sub1
  |   |-- file1
  |   |-- file2
  |   |-- file3
  |   `-- file4
  `-- sub2
      `-- file2
  
  2 directories, 5 files



  $ git log --graph --pretty=%s
  *   Merge branch 'hidden_branch1' into hidden_master
  |\  
  | * add file3
  * | add file4
  * | add file2
  |/  
  * add file1
  * add sub2

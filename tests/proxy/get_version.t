  $ . ${TESTDIR}/setup_test_env.sh
  $ cd ${TESTTMP}

  $ curl -s http://localhost:8002/version
  Version: r*.*.* (glob)

  $ bash ${TESTDIR}/destroy_test_env.sh
  .
  |-- josh
  |   `-- 13
  |       `-- sled
  |           |-- blobs
  |           |-- conf
  |           `-- db
  |-- mirror
  |   |-- HEAD
  |   |-- config
  |   |-- description
  |   |-- info
  |   |   `-- exclude
  |   |-- objects
  |   |   |-- info
  |   |   `-- pack
  |   `-- refs
  |       |-- heads
  |       `-- tags
  `-- overlay
      |-- HEAD
      |-- config
      |-- description
      |-- info
      |   `-- exclude
      |-- objects
      |   |-- info
      |   `-- pack
      `-- refs
          |-- heads
          `-- tags
  
  20 directories, 10 files

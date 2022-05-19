test_that("mod works", {
  expect_error(mod(), "'name' argument is missing")
  expect_error(mod(name = "mymodel.mod"), NA)
  expect_equal(mod(name = "mymodel.mod", dir = "dir/subdir"), "dir/subdir/mymodel.mod")
  expect_equal(mod(name = "mymodel.mod", dir = "dir/subdir", file = "blabla.mod"), "blabla.mod")

  expect_error(mod(file = system.file("nm001/run001.mod", package = "runnonmem")), NA)
})

test_that("cmd works", {
 expect_equal(
  cmd(modelfile = "Y:/path/to/mymodel/run001.mod", nonmem = "C:/nm74g64/util/nmfe74.bat"),
  'Y: & cd "Y:/path/to/mymodel" & CALL "C:/nm74g64/util/nmfe74.bat" run001.mod run001.lst & pause'
   )
})

test_that("bat works", {
  bat <- bat()
  expect_match(bat, "\\\\[[:alnum:]]{10}\\.bat$")

  bat2 <- bat()
  expect_false(bat==bat2)

})

test_that("getdisk works", {
  expect_equal(getdisk("bla"), NA_character_)
  expect_equal(getdisk("C:/bla"), "C:")
  expect_equal(getdisk("Z:/bla/bla"), "Z:")
})

test_that("lst works", {
  expect_equal(lst("001.mod"), "001.lst")
  expect_equal(lst("001.ctl"), "001.lst")
  expect_equal(lst("001.txt"), "001.lst")

  expect_error(lst("001.bla"), "Cannot create \\.lst")

  expect_equal(lst("mod001.mod"), "mod001.lst")
})

test_that("tick works", {
  expect_equal(tick("C:/hello"), '"C:/hello"')
  expect_equal(tick("C:/hello"), "\"C:/hello\"")
})

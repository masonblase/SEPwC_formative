suppressPackageStartupMessages({
library(testthat)
})

# Run like:
#jh1889@mirovia:~/work/teaching/SEPwC_assessments/sediment_assessment/test$ Rscript test_script.R 
# Test passed 🥇
# Test passed 🌈
# Test passed 🎊
# Test passed 🥳
# ── Warning: check main# 
# ...
#

# load in the script you want to test
source("../todo.R", local=TRUE)
test_file <- "test_list.txt"


# tests --------------------
test_that("list_tasks works correctly", {
  # Assuming test_file is defined and the necessary setup is done
  
  TASK_FILE <<- test_file
  
  task_list <- list_tasks()
  expected_list <- "1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5"
  
  expect_equal(task_list, expected_list)
})

test_that("remove_task works correctly", {
  # Assuming test_file is defined and the necessary setup is done
  
  temp_list <- ".temp_test.txt"
  file.copy(test_file, temp_list, overwrite=TRUE)
  TASK_FILE <<- temp_list
  
  # Test invalid index (should error)
  expect_error(remove_task(0))
  
  # Test invalid index (should error)
  expect_error(remove_task(10))
  
  # Remove the first task
  remove_task(1)
  
  task_list <- list_tasks()
  new_expected <- "1. Item 2\n2. Item 3\n3. Item 4\n4. Item 5"
  
  expect_equal(task_list, new_expected)
  
  file.remove(temp_list)
})

test_that("add_task works correctly", {
  # Assuming test_file is defined and the necessary setup is done

  temp_list <- ".temp_test.txt"
  file.copy(test_file, temp_list, overwrite=TRUE)
  TASK_FILE <<- temp_list

  add_task("Item 6")

  task_list <- list_tasks()
  expected_list <- "1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5\n6. Item 6"

  expect_equal(task_list, expected_list)

  file.remove(temp_list)
})

test_that("check main", {

  temp_list <- ".temp_test.txt"
  file.copy(test_file, temp_list, overwrite=TRUE)
  TASK_FILE <<- temp_list

  # parse_args sets all arguments, so we need to create them all
  args <- c("list" = TRUE, "add" = NULL, "remove" = NULL)
  args <- data.frame(t(args))
  output <- capture.output(main(args))
  expect_equal(nchar(output), 59)

  args <- c("add" = "Item 6", "list" = FALSE, "remove" = NULL)
  args <- data.frame(t(args))
  output <- capture.output(main(args))
  expect_identical(output, character(0))

  args <- c("list" = TRUE, "add" = NULL, "remove" = NULL)
  args <- data.frame(t(args))
  output <- capture.output(main(args))
  expect_equal(nchar(output), 70)
  expected_list <- "[1] \"1. Item 1\\n2. Item 2\\n3. Item 3\\n4. Item 4\\n5. Item 5\\n6. Item 6\""
  expect_equal(output, expected_list)

  args <- c("remove" = 6, "add" = NULL, "list" = FALSE)
  args <- data.frame(t(args))
  output <- capture.output(main(args))
  expect_lt(nchar(output), 25)

  
  file.remove(temp_list)

})


if (requireNamespace("lintr")) {
library(lintr)

context("linting script")
test_that("Coding style", {
  output<-lintr::lint("../todo.R")
  expect_lt(length(output),500)
  expect_lt(length(output),400)
  expect_lt(length(output),250)
  expect_lt(length(output),100)
  expect_lt(length(output),50)
  expect_lt(length(output),10)
  expect_equal(length(output),0)
})
}



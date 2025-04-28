#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(argparse)
})

TASK_FILE <- ".tasks.txt" # nolint

add_task <- function(task) {
  write(task, file = TASK_FILE, append = TRUE, sep = "\n")
}

list_tasks <- function() {
  if (file.exists(TASK_FILE)) {
    tasks <- readLines(TASK_FILE)
    output_string <- paste(seq_along(tasks), tasks, sep = ". ", collapse = "\n")
    return(output_string)
  } else {
    return("No tasks found.")
  }
}

remove_task <- function(index) {

  tasks <- NA
  if (file.exists(TASK_FILE)) {
    tasks <- readLines(TASK_FILE)
  } else {
    stop("File not found")
  }
  if (index <= length(tasks)) {
    tasks <- tasks[-index]
    if (identical(tasks, character(0))) {
      stop("Task not found")
    }
    writeLines(tasks, TASK_FILE)
    print("Task removed.")
  } else {
    stop("No tasks found.")
  }
}

main <- function(args) {

  if (!is.null(args$add)) {
    add_task(args$add)
  } else if (args$list) {
    tasks <- list_tasks()
    print(tasks)
  } else if (!is.null(args$remove)) {
    remove_task(args$remove)
  } else {
    print("Use --help to get help on using this program")
  }
}


if (sys.nframe() == 0) {

  # main program, called via Rscript
  parser <- ArgumentParser(description = "Command-line Todo List")
  parser$add_argument("-a", "--add",
                      help = "Add a new task")
  parser$add_argument("-l", "--list",
                      action = "store_true",
                      help = "List all tasks")
  parser$add_argument("-r", "--remove",
                      help = "Remove a task by index")

  args <- parser$parse_args()
  main(args)
}

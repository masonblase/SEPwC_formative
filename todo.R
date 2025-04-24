#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(argparse)
})

TASK_FILE <- ".tasks.txt" # nolint

add_task <- function(task) {
  # Code written with assistance of Google Gemini
  write(task,
        file = TASK_FILE,
        append = TRUE)
}

list_tasks <- function() {
  # Code written with assistance of Google Gemini
  if (file.exists(TASK_FILE)) {
    tasks <- readLines(TASK_FILE)
    if (length(tasks) > 0) {
      result <- character(0)  # Initialize an empty character vector
      for (i in seq_along(tasks)) {
        result <- c(result, paste0(i, ". ", tasks[i]))
      }
      return(paste0(result, collapse = "\n")) # Return as single string
    } else {
      return("No tasks found in .tasks.txt\n")
    }
  } else {
    stop("Task file .tasks.txt does not exist yet.\n")
  }
}

remove_task <- function(index) {
  # Code written with assistance of Google Gemini
  if (file.exists(TASK_FILE)) {
    tasks <- readLines(TASK_FILE)
    index <- as.integer(index) # Ensure it's an integer
    
    if (!is.na(index) && index >= 1 && index <= length(tasks)) {
      removed_task <- tasks[index]
      tasks <- tasks[-index]
      writeLines(tasks, TASK_FILE)
      cat(paste0("Task '", removed_task, "' (index ", index, ") removed from ", TASK_FILE, "\n"))
    } else {
      stop(paste0("Error: Invalid task index '", index, "' in ", TASK_FILE, "\n"))
    }
  } else {
    stop("Error: Task file .tasks.txt does not exist.\n")
  }
}

main <- function(args) {
  
  if (!is.null(args$add)) {
    add_task(args$add)
  } else if (args$list) {
    tasks <- list_tasks()
    cat(tasks) # change print to cat
  } else if (!is.null(args$remove)) {
    remove_task(args$remove)
  } else {
    cat("Use --help to get help on using this program\n") # change print to cat and add a newline
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


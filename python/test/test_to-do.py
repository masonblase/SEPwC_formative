import pytest
import sys
import os
import shutil
from pylint.lint import Run
from pylint.reporters import CollectingReporter
sys.path.insert(0,"../")
sys.path.insert(0,"./")
from dataclasses import asdict
import todo
test_file = "test/test_list.txt"

class TestTodoList():
    
    def test_list_tasks(self):
        todo.TASK_FILE = test_file
        task_list = todo.list_tasks()
        expected_list ="1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5"
        
        assert task_list == expected_list

    def test_remove_task(self):
        temp_list = ".temp_test.txt"
        shutil.copyfile(test_file, temp_list)
        todo.TASK_FILE = temp_list
        # should error (need to catch?)
        todo.remove_task(0)
        # list should be the same
        task_list = todo.list_tasks()
        expected_list ="1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5"
        assert task_list == expected_list
        # should also error
        todo.remove_task(10)
        # list should be the same
        task_list = todo.list_tasks()
        assert task_list == expected_list
        # should not error!
        todo.remove_task(1)
        task_list = todo.list_tasks()
        new_expected = "1. Item 2\n2. Item 3\n3. Item 4\n4. Item 5"
        # note assert checks from 1 as we remove line 0
        assert task_list == new_expected
        os.remove(temp_list)

        
    def test_add_task(self):
        temp_list = ".temp_test.txt"
        shutil.copyfile(test_file, temp_list)
        todo.TASK_FILE = temp_list
        todo.add_task("Item 6")
        task_list = todo.list_tasks()

        expected_list ="1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5\n6. Item 6"
        assert task_list == expected_list
        os.remove(temp_list)
        
    def test_main(self):

        temp_list = ".tasks.txt"
        shutil.copyfile(test_file, temp_list)
        todo.TASK_FILE = temp_list
        
        from subprocess import run
        result = run(["python3","todo.py","-l"], capture_output=True, check=True)
        assert len(result.stdout) == 50
        expected_list ="1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5\n"
        assert result.stdout.decode('UTF-8') == expected_list
        
        from subprocess import run
        result = run(["python3","todo.py","-a", "Item 6"], capture_output=True, check=True)
        assert len(result.stdout) == 0

        from subprocess import run
        result = run(["python3","todo.py","-l"], capture_output=True, check=True)
        assert len(result.stdout) == 60
        expected_list ="1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5\n6. Item 6\n"
        assert result.stdout.decode('UTF-8') == expected_list


        from subprocess import run
        result = run(["python3","todo.py","-r","6"], capture_output=True, check=True)
        assert len(result.stdout) < 40

        from subprocess import run
        result = run(["python3","todo.py","-l"], capture_output=True, check=True)
        assert len(result.stdout) == 50
        expected_list ="1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5\n"
        assert result.stdout.decode('UTF-8') == expected_list


        os.remove(temp_list)

  
    def test_lint(self):
        files =  ["todo.py"]
        #pylint_options = ["--disable=line-too-long,import-error,fixme"]
        pylint_options = []

        report = CollectingReporter()
        result = Run(
                    files,
                    reporter=report,
                    exit=False,
                )
        score = result.linter.stats.global_note
        nErrors = len(report.messages)

        print("Score: " + str(score))
        line_format = "{path}:{line}:{column}: {msg_id}: {msg} ({symbol})"
        for error in report.messages:
            print(line_format.format(**asdict(error)))   

        assert nErrors < 500
        assert nErrors < 400
        assert nErrors < 250
        assert nErrors < 100
        assert nErrors < 50
        assert nErrors < 10
        assert nErrors == 0
        assert score > 3
        assert score > 5
        assert score > 7
        assert score > 9


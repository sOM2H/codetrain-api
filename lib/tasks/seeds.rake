task :seeds => [:environment] do
  code_train = Organization.find_or_create_by!(name: 'CodeTrain') 
  organization = Organization.find_or_create_by!(name: 'Test organization')
  contest = Contest.find_or_create_by!(title: "Winter Coding Contest") do |c|
    c.organization_id = organization.id
    c.description = 'Winter Coding Contest'
  end
 
  admin = User.find_or_create_by!(login: 'admin') do |user|
    user.organization_id = code_train.id
    user.full_name = 'ADMIN'
    user.password = '123123123'
  end
  admin.add_role :admin

  teacher = User.find_or_create_by!(login: 'teacher') do |user|
    user.organization_id = organization.id
    user.full_name = 'TEACHER'
    user.password = '123123123'
  end
  teacher.add_role :teacher

  student = User.find_or_create_by!(login: 'student') do |user|
    user.organization_id = organization.id
    user.full_name = 'Stutend Abu'
    user.password = '123123123'
  end
  student.add_role :student

  student2 = User.find_or_create_by!(login: 'student2') do |user|
    user.organization_id = organization.id
    user.full_name = 'Stutend Dabi'
    user.password = '123123123'
  end
  student2.add_role :student
 
  student3 = User.find_or_create_by!(login: 'student3') do |user|
    user.organization_id = organization.id
    user.full_name = 'Stutend lala'
    user.password = '123123123'
  end
  student3.add_role :student

  student4 = User.find_or_create_by!(login: 'student4') do |user|
    user.organization_id = organization.id
    user.full_name = 'Stutend bobo'
    user.password = '123123123'
  end
  student4.add_role :student

  student5 = User.find_or_create_by!(login: 'student5') do |user|
    user.organization_id = organization.id
    user.full_name = 'Stutend dudu'
    user.password = '123123123'
  end
  student5.add_role :student

  contest.users << student
  contest.users << student2
  contest.users << student3
  contest.users << student4
  contest.users << student5

  # Languages
  languages = [
    {
      name: "Ruby 2.5.1",
      css_name: "ruby",
      compiler: "RubyCompiler",
      placeholder: <<~CODE
        a = gets.to_i
        b = gets.to_i
        puts a + b
      CODE
    },
    {
      name: "Python 3.6",
      css_name: "python",
      compiler: "PythonCompiler",
      placeholder: <<~CODE
        a = int(input())
        b = int(input())
        print(a+b)
      CODE
    },
    {
      name: "PHP 7.2.24",
      css_name: "php",
      compiler: "PhpCompiler",
      placeholder: <<~CODE
        <?php
          $file = 'input.txt';
          $fh = fopen($file, 'r');
          $a = (int)fgets($fh);
          $b = (int)fgets($fh);
          echo $a+$b;
        ?>
      CODE
    },
    {
      name: "Node 8.10.0",
      css_name: "js",
      compiler: "JsCompiler",
      placeholder: <<~CODE
        const fs = require('fs')
        let text = fs.readFileSync('input.txt','utf8')
        let arr = text.split('\\n')
        console.log(Number(arr[0]) + Number(arr[1]))
      CODE
    },
    {
      name: "Java 11.0.19",
      css_name: "java",
      compiler: "JavaCompiler",
      placeholder: <<~CODE
        import java.io.*;
        import java.util.*;
        public class Main{
          public static void main (String args[]) throws Exception{
            BufferedReader stdin =
              new BufferedReader(
                new InputStreamReader(System.in));
            String line = stdin.readLine();
            String line1 = stdin.readLine();
            int a = Integer.parseInt(line);
            int b = Integer.parseInt(line1);
            System.out.println(a+b);
          }
        }
      CODE
    },
    {
      name: "Go 1.10.4",
      css_name: "go",
      compiler: "GoCompiler",
      placeholder: <<~CODE
        package main
        import "fmt"
        func main() {
          var a int
          var b int
          fmt.Scan(&a)
          fmt.Scan(&b)
          fmt.Println(a+b)
        }
      CODE
    },
    {
      name: "C++ 14",
      css_name: "cpp",
      compiler: "CppCompiler",
      placeholder: <<~CODE
        #include <iostream>

        using namespace std;

        int main(){
          int a, b;
          cin >> a >> b;
          cout << a + b << endl;

          return 0;
        }
      CODE
    }
  ]

  languages.each do |language|
    Language.find_or_create_by!(name: language[:name]) do |lang|
      lang.css_name = language[:css_name]
      lang.compiler = language[:compiler]
      lang.placeholder = language[:placeholder]
    end
  end

  # Tags
  ['For Beginners', 'Algorithms', 'Data Structures', 'Graph Theory',
   'Mathematics', 'String Processing', 'Game Theory'].each do |name|
    Tag.find_or_create_by!(name: name)
  end

  # Problems
  # =========
  problem = Problem.find_or_create_by!(title: "A + B") do |prob|
    prob.description = "Write a program that takes two integers A and B as input and calculates their sum."
    prob.complexity = 1
  end
  contest.problems << problem

  # Link Problem to Tag
  tag = Tag.find_by(name: 'For Beginners')
  ProblemTag.find_or_create_by!(problem:, tag:) if tag

  # Tests
  tests = [
    { input: "1\n2", output: "3" },
    { input: "4\n4", output: "8" },
    { input: "0\n0", output: "0" }
  ]

  tests.each do |test|
    Test.find_or_create_by!(problem:, input: test[:input]) do |t|
      t.output = test[:output]
    end
  end
  # =========

  # =========
  problem = Problem.find_or_create_by!(title: "Welcome Message Generator") do |prob|
    prob.description = "Create a program that asks the user for their name and outputs a personalized welcome message. If the input is empty, prompt the user again until they provide a valid name."
    prob.complexity = 1
  end
  contest.problems << problem

  # Link Problem to Tag
  tag = Tag.find_by(name: 'For Beginners')
  ProblemTag.find_or_create_by!(problem:, tag:) if tag

  # Tests
  tests = [
    { input: "Alice", output: "Hello, Alice! Welcome to the world of programming!" },
    { input: "Bob", output: "Hello, Bob! Welcome to the world of programming!" },
    { input: "John Doe", output: "Hello, John Doe! Welcome to the world of programming!" }
  ]

  tests.each do |test|
    Test.find_or_create_by!(problem:, input: test[:input]) do |t|
      t.output = test[:output]
    end
  end
  # =========

  # =========
  problem = Problem.find_or_create_by!(title: "Sort Implementation") do |prob|
    prob.description = "Implement the Sort algorithm to sort an array of numbers in ascending order."
    prob.complexity = 1
  end
  contest.problems << problem

  # Link Problem to Tag
  tag = Tag.find_by(name: 'Algorithms')
  ProblemTag.find_or_create_by!(problem:, tag:) if tag

  # Tests
  tests = [
    { input: "5 3 8 6 2", output: "2 3 5 6 8" },
    { input: "1 2 3 4 5", output: "1 2 3 4 5" },
    { input: "9 -3 0 7 4", output: "-3 0 4 7 9" }
  ]

  tests.each do |test|
    Test.find_or_create_by!(problem:, input: test[:input]) do |t|
      t.output = test[:output]
    end
  end
  # =========

  # =========
  problem = Problem.find_or_create_by!(title: "Stack and Bracket Validator") do |prob|
    prob.description = "Implement a stack structure and use it to validate if a string of brackets is balanced."
    prob.complexity = 3
  end

  # Link Problem to Tag
  tag = Tag.find_by(name: 'Data Structures')
  ProblemTag.find_or_create_by!(problem:, tag:) if tag

  # Tests
  tests = [
    { input: "([{}])", output: "Valid" },
    { input: "([)]", output: "Invalid" },
    { input: "((()))", output: "Valid" }
  ]

  tests.each do |test|
    Test.find_or_create_by!(problem:, input: test[:input]) do |t|
      t.output = test[:output]
    end
  end
  # =========

  # =========
  problem = Problem.find_or_create_by!(title: "Least Common Multiple (LCM) Calculator") do |prob|
    prob.description = "Write a program to calculate the Least Common Multiple (LCM) of two integers."
    prob.complexity = 1
  end

  # Link Problem to Tag
  tag = Tag.find_by(name: 'Mathematics')
  ProblemTag.find_or_create_by!(problem:, tag:) if tag

  # Tests
  tests = [
    { input: "12 15", output: "60" },
    { input: "9 6", output: "18" },
    { input: "7 5", output: "35" }
  ]

  tests.each do |test|
    Test.find_or_create_by!(problem:, input: test[:input]) do |t|
      t.output = test[:output]
    end
  end
  # =========

  # =========
  problem = Problem.find_or_create_by!(title: "Character Frequency Counter") do |prob|
    prob.description = "Write a program to count the frequency of each character in a string, considering case sensitivity."
    prob.complexity = 2
  end

  # Link Problem to Tag
  tag = Tag.find_by(name: 'String Processing')
  ProblemTag.find_or_create_by!(problem:, tag:) if tag

  # Tests
  tests = [
    { input: "Hello", output: "H: 1\ne: 1\nl: 2\no: 1" },
    { input: "Programming", output: "P: 1\nr: 2\no: 1\ng: 2\na: 1\nm: 2\ni: 1\nn: 1" },
    { input: "AaBbCc", output: "A: 1\na: 1\nB: 1\nb: 1\nC: 1\nc: 1" }
  ]

  tests.each do |test|
    Test.find_or_create_by!(problem:, input: test[:input]) do |t|
      t.output = test[:output]
    end
  end
  # =========
end
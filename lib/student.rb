class Student
  #DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize (name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
        CREATE TABLE IF NOT EXISTS students(
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade TEXT)
        SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
        DROP TABLE students
        SQL
      DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
        SQL
      DB[:conn].execute(sql, self.name, self.grade)
      # binding.pry
      @id = DB[:conn].execute("SELECT id FROM students WHERE name = ?", self.name).flatten[0]

    # Use bound paremeters to pass the given student's name and grade into the SQL statement. Remember that you don't need to insert a value for the id column. Because it is the primary key, the id column's value will be automatically assigned. However, at the end of your #save method, you do need to grab the ID of the last inserted row, i.e. the row you just inserted into the database, and assign it to the be the value of the @id attribute of the given instance.
  end

  def self.create(student_hash)
    #{:name=>"Sally", :grade=>"10th"}
    student = Student.new(student_hash[:name], student_hash[:grade])
    student.save
    student
  end

end

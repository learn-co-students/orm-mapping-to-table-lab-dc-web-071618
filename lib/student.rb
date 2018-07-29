class Student
#First create the Class and attibutes
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id
#initialize the class
  def initialize(name, grade, id=nil)
    # Text shows including id in the initialize
    @id = id
    @name = name
    @grade = grade
  end
#create the data table in SQL
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
  DB[:conn].execute(sql)
  end
#drop table in SQL
def self.drop_table
  sql =<<-SQL
    DROP TABLE IF EXISTS students
    SQL
  DB[:conn].execute(sql)
end

#save table and create a new row
def save
  sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL
  DB[:conn].execute(sql, self.name, self.grade)

  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

end

def self.create(name:, grade:)
  student = Student.new(name, grade)
  student.save
  student
end



end #close Student Class

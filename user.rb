require_relative "./database_ops.rb"

class User

  include DatabaseOps

  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM users")
    results.map { |result| User.new(result) }
  end

  attr_accessor :id, :fname, :lname, :table_name

  def initialize(options = {})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
    @table_name = "users"
  end

  # def create
  #   raise "already saved!" unless self.id.nil?
  #   QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
  #   INSERT INTO
  #     users (fname, lname)
  #   VALUES
  #     (?,?)
  #   SQL
  #
  #   @id = QuestionsDatabase.instance.last_insert_row_id
  # end

  # def save
  #   save_op("users")
  # end

  def first_name
    @fname
  end

  def last_name
    @lname
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(self.id)
  end



  def self.find_by_id(num)
    results = QuestionsDatabase.instance.execute(<<-SQL, num)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
         (fname = ? AND lname = ?)
    SQL

    results.map { |result| User.new(result) }
  end

  def authored_questions
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        questions
      WHERE
         (user_id = ?)
    SQL

    results.map { |result| Question.new(result) }

  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        CAST ( COUNT(question_id) as FLOAT ) / COUNT(DISTINCT(question_id)) as ave_karma
      FROM
        questions JOIN question_likes ON questions.id = question_id
      WHERE
         (user_id = ?)
      GROUP BY user_id
    SQL

    results[0]["ave_karma"]

  end
  #
  #
  # def save
  #   if self.id.nil?
  #     create
  #   else
  #     update
  #   end
  # end
  #
  #
  # def update
  #   results = QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
  #     UPDATE users
  #     SET fname = ?, lname = ?
  #     WHERE id = ?
  #   SQL
  #
  #   self.id
  # end

end
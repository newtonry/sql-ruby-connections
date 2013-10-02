require_relative "./database_ops.rb"


class Question

  include DatabaseOps

  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    results.map { |result| Question.new(result) }
  end

  attr_accessor :id, :title, :body, :user_id, :table_name

  def initialize(options = {})
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
    @table_name = "questions"
  end

  # def create
  #   raise "already saved!" unless self.id.nil?
  #   QuestionsDatabase.instance.execute(<<-SQL, id, title, body, user_id)
  #   INSERT INTO
  #     questions (id, title, body, user_id)
  #   VALUES
  #     (?,?,?,?)
  #   SQL
  #
  #   @id = QuestionsDatabase.instance.last_insert_row_id
  # end

 #  def save
 #
 #    # column_vals = [@title, @body, @user_id]
 # #    columns = ["title", "body", "user_id"]
 #    save_op("questions")
 #  end


  def question_title
    @title
  end

  def question_author
    @user_id
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollower.followers_for_question_id(self.id)
  end

  def self.find_by_id(num)
    results = QuestionsDatabase.instance.execute(<<-SQL, num)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.find_by_title(title)
    results = QuestionsDatabase.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
         (title = ?)
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
         (user_id = ?)
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end




end
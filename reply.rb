require_relative "./database_ops.rb"

class Reply
  include DatabaseOps

  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    results.map { |result| Reply.new(result) }
  end

  attr_accessor :id, :subject_question_id, :user_id, :parent_reply_id, :reply_body, :table_name

  def initialize(options = {})
    @id = options["id"]
    @user_id = options["user_id"]
    @parent_reply_id = options["parent_reply_id"]
    @subject_question_id = options["subject_question_id"]
    @reply_body = options["reply_body"]
    @table_name = "replies"
  end

  # def create
  #   raise "already saved!" unless self.id.nil?
  #   QuestionsDatabase.instance.execute(<<-SQL, subject_question_id, user_id, parent_reply_id, reply_body)
  #   INSERT INTO
  #     replies (subject_question_id, user_id, parent_reply_id, reply_body)
  #   VALUES
  #     (?,?,?,?)
  #   SQL
  #
  #   @id = QuestionsDatabase.instance.last_insert_row_id
  # end

  # def save
 #    save_op("replies")
 #  end

  def author
    @user_id
  end

  def question
    @subject_question_id
  end

  def parent_reply
    @parent_reply_id
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end


  def self.find_by_question_id(q_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT
        *
      FROM
        replies
      WHERE
        subject_question_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  def self.find_by_user_id(u_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end





  def self.find_by_id(num)
    results = QuestionsDatabase.instance.execute(<<-SQL, num)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end

  # def self.find_by_title(title)
 #    results = QuestionsDatabase.instance.execute(<<-SQL, title)
 #      SELECT
 #        *
 #      FROM
 #        questions
 #      WHERE
 #         (title = ?)
 #    SQL
 #
 #    results.map { |result| Question.new(result) }
 #  end

end

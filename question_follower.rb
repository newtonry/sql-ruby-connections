class QuestionFollower
  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM question_followers")
    results.map { |result| QuestionFollower.new(result) }
  end

  attr_accessor :id, :follower_id, :question_id

  def initialize(options = {})
    @id = options["id"]
    @follower_id = options["follower_id"]
    @question_id = options["question_id"]
  end

  def create
    raise "already saved!" unless self.id.nil?
    QuestionsDatabase.instance.execute(<<-SQL, follower_id, question_id)
    INSERT INTO
      question_followers (follower_id, question_id)
    VALUES
      (?,?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def self.find_by_id(num)
    results = QuestionsDatabase.instance.execute(<<-SQL, num)
      SELECT
        *
      FROM
        question_followers
      WHERE
        id = ?
    SQL

    results.map { |result| QuestionFollower.new(result) }
  end

  def self.followers_for_question_id(q_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT
        *
      FROM
        users JOIN question_followers ON users.id = follower_id
      WHERE
        question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(u_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT
        *
      FROM
        questions JOIN question_followers ON questions.id = question_id
      WHERE
        user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions JOIN question_followers ON questions.id = question_id
      GROUP BY question_id
      ORDER BY COUNT(1) DESC
    SQL

    results[0...n].map { |result| Question.new(result) }
  end


end
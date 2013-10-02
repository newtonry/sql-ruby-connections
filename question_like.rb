class QuestionLike

  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    results.map { |result| QuestionLike.new(result) }
  end

  attr_accessor :id, :liker_id, :question_id

  def initialize(options = {})
    @id = options["id"]
    @liker_id = options["liker_id"]
    @question_id = options["question_id"]
  end

  def create
    raise "already saved!" unless self.id.nil?
    QuestionsDatabase.instance.execute(<<-SQL, liker_id, question_id)
    INSERT INTO
      question_likes (liker_id, question_id)
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
        question_likes
      WHERE
        id = ?
    SQL

    results.map { |result| QuestionLike.new(result) }
  end

  def self.likers_for_question_id(q_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT
        *
      FROM
        users JOIN question_likes ON users.id = liker_id
      WHERE
        question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(q_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT
        COUNT(question_id) as num_likes
      FROM
        users JOIN question_likes ON users.id = liker_id
      WHERE
        question_id = ?
    SQL
    results[0]["num_likes"]
  end

  def self.liked_questions_for_user_id(u_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, u_id)
      SELECT
        *
      FROM
        questions JOIN question_likes ON questions.id = question_id
      WHERE
        liker_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions JOIN question_likes ON questions.id = question_id
      GROUP BY question_id
      ORDER BY COUNT(1) DESC
    SQL

    results[0...n].map { |result| Question.new(result) }
  end

end
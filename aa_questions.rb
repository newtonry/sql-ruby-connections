require 'singleton'
require 'sqlite3'
require_relative './user.rb'
require_relative './question.rb'
require_relative './question_follower.rb'
require_relative './reply.rb'
require_relative './question_like.rb'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("test.db")

    self.results_as_hash = true
    self.type_translation = true
  end
end


# p Reply.all[0].child_replies
#
# p User.all[2].authored_replies
# p QuestionFollower.followers_for_question_id(2)
# p QuestionFollower.followed_questions_for_user_id(1)
#p Question.all[1].replies

# p Question.all[1].followers
# p User.all[0].followed_questions


#QuestionFollower.most_followed_questions(2).each {|x| p x}

# p Question.most_followed(2)

# p QuestionLike.likers_for_question_id(1)
# p QuestionLike.num_likes_for_question_id(1)
#p QuestionLike.liked_questions_for_user_id(2)
# p Reply.find_by_question_id(2)

# p User.all
# u = User.new({"fname" => "Anna", "lname" => "Lewis"})
# u.create
# p u

# p Users.all[2].first_name
# p Users.all[2].last_name
# p Users.find_by_id(2)
# p Users.find_by_name("Kush", "Patel")

# p Question.all
# p Question.all.length
# p Question.all[1].question_title
# p Question.find_by_id(2)
# p Question.find_by_title("Can we live on site?")
#

# p QuestionFollower.all

# p Reply.all
# p Reply.find_by_id(1)

# p QuestionLike.all
# p QuestionLike.find_by_id(1)


#p Question.all[1].likers
#p Question.all[0].num_likes
#p User.all[0].liked_questions

people = User.all
people[2].fname = "Chris"
p people[2].first_name
p people[2].save

guy = User.new({"fname" => "The", "lname" => "Gal" })
p guy.save
#
p User.all

p QuestionLike.most_liked_questions(1)

responses = Reply.all
responses[0].reply_body = "No. Don't ask stupid questions."

p responses[0].save

silly_answer = Reply.new({"user_id" => 0, "parent_reply_id" => "NULL", "subject_question_id" => 1, "reply_body" => "Ask a stupid question, get a stupid answer"})
p silly_answer.save
#
p Reply.all


questions = Question.all
questions[0].title = "Why is the sky blue?"
questions[0].save
Question.all

silly_q = Question.new({"title" => "Why is the ground brown?", "body" => "its just so brown. whwy?", "user_id" => 1})
silly_q.save
#
Question.all

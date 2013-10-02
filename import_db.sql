CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
	lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
	body TEXT NOT NULL,
	user_id INTEGER NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
	id INTEGER PRIMARY KEY,
	follower_id INTEGER NOT NULL,
	question_id INTEGER NOT NULL,
	FOREIGN KEY (follower_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id)
	-- questions JOIN users ON users.id = user_id
);
--
CREATE TABLE replies (
	id INTEGER PRIMARY KEY,
	subject_question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,
	parent_reply_id INTEGER,
	reply_body TEXT NOT NULL,


	FOREIGN KEY (subject_question_id) REFERENCES questions(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
	id INTEGER PRIMARY KEY,
	liker_id INTEGER NOT NULL,
	question_id INTEGER NOT NULL,
	FOREIGN KEY (liker_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Ned', 'Ruggeri'),
  ('Ryan', 'Sepassi'),
	('Kush', 'Patel');


INSERT INTO
  questions (title, body, user_id)
VALUES
  ('When does AA start???', 'I rreally would like to know so I can plan random happenings.', (SELECT id FROM users WHERE fname = 'Kush')),
  ("Can we live on site?", "It's cheap and smelly, but would save me a lot of money. Is it possible?", (SELECT id FROM users WHERE fname = 'Ned')),
  ("Will we get a job?", "I will probably cry if not", (SELECT id FROM users WHERE fname = 'Ned'));

INSERT INTO
question_followers (follower_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Kush'), (SELECT id FROM questions WHERE title = 'Can we live on site?')),
	((SELECT id FROM users WHERE fname = 'Ned'), (SELECT id FROM questions WHERE title = 'Can we live on site?')),

	((SELECT id FROM users WHERE fname = 'Ryan'), (SELECT id FROM questions WHERE title = 'When does AA start???'));


INSERT INTO
replies (subject_question_id, user_id, parent_reply_id, reply_body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Can we live on site?'), (SELECT id FROM users WHERE fname = 'Ryan'), NULL, 'Yes, but you have to take out trash'),
	((SELECT id FROM questions WHERE title = 'Can we live on site?'), (SELECT id FROM users WHERE fname = 'Kush'), 1, 'Yes, but you can not shower');

INSERT INTO
question_likes (question_id, liker_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'When does AA start???'), (SELECT id FROM users WHERE fname = 'Ryan')),
	((SELECT id FROM questions WHERE title = 'When does AA start???'), (SELECT id FROM users WHERE fname = 'Kush')),
	((SELECT id FROM questions WHERE title = 'When does AA start???'), (SELECT id FROM users WHERE fname = 'Ned')),

	((SELECT id FROM questions WHERE title = 'Can we live on site?'), (SELECT id FROM users WHERE fname = 'Kush')),
	((SELECT id FROM questions WHERE title = 'Can we live on site?'), (SELECT id FROM users WHERE fname = 'Ned')),

	((SELECT id FROM questions WHERE title = 'Will we get a job?'), (SELECT id FROM users WHERE fname = 'Ryan'));




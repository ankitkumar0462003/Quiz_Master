-- Run once in a NEW Oracle 26ai application schema (not SYS/SYSTEM).
CREATE TABLE users (user_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, full_name VARCHAR2(100) NOT NULL,email VARCHAR2(150) NOT NULL,password_hash VARCHAR2(200) NOT NULL,user_role VARCHAR2(10) DEFAULT 'STUDENT' NOT NULL,created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,CONSTRAINT uq_users_email UNIQUE(email),CONSTRAINT ck_users_role CHECK(user_role IN ('STUDENT','ADMIN')));
CREATE TABLE quizzes (quiz_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,title VARCHAR2(200) NOT NULL,duration_minutes NUMBER(4) NOT NULL,total_marks NUMBER(6) NOT NULL,created_by NUMBER NOT NULL,created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,CONSTRAINT fk_quiz_admin FOREIGN KEY(created_by) REFERENCES users(user_id),CONSTRAINT ck_quiz_duration CHECK(duration_minutes BETWEEN 1 AND 240),CONSTRAINT ck_quiz_marks CHECK(total_marks>0));
CREATE TABLE questions (question_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,quiz_id NUMBER NOT NULL,question_text VARCHAR2(2000) NOT NULL,option_a VARCHAR2(500) NOT NULL,option_b VARCHAR2(500) NOT NULL,option_c VARCHAR2(500) NOT NULL,option_d VARCHAR2(500) NOT NULL,correct_option CHAR(1) NOT NULL,marks NUMBER(5) DEFAULT 1 NOT NULL,CONSTRAINT fk_questions_quiz FOREIGN KEY(quiz_id) REFERENCES quizzes(quiz_id) ON DELETE CASCADE,CONSTRAINT ck_option CHECK(correct_option IN('A','B','C','D')),CONSTRAINT ck_qmarks CHECK(marks>0));
CREATE TABLE attempts (attempt_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,user_id NUMBER NOT NULL,quiz_id NUMBER NOT NULL,started_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,submitted_at TIMESTAMP,score NUMBER(8,2) DEFAULT 0 NOT NULL,attempt_status VARCHAR2(15) DEFAULT 'IN_PROGRESS' NOT NULL,CONSTRAINT fk_att_user FOREIGN KEY(user_id) REFERENCES users(user_id),CONSTRAINT fk_att_quiz FOREIGN KEY(quiz_id) REFERENCES quizzes(quiz_id),CONSTRAINT uq_once UNIQUE(user_id,quiz_id),CONSTRAINT ck_att_status CHECK(attempt_status IN('IN_PROGRESS','SUBMITTED','EXPIRED')),CONSTRAINT ck_att_score CHECK(score>=0));
CREATE TABLE answers (answer_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,attempt_id NUMBER NOT NULL,question_id NUMBER NOT NULL,selected_option CHAR(1),is_correct NUMBER(1) DEFAULT 0 NOT NULL,CONSTRAINT fk_ans_attempt FOREIGN KEY(attempt_id) REFERENCES attempts(attempt_id) ON DELETE CASCADE,CONSTRAINT fk_ans_question FOREIGN KEY(question_id) REFERENCES questions(question_id),CONSTRAINT uq_answer UNIQUE(attempt_id,question_id),CONSTRAINT ck_selected CHECK(selected_option IN('A','B','C','D')),CONSTRAINT ck_answer_correct CHECK(is_correct IN(0,1)));
CREATE INDEX idx_questions_quiz ON questions(quiz_id);
CREATE INDEX idx_attempts_quiz ON attempts(quiz_id);
CREATE INDEX idx_answers_question ON answers(question_id);
-- SHA256 demo accounts with random 16-byte salt in lowercase hex.
INSERT INTO users(full_name,email,password_hash,user_role) SELECT 'Quiz Administrator','admin@quiz.com',salt||':'||LOWER(RAWTOHEX(STANDARD_HASH(salt||':Admin@12345','SHA256'))),'ADMIN' FROM(SELECT LOWER(RAWTOHEX(SYS_GUID())) salt FROM dual);
INSERT INTO users(full_name,email,password_hash,user_role) SELECT 'Rahul Sharma','rahul@quiz.com',salt||':'||LOWER(RAWTOHEX(STANDARD_HASH(salt||':Student@123','SHA256'))),'STUDENT' FROM(SELECT LOWER(RAWTOHEX(SYS_GUID())) salt FROM dual);
INSERT INTO users(full_name,email,password_hash,user_role) SELECT 'Priya Singh','priya@quiz.com',salt||':'||LOWER(RAWTOHEX(STANDARD_HASH(salt||':Student@123','SHA256'))),'STUDENT' FROM(SELECT LOWER(RAWTOHEX(SYS_GUID())) salt FROM dual);
INSERT INTO quizzes(title,duration_minutes,total_marks,created_by) SELECT 'Java Programming Basics',10,5,user_id FROM users WHERE email='admin@quiz.com';
INSERT INTO questions(quiz_id,question_text,option_a,option_b,option_c,option_d,correct_option,marks) SELECT quiz_id,'Which keyword creates a class in Java?','class','define','struct','object','A',1 FROM quizzes WHERE title='Java Programming Basics';
INSERT INTO questions(quiz_id,question_text,option_a,option_b,option_c,option_d,correct_option,marks) SELECT quiz_id,'Which method starts a Java program?','start()','main()','run()','execute()','B',1 FROM quizzes WHERE title='Java Programming Basics';
INSERT INTO questions(quiz_id,question_text,option_a,option_b,option_c,option_d,correct_option,marks) SELECT quiz_id,'Which keyword is used for inheritance?','this','super','extends','implements','C',1 FROM quizzes WHERE title='Java Programming Basics';
INSERT INTO questions(quiz_id,question_text,option_a,option_b,option_c,option_d,correct_option,marks) SELECT quiz_id,'Which is not a Java primitive type?','int','char','boolean','String','D',1 FROM quizzes WHERE title='Java Programming Basics';
INSERT INTO questions(quiz_id,question_text,option_a,option_b,option_c,option_d,correct_option,marks) SELECT quiz_id,'What does JDBC stand for?','Java Database Connectivity','Java Data Compiler','Java Database Controller','Java Dynamic Connection','A',1 FROM quizzes WHERE title='Java Programming Basics';
COMMIT;


CREATE TABLE users (
    user_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(150) UNIQUE NOT NULL,
    password_hash VARCHAR2(200) NOT NULL,
    user_role VARCHAR2(10) DEFAULT 'STUDENT' NOT NULL,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT chk_user_role
        CHECK (user_role IN ('ADMIN', 'STUDENT'))
);

CREATE TABLE quizzes (
    quiz_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    duration_minutes NUMBER(4) NOT NULL,
    total_marks NUMBER(6) NOT NULL,
    created_by NUMBER NOT NULL,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT fk_quizzes_admin
        FOREIGN KEY (created_by)
        REFERENCES users(user_id),

    CONSTRAINT ck_quiz_duration
        CHECK (duration_minutes BETWEEN 1 AND 240),

    CONSTRAINT ck_quiz_marks
        CHECK (total_marks > 0)
);

CREATE TABLE questions (
    question_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quiz_id NUMBER NOT NULL,
    question_text VARCHAR2(2000) NOT NULL,
    option_a VARCHAR2(500) NOT NULL,
    option_b VARCHAR2(500) NOT NULL,
    option_c VARCHAR2(500) NOT NULL,
    option_d VARCHAR2(500) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    marks NUMBER(5) DEFAULT 1 NOT NULL,

    CONSTRAINT fk_question_quiz
        FOREIGN KEY (quiz_id)
        REFERENCES quizzes(quiz_id) ON DELETE CASCADE,

    CONSTRAINT ck_correct_option
        CHECK (correct_option IN ('A','B','C','D')),

    CONSTRAINT ck_question_marks
        CHECK (marks > 0)
);

CREATE TABLE attempts (
    attempt_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id NUMBER NOT NULL,
    quiz_id NUMBER NOT NULL,
    started_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    submitted_at TIMESTAMP,
    score NUMBER(8,2) DEFAULT 0 NOT NULL,
    attempt_status VARCHAR2(15) DEFAULT 'IN_PROGRESS' NOT NULL,

    CONSTRAINT fk_attempt_user
        FOREIGN KEY (user_id) REFERENCES users(user_id),

    CONSTRAINT fk_attempt_quiz
        FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id),

    CONSTRAINT uq_one_attempt
        UNIQUE (user_id, quiz_id),

    CONSTRAINT ck_attempt_status
        CHECK (attempt_status IN
        ('IN_PROGRESS','SUBMITTED','EXPIRED')),

    CONSTRAINT ck_score CHECK (score >= 0)
);

CREATE TABLE answers (
    answer_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    attempt_id NUMBER NOT NULL,
    question_id NUMBER NOT NULL,
    selected_option CHAR(1),
    is_correct NUMBER(1) DEFAULT 0 NOT NULL,

    CONSTRAINT fk_answer_attempt
        FOREIGN KEY (attempt_id)
        REFERENCES attempts(attempt_id) ON DELETE CASCADE,

    CONSTRAINT fk_answer_question
        FOREIGN KEY (question_id)
        REFERENCES questions(question_id),

    CONSTRAINT uq_attempt_question
        UNIQUE (attempt_id, question_id),

    CONSTRAINT ck_selected_option
        CHECK (selected_option IN ('A','B','C','D')),

    CONSTRAINT ck_is_correct
        CHECK (is_correct IN (0,1))
);

SELECT table_name
FROM user_tables
WHERE table_name IN (
    'USERS',
    'QUIZZES',
    'QUESTIONS',
    'ATTEMPTS',
    'ANSWERS'
)
ORDER BY table_name;

SELECT user_id, full_name, email, user_role
FROM users;

UPDATE users
SET user_role = 'ADMIN'
WHERE user_id = 2
  AND email = 'ankitkumar0462003@gmail.com';

COMMIT;
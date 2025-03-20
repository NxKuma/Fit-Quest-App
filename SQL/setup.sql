DROP TABLE logininfo;
DROP TABLE guild;
DROP TABLE person;
DROP TABLE challenge_instance;
DROP TABLE workout_instance;
DROP TABLE 3d_avatar;
DROP TABLE streak;
DROP TABLE currency;
DROP TABLE badge;
DROP TABLE experience;
DROP TABLE rewards;

CREATE TABLE person (
    person_id SERIAL PRIMARY KEY,
    person_height_m REAL NOT NULL,
    person_weight_kg REAL NOT NULL,
    person_bmi REAL GENERATED ALWAYS AS (person_weight_kg / (person_height_m * person_height_m)) STORED,
    activity_level VARCHAR(50) NOT NULL
);

CREATE TABLE logininfo (
    info_id SERIAL PRIMARY KEY,
    hashed_username INT NOT NULL,
    hashed_password INT NOT NULL
);

CREATE TABLE guild (
    guild_id INT PRIMARY KEY,
    guild_name VARCHAR(50) NOT NULL
);

CREATE TABLE streak(
    streak_id SERIAL NOT NULL,
    streak_date_start DATE,
    streak_current_date DATE,
    streak_multiplier REAL,
    streak_days INT
);

CREATE TABLE experience (
    experience_id SERIAL NOT NULL,
    experience_amount INT,
    experience_limit INT,
    experience_multiplier REAL
);

CREATE TABLE currency (
    currency_id SERIAL NOT NULL,
    current_amount INT
);

CREATE TABLE badge (
    badge_id SERIAL NOT NULL,
    badge_name VARCHAR(50),
    badge_unlocked BOOLEAN
);


CREATE TABLE rewards(
    reward_id SERIAL PRIMARY KEY,
    reward_amount INT,
    current_id INT NOT NULL,
    badge_id INT NOT NULL,
    is_claimed BOOLEAN,
    is_available BOOLEAN
);
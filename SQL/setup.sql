DROP TABLE person;
DROP TABLE avatar;
DROP TABLE logininfo;
DROP TABLE guild;
DROP TABLE challenge_instance;
DROP TABLE workout_instance;
DROP TABLE streak;
DROP TABLE currency;
DROP TABLE badge;
DROP TABLE experience;
DROP TABLE rewards;

CREATE TABLE logininfo (
    info_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    pass VARCHAR(50) NOT NULL
);

CREATE TABLE avatar (
    avatar_id SERIAL PRIMARY KEY,
    shoulder_param REAL NOT NULL,
    arms_param REAL NOT NULL,
    breasts_param REAL NOT NULL,
    torso_param REAL NOT NULL,
    belly_param REAL NOT NULL,
    hips_param REAL NOT NULL,
    legs_param REAL NOT NULL
);


CREATE TABLE person (
    person_id SERIAL PRIMARY KEY,
    person_height_m REAL NOT NULL,
    person_weight_kg REAL NOT NULL,
    person_bmi REAL GENERATED ALWAYS AS (person_weight_kg / (person_height_m * person_height_m)) STORED,
    logininfo_id SERIAL REFERENCES logininfo(info_id),
    avatar_id SERIAL REFERENCES avatar(avatar_id)
);

INSERT INTO logininfo (username, pass) VALUES ('thanie', 'thanie');
-- CREATE TABLE guild (
--     guild_id INT PRIMARY KEY,
--     guild_name VARCHAR(50) NOT NULL
-- );

-- CREATE TABLE streak(
--     streak_id SERIAL NOT NULL,
--     streak_date_start DATE,
--     streak_current_date DATE,
--     streak_multiplier REAL,
--     streak_days INT
-- );

-- CREATE TABLE experience (
--     experience_id SERIAL NOT NULL,
--     experience_amount INT,
--     experience_limit INT,
--     experience_multiplier REAL
-- );

-- CREATE TABLE currency (
--     currency_id SERIAL NOT NULL,
--     current_amount INT
-- );

-- CREATE TABLE badge (
--     badge_id SERIAL NOT NULL,
--     badge_name VARCHAR(50),
--     badge_unlocked BOOLEAN
-- );


-- CREATE TABLE rewards(
--     reward_id SERIAL PRIMARY KEY,
--     reward_amount INT,
--     current_id INT NOT NULL,
--     badge_id INT NOT NULL,
--     is_claimed BOOLEAN,
--     is_available BOOLEAN
-- );
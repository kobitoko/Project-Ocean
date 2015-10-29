DROP TABLE salts;

/*
 * To store user info
 * role: 'a'->administrator
 * role: 'd'->data curator
 * role: 's'->scientist
 
CREATE TABLE users (
    user_name           varchar(32),
    password            varchar(32),
    role                char(1),
    person_id           int,
    date_registered     date,
    CHECK (role in ('a', 'd', 's')),
    PRIMARY KEY(user_name),
    FOREIGN KEY(person_id) REFERENCES persons
) tablespace c391ware;
*/

CREATE TABLE salts (
    user_name   varchar(32),
    salt        varchar(32) NOT NULL,
    PRIMARY KEY(user_name),
    FOREIGN KEY(user_name) REFERENCES users
) tablespace c391ware;

commit;

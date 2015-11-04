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
/* create default admin with password admin */
insert into users (user_name, password, role) values ('admin', '4CF49155816C245A106D80D64123BAE9', 'a');
insert into salts (user_name, salt) values ('admin', 'A48E8B18189B4FB6691A56E1575D2280');

commit;

DROP TABLE salts;

/*
 * To store user info
 * role: 'a'->administrator
 * role: 'd'->data curator
 * role: 's'->scientist
 
 CREATE TABLE persons (
       person_id int,
       first_name varchar(24),
       last_name  varchar(24),
       address    varchar(128),
       email      varchar(128),
       phone      char(10),
       PRIMARY KEY(person_id),
       UNIQUE (email)
) tablespace c391ware;

 
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

/* create default admin person with password admin */

insert into persons (person_id, first_name, last_name, address, email, phone) values (2012, 'admin', 'administrator', 'cyberspace', 'admin@admins.com', '1234567890');

insert into users (user_name, password, role, person_id) values ('admin', '4CF49155816C245A106D80D64123BAE9', 'a', 2012);
insert into salts (user_name, salt) values ('admin', 'A48E8B18189B4FB6691A56E1575D2280');

commit;

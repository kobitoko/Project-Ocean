/* Drop table salts before setup.sql, because otherwise setup.sql cannot drop users table due to having it's key as foreign key in the salts table. */
DROP TABLE salts;


CREATE TABLE salts (
    user_name   varchar(32),
    salt        varchar(32) NOT NULL,
    PRIMARY KEY(user_name),
    FOREIGN KEY(user_name) REFERENCES users
) tablespace c391ware;

/* create default admin person with password admin */

insert into persons (person_id, first_name, last_name, address, email, phone) values (1, 'admin', 'administrator', 'cyberspace', 'admin@admins.com', '1234567890');

insert into users (user_name, password, role, person_id) values ('admin', '4CF49155816C245A106D80D64123BAE9', 'a', 1);
insert into salts (user_name, salt) values ('admin', 'A48E8B18189B4FB6691A56E1575D2280');

commit;

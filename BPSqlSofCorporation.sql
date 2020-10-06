-- Матеја Вујсић 617/2017
-- Предмет: Базе података; Тема: Софтверска кућа/корпорација/фирма
-- Јул 2020.
-- ================================================================
-- Иницијализација базе 

drop database if exists ProjekatSoftCorporation;
create database ProjekatSoftCorporation;
use ProjekatSoftCorporation;
-- ================================================================
set @@auto_increment_increment=1;

create table Zaposleni(ID int primary key auto_increment,
					   ime varchar(45) not null check(length(ime) > 0),
                       prezime varchar(45) not null check(length(prezime) > 0),
                       plata real default 0.0,
                       ziro_racun varchar(45),
                       stimulacija real default 0.0,
                       pozicija varchar(45),
                       IDOdeljenja int,
                       IDFirme int) charset utf8mb4 auto_increment=100;

create table Firma(IDFirme int primary key auto_increment,
				   ime varchar(45) not null check(length(ime) > 0),
                   drzava varchar(45) not null check(length(drzava) > 0),
                   grad varchar(45) not null check(length(grad) > 0),
                   ulica varchar(45) not null,
				   broj int default null) charset utf8mb4;

create table Ugovor(IDUgovora int primary key unique auto_increment,
					rok date,
                    oblast varchar(45),
                    vrednost real default 0.0,
                    datum_sklapanja date,
                    IDFirme int,
                    IDNarucioca int) charset utf8mb4;
                    
create table Projekat(IDProjekta int primary key auto_increment,
					  status varchar(45) constraint status_projekta check(status in ('U RAZVOJU','ODRZAVANJE','VERIFIKACIJA','VALIDACIJA','ZAVRSEN')),
                      oblast varchar(45),
                      verzija varchar(45) default 'v0.0',
                      IDNarucioca int
                      )charset utf8mb4;
                      
create table Narucilac(IDNarucioca int primary key auto_increment,
					   email varchar(45),
                       ime varchar(45),
                       broj_telefona varchar(45),
                       fax varchar(45)
                       );
                       
create table Odeljenje(IDOdeljenja int primary key auto_increment,
					   naziv_odeljenja varchar(45),
					   rukovodilac int)charset utf8mb4;

create table RadiNaProjektu(IDProjekta int,
							IDOdeljenja int,
                            broj_sati int,
                            primary key(IDProjekta,IDOdeljenja)) charset utf8mb4;
-- drop table Inventar;
create table Inventar(IDInventara int primary key auto_increment,
naziv varchar(45) not null,
datum_nabavke date);

create table Dete(IDDeteta int primary key auto_increment,
ime varchar(45)  not null,
prezime varchar(45),
IDZaposlenog int,
foreign key(IDZaposlenog) references Zaposleni(ID));

create table Banka(IDBanke int primary key auto_increment,
naziv varchar(45));

create table FirmaDuguje(IDFirme int,
IDBanke int,
iznos real )charset utf8mb4;
-- Додавање различитих страних кључева
ALTER TABLE FirmaDuguje
ADD FOREIGN KEY (IDFirme) REFERENCES Firma(IDFirme);

ALTER TABLE FirmaDuguje
ADD FOREIGN KEY (IDBanke) REFERENCES Banka(IDBanke);

ALTER TABLE Zaposleni
ADD FOREIGN KEY (IDOdeljenja) REFERENCES Odeljenje(IDOdeljenja);

ALTER TABLE Zaposleni
ADD FOREIGN KEY (IDFirme) REFERENCES Firma(IDFirme);

ALTER TABLE Ugovor
ADD FOREIGN KEY (IDFirme) REFERENCES Firma(IDFirme);

ALTER TABLE Ugovor
ADD FOREIGN KEY (IDNarucioca) REFERENCES Narucilac(IDNarucioca);

ALTER TABLE Projekat
ADD FOREIGN KEY (IDNarucioca) REFERENCES Narucilac(IDNarucioca);

ALTER TABLE Odeljenje
ADD FOREIGN KEY (rukovodilac) REFERENCES Zaposleni(ID);

ALTER TABLE RadiNaProjektu
ADD FOREIGN KEY (IDProjekta) REFERENCES Projekat(IDProjekta);

ALTER TABLE RadiNaProjektu
ADD FOREIGN KEY (IDOdeljenja) REFERENCES Odeljenje(IDOdeljenja);

-- Убацивање податата у базу уз поштовање редоследа убацивања да не би дошло до одређених конфликта
INSERT INTO BANKA(naziv) VALUES
('BNP Paribas'),
('MMF'),
('Open sociaty fond');

INSERT INTO FIRMA(ime,drzava,grad,ulica,broj) VALUES ('MVSolution 2020 D.O.O.','Srbija','Kragujevac','Ilije Kolovica','44'),
													 ('MVIT Company 2020 S.P.A','Italija','Rim','Via Appia','32'),
                                                     ('MVIT','California','Cupertino','Silicon Valley','19');
select * from Firma;                                                     
INSERT INTO NARUCILAC(ime,email,broj_telefona,fax) VALUES ('Milanovic inzenjering D.O.O.','support@milanovic.com','034/242-234','034-242-234'),
														  ('KBC Kragujevac','kbc.kg@srb.gov.rs','034-211-211',NULL),
                                                          ('Katana D.O.O Kragujevac','katana@gmail.com','034-200-200',NULL),
                                                          ('Apple CA','apple.finances@apple.com','211-22-33',NULL),
                                                          ('Google IL','g@google.com','211-22-33',NULL),
                                                          ('Fiat Automotive Corp S.P.A','fiat.director@fiat.com','+380/343-234-34321',NULL),
                                                          ('Dolce Gabanna S.P.A','dolce@dolceitalia.com','+380/343-234-34321',NULL);
-- select * from Narucilac;
INSERT INTO PROJEKAT(status,oblast,verzija,IDNarucioca) VALUES ('U RAZVOJU','Korisnicki interfejs WWWW','v1.4',2),
															   ('VERIFIKACIJA','Autonomna voznja','v10.1',6),
                                                               ('ODRZAVANJE','SAJT-WWW','v3.0',2),
                                                               ('ZAVRSEN','Veb dizajn','v1.5',7),
                                                               ('U RAZVOJU','Nano-tech','v1.1',1),
                                                               ('VALIDACIJA','Potrosacka elektronika','v5.1',1),
                                                               ('U RAZVOJU','AI software face-recog','v10.10',4),
                                                               ('U RAZVOJU','GoogleCar','v6.11',5);
select * from projekat;
-- select * from projekat,narucilac where projekat.IDNarucioca=narucilac.IDNarucioca - jedna upit;

INSERT INTO UGOVOR(rok,oblast,vrednost,datum_sklapanja,IDFirme,IDNarucioca) VALUES ('2021-01-3','WWW',5000,'2020-01-03',2,2),
																				   ('2022-04-13','Electronic',25000,'2020-04-03',2,1),
                                                                                   ('2023-03-11','NanoTech',100000,'2020-03-11',4,1),
                                                                                   ('2022-05-10','WWW',45000,'2020-05-10',2,2),
                                                                                   ('2023-02-2','AIDrive',70000,'2020-02-02',2,6),
                                                                                   ('2020-04-13','WWW Design',10000,'2020-02-03',3,7),
                                                                                   ('2022-10-10','AI',250000,'2020-06-03',4,4),
                                                                                   ('2023-01-01','AI',400000,'2020-01-01',4,5);
                                                                                   
-- select * from ugovor;
INSERT INTO ODELJENJE(naziv_odeljenja,rukovodilac) values ('WWW dep.',NULL),
												('AI dep.',NULL),
                                                ('Design dep.',NULL),
                                                ('Electronic dep.',NULL),
                                                ('Finance dep.',NULL); 
select * from odeljenje;
INSERT INTO ZAPOSLENI(ime,prezime,plata,ziro_racun,pozicija,stimulacija,IDFirme,IDOdeljenja) VALUES
('Mateja','Vujsic',1000,'115-22424242-43','CEO',0.0,2,5),
('Nevena','Vujsic',900,'115-2424242-32','General Manager',50,2,5),
('Bosko','Vujsic',920,'115-2424252-32','CEO',100,2,5),
('Momcilo','Vujsic',830,'115-3423242-32','Electronic ing.',20,2,4),
('Slavomir','Vujsic',800,'115-1423242-32','Electronic ing.',20,2,4),
('Nikola','Kalabic',700,'112-3423242-32','Software ing.',10,2,4),
('Miloslav','Samardzic',800,'110-3423242-32','Electronic ing.',0.0,2,4),
('Momcilo','Djujic',5000,'114-3423242-32','Manager.',100,4,5),
('Mihajlo','Pupin',3000,'114-3421242-32','Software ing.',100,4,1),
('Nikola','Tesla',5000,'114-3429242-32','WWW developer.',100,4,1),
('Bogdan','Bogdanovic',4000,'112-3423242-32','AI developer.',100,4,2),
('Darko','Milicic',3050,'112-3423242-32','AI developer.',100,4,2),
('Kristijan','Deruo',3429,'113-345545400-11','Menager',0.0,3,5),
('Georgio','Armani',2000,'109-31234132-53','Designer',0.0,3,3),
('Luca','Cemiol',2000,'109-31234132-53','Designer',0.0,3,3);

-- select * from zaposleni;
-- Сада постављамо шефове одељења фирме.
update Odeljenje set rukovodilac=109 where IDOdeljenja=1;
update Odeljenje set rukovodilac=108 where IDOdeljenja=2;
update Odeljenje set rukovodilac=113 where IDOdeljenja=3;
update Odeljenje set rukovodilac=103 where IDOdeljenja=4;
update Odeljenje set rukovodilac=100 where IDOdeljenja=5;

INSERT INTO RadiNaProjektu(IDProjekta,IDODeljenja,broj_sati) values 
(1,1,45),
(2,2,403),
(2,4,201),
(3,1,343),
(4,3,43),
(5,4,311);

-- select * from RadiNaProjektu r


-- Query's : 
-- 1. Излистај све особе које раде у одређеном одељењну:
select ime,prezime,plata,naziv_odeljenja from Zaposleni z,Odeljenje o 
where o.IDOdeljenja=z.IDOdeljenja and o.IDOdeljenja=5;

-- 2.Излистај све особе које раде у фирми у Србији:
select z.ime,z.prezime,f.ime from zaposleni z inner join firma f
on z.IDFirme=f.IDFirme where f.drzava='Srbija'; 

-- 3. Ко управља којим одељењем?
select z.ime,z.prezime,o.naziv_odeljenja from Zaposleni z,Odeljenje o
where z.IDOdeljenja=o.IDOdeljenja and z.ID=o.rukovodilac;

-- 4. Сабери све плате радника.
select sum(plata) from Zaposleni;

-- 5. Уколико буде завршила на време све пројкете колико је фирма профитирала?
select sum(vrednost) as vrednost_u_evrima from Ugovor;
-- 6. Колико тренутно има активних пројеката(рецимо да се верификација и валидација не важе)
select count(status) as broj_aktivnih_p from Projekat p where p.status in ('Aktivan','U razvoju','Odrzavanje');
-- 7. Пример подупита: Где раде три најплаћенија радника?
select ime,prezime,o.naziv_odeljenja,plata as plata_u_evrima from Zaposleni z,Odeljenje o 
where
z.IDOdeljenja=o.IDOdeljenja and
ID in (select ID from Zaposleni order by plata desc) limit 3;


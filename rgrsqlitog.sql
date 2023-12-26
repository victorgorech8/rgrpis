
CREATE TABLE Договор
( 
	nom_договор            integer  NOT NULL ,
	Табельный_номер_сотрудника integer  NULL ,
	nom_заказа             integer  NULL ,
	Дата                 datetime  NULL 
)
go



ALTER TABLE Договор
	ADD CONSTRAINT XPKДоговор PRIMARY KEY  CLUSTERED (nom_договор ASC)
go



CREATE TABLE Журнал
( 
	nom_заказа             integer  NOT NULL ,
	Табельный_номер_сотрудника integer  NOT NULL ,
	Дата                 datetime  NULL 
)
go



ALTER TABLE Журнал
	ADD CONSTRAINT XPKЖурнал PRIMARY KEY  CLUSTERED (nom_заказа ASC)
go



CREATE TABLE Заказ
( 
	nom_заказа             integer  NOT NULL ,
	Код_клиента          integer  NULL ,
	Табельный_номер_сотрудника integer  NULL ,
	Дата                 datetime  NULL 
)
go



ALTER TABLE Заказ
	ADD CONSTRAINT XPKЗаказ PRIMARY KEY  CLUSTERED (nom_заказа ASC)
go



CREATE TABLE Клиент
( 
	Код_клиента          integer  NOT NULL ,
	Наименование_филиала varchar(50)  NULL ,
	БИК                  varchar(50)  NULL ,
	Счет_nom               varchar(50)  NULL ,
	ИНН                  varchar(50)  NULL ,
	КПП                  varchar(50)  NULL ,
	Юридическое_имя_клиента varchar(50)  NULL ,
	Телефон_клиента      varchar(50)  NULL ,
	Адрес_клиента        varchar(50)  NULL 
)
go



ALTER TABLE Клиент
	ADD CONSTRAINT XPKКлиент PRIMARY KEY  CLUSTERED (Код_клиента ASC)
go



CREATE TABLE Сотрудник
( 
	Табельный_номер_сотрудника integer  NOT NULL ,
	ФИО_сотрудника       varchar(50)  NULL ,
	Должность            varchar(50)  NULL 
)
go



ALTER TABLE Сотрудник
	ADD CONSTRAINT XPKСотрудник PRIMARY KEY  CLUSTERED (Табельный_номер_сотрудника ASC)
go



CREATE TABLE Счет_на_оплату
( 
	nom_счета_на_оплату    integer  NOT NULL ,
	nom_договор            integer  NULL ,
	Табельный_номер_сотрудника integer  NULL ,
	Дата                 datetime  NULL 
)
go



ALTER TABLE Счет_на_оплату
	ADD CONSTRAINT XPKСчет_на_оплату PRIMARY KEY  CLUSTERED (nom_счета_на_оплату ASC)
go



CREATE TABLE Услуга
( 
	Код_услуга           integer  NOT NULL ,
	Наименование         varchar(50)  NULL ,
	Цена                 float  NOT NULL 
)
go



ALTER TABLE Услуга
	ADD CONSTRAINT XPKУслуга PRIMARY KEY  CLUSTERED (Код_услуга ASC)
go



CREATE TABLE Услуга_в_договоре
( 
	nom_договор            integer  NOT NULL ,
	Код_услуга           integer  NOT NULL ,
	Количество           integer  NULL 
)
go



ALTER TABLE Услуга_в_договоре
	ADD CONSTRAINT XPKУслуга_в_договоре PRIMARY KEY  CLUSTERED (nom_договор ASC,Код_услуга ASC)
go



CREATE TABLE Услуга_в_заказе
( 
	nom_заказа             integer  NOT NULL ,
	Код_услуга           integer  NOT NULL ,
	Количество           integer  NULL 
)
go



ALTER TABLE Услуга_в_заказе
	ADD CONSTRAINT XPKУслуга_в_заказе PRIMARY KEY  CLUSTERED (nom_заказа ASC,Код_услуга ASC)
go




ALTER TABLE Договор
	ADD CONSTRAINT R_8 FOREIGN KEY (Табельный_номер_сотрудника) REFERENCES Сотрудник(Табельный_номер_сотрудника)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Договор
	ADD CONSTRAINT R_9 FOREIGN KEY (nom_заказа) REFERENCES Заказ(nom_заказа)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Журнал
	ADD CONSTRAINT R_6 FOREIGN KEY (nom_заказа) REFERENCES Заказ(nom_заказа)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Журнал
	ADD CONSTRAINT R_7 FOREIGN KEY (Табельный_номер_сотрудника) REFERENCES Сотрудник(Табельный_номер_сотрудника)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Заказ
	ADD CONSTRAINT R_2 FOREIGN KEY (Код_клиента) REFERENCES Клиент(Код_клиента)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Заказ
	ADD CONSTRAINT R_3 FOREIGN KEY (Табельный_номер_сотрудника) REFERENCES Сотрудник(Табельный_номер_сотрудника)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Счет_на_оплату
	ADD CONSTRAINT R_12 FOREIGN KEY (nom_договор) REFERENCES Договор(nom_договор)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Счет_на_оплату
	ADD CONSTRAINT R_13 FOREIGN KEY (Табельный_номер_сотрудника) REFERENCES Сотрудник(Табельный_номер_сотрудника)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Услуга_в_договоре
	ADD CONSTRAINT R_10 FOREIGN KEY (nom_договор) REFERENCES Договор(nom_договор)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Услуга_в_договоре
	ADD CONSTRAINT R_11 FOREIGN KEY (Код_услуга) REFERENCES Услуга(Код_услуга)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Услуга_в_заказе
	ADD CONSTRAINT R_4 FOREIGN KEY (nom_заказа) REFERENCES Заказ(nom_заказа)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Услуга_в_заказе
	ADD CONSTRAINT R_5 FOREIGN KEY (Код_услуга) REFERENCES Услуга(Код_услуга)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




CREATE TRIGGER tD_Договор ON Договор FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Договор */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Договор  Услуга_в_договоре on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000474bb", PARENT_OWNER="", PARENT_TABLE="Договор"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_договоре"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="nom_договор" */
    IF EXISTS (
      SELECT * FROM deleted,Услуга_в_договоре
      WHERE
        /*  %JoinFKPK(Услуга_в_договоре,deleted," = "," AND") */
        Услуга_в_договоре.nom_договор = deleted.nom_договор
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Договор because Услуга_в_договоре exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Договор  Счет_на_оплату on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Договор"
    CHILD_OWNER="", CHILD_TABLE="Счет_на_оплату"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="nom_договор" */
    IF EXISTS (
      SELECT * FROM deleted,Счет_на_оплату
      WHERE
        /*  %JoinFKPK(Счет_на_оплату,deleted," = "," AND") */
        Счет_на_оплату.nom_договор = deleted.nom_договор
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Договор because Счет_на_оплату exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Сотрудник  Договор on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Договор"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Табельный_номер_сотрудника" */
    IF EXISTS (SELECT * FROM deleted,Сотрудник
      WHERE
        /* %JoinFKPK(deleted,Сотрудник," = "," AND") */
        deleted.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника AND
        NOT EXISTS (
          SELECT * FROM Договор
          WHERE
            /* %JoinFKPK(Договор,Сотрудник," = "," AND") */
            Договор.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Договор because Сотрудник exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Заказ  Договор on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Договор"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="nom_заказа" */
    IF EXISTS (SELECT * FROM deleted,Заказ
      WHERE
        /* %JoinFKPK(deleted,Заказ," = "," AND") */
        deleted.nom_заказа = Заказ.nom_заказа AND
        NOT EXISTS (
          SELECT * FROM Договор
          WHERE
            /* %JoinFKPK(Договор,Заказ," = "," AND") */
            Договор.nom_заказа = Заказ.nom_заказа
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Договор because Заказ exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go


CREATE TRIGGER tU_Договор ON Договор FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Договор */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insnom_договор integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Договор  Услуга_в_договоре on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00051a59", PARENT_OWNER="", PARENT_TABLE="Договор"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_договоре"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="nom_договор" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(nom_договор)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Услуга_в_договоре
      WHERE
        /*  %JoinFKPK(Услуга_в_договоре,deleted," = "," AND") */
        Услуга_в_договоре.nom_договор = deleted.nom_договор
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Договор because Услуга_в_договоре exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Договор  Счет_на_оплату on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Договор"
    CHILD_OWNER="", CHILD_TABLE="Счет_на_оплату"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="nom_договор" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(nom_договор)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Счет_на_оплату
      WHERE
        /*  %JoinFKPK(Счет_на_оплату,deleted," = "," AND") */
        Счет_на_оплату.nom_договор = deleted.nom_договор
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Договор because Счет_на_оплату exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Сотрудник  Договор on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Договор"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Табельный_номер_сотрудника" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Табельный_номер_сотрудника)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Сотрудник
        WHERE
          /* %JoinFKPK(inserted,Сотрудник) */
          inserted.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Табельный_номер_сотрудника IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Договор because Сотрудник does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Заказ  Договор on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Договор"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="nom_заказа" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(nom_заказа)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Заказ
        WHERE
          /* %JoinFKPK(inserted,Заказ) */
          inserted.nom_заказа = Заказ.nom_заказа
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.nom_заказа IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Договор because Заказ does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go




CREATE TRIGGER tD_Журнал ON Журнал FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Журнал */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Заказ  Журнал on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002705e", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Журнал"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="nom_заказа" */
    IF EXISTS (SELECT * FROM deleted,Заказ
      WHERE
        /* %JoinFKPK(deleted,Заказ," = "," AND") */
        deleted.nom_заказа = Заказ.nom_заказа AND
        NOT EXISTS (
          SELECT * FROM Журнал
          WHERE
            /* %JoinFKPK(Журнал,Заказ," = "," AND") */
            Журнал.nom_заказа = Заказ.nom_заказа
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Журнал because Заказ exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Сотрудник  Журнал on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Журнал"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Табельный_номер_сотрудника" */
    IF EXISTS (SELECT * FROM deleted,Сотрудник
      WHERE
        /* %JoinFKPK(deleted,Сотрудник," = "," AND") */
        deleted.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника AND
        NOT EXISTS (
          SELECT * FROM Журнал
          WHERE
            /* %JoinFKPK(Журнал,Сотрудник," = "," AND") */
            Журнал.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Журнал because Сотрудник exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go


CREATE TRIGGER tU_Журнал ON Журнал FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Журнал */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insnom_заказа integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Заказ  Журнал on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002c3d6", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Журнал"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="nom_заказа" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(nom_заказа)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Заказ
        WHERE
          /* %JoinFKPK(inserted,Заказ) */
          inserted.nom_заказа = Заказ.nom_заказа
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Журнал because Заказ does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Сотрудник  Журнал on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Журнал"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Табельный_номер_сотрудника" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Табельный_номер_сотрудника)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Сотрудник
        WHERE
          /* %JoinFKPK(inserted,Сотрудник) */
          inserted.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Табельный_номер_сотрудника IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Журнал because Сотрудник does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go




CREATE TRIGGER tD_Заказ ON Заказ FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Заказ */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Заказ  Услуга_в_заказе on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0005386c", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_заказе"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="nom_заказа" */
    IF EXISTS (
      SELECT * FROM deleted,Услуга_в_заказе
      WHERE
        /*  %JoinFKPK(Услуга_в_заказе,deleted," = "," AND") */
        Услуга_в_заказе.nom_заказа = deleted.nom_заказа
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Заказ because Услуга_в_заказе exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Заказ  Журнал on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Журнал"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="nom_заказа" */
    IF EXISTS (
      SELECT * FROM deleted,Журнал
      WHERE
        /*  %JoinFKPK(Журнал,deleted," = "," AND") */
        Журнал.nom_заказа = deleted.nom_заказа
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Заказ because Журнал exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Заказ  Договор on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Договор"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="nom_заказа" */
    IF EXISTS (
      SELECT * FROM deleted,Договор
      WHERE
        /*  %JoinFKPK(Договор,deleted," = "," AND") */
        Договор.nom_заказа = deleted.nom_заказа
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Заказ because Договор exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Клиент  Заказ on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Клиент"
    CHILD_OWNER="", CHILD_TABLE="Заказ"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Код_клиента" */
    IF EXISTS (SELECT * FROM deleted,Клиент
      WHERE
        /* %JoinFKPK(deleted,Клиент," = "," AND") */
        deleted.Код_клиента = Клиент.Код_клиента AND
        NOT EXISTS (
          SELECT * FROM Заказ
          WHERE
            /* %JoinFKPK(Заказ,Клиент," = "," AND") */
            Заказ.Код_клиента = Клиент.Код_клиента
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Заказ because Клиент exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Сотрудник  Заказ on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Заказ"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Табельный_номер_сотрудника" */
    IF EXISTS (SELECT * FROM deleted,Сотрудник
      WHERE
        /* %JoinFKPK(deleted,Сотрудник," = "," AND") */
        deleted.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника AND
        NOT EXISTS (
          SELECT * FROM Заказ
          WHERE
            /* %JoinFKPK(Заказ,Сотрудник," = "," AND") */
            Заказ.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Заказ because Сотрудник exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go


CREATE TRIGGER tU_Заказ ON Заказ FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Заказ */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insnom_заказа integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Заказ  Услуга_в_заказе on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0006043d", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_заказе"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="nom_заказа" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(nom_заказа)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Услуга_в_заказе
      WHERE
        /*  %JoinFKPK(Услуга_в_заказе,deleted," = "," AND") */
        Услуга_в_заказе.nom_заказа = deleted.nom_заказа
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Заказ because Услуга_в_заказе exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Заказ  Журнал on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Журнал"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="nom_заказа" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(nom_заказа)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Журнал
      WHERE
        /*  %JoinFKPK(Журнал,deleted," = "," AND") */
        Журнал.nom_заказа = deleted.nom_заказа
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Заказ because Журнал exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Заказ  Договор on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Договор"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="nom_заказа" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(nom_заказа)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Договор
      WHERE
        /*  %JoinFKPK(Договор,deleted," = "," AND") */
        Договор.nom_заказа = deleted.nom_заказа
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Заказ because Договор exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Клиент  Заказ on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Клиент"
    CHILD_OWNER="", CHILD_TABLE="Заказ"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Код_клиента" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Код_клиента)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Клиент
        WHERE
          /* %JoinFKPK(inserted,Клиент) */
          inserted.Код_клиента = Клиент.Код_клиента
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Код_клиента IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Заказ because Клиент does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Сотрудник  Заказ on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Заказ"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Табельный_номер_сотрудника" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Табельный_номер_сотрудника)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Сотрудник
        WHERE
          /* %JoinFKPK(inserted,Сотрудник) */
          inserted.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Табельный_номер_сотрудника IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Заказ because Сотрудник does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go




CREATE TRIGGER tD_Клиент ON Клиент FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Клиент */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Клиент  Заказ on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0000dee0", PARENT_OWNER="", PARENT_TABLE="Клиент"
    CHILD_OWNER="", CHILD_TABLE="Заказ"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Код_клиента" */
    IF EXISTS (
      SELECT * FROM deleted,Заказ
      WHERE
        /*  %JoinFKPK(Заказ,deleted," = "," AND") */
        Заказ.Код_клиента = deleted.Код_клиента
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Клиент because Заказ exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go


CREATE TRIGGER tU_Клиент ON Клиент FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Клиент */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insКод_клиента integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Клиент  Заказ on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00010692", PARENT_OWNER="", PARENT_TABLE="Клиент"
    CHILD_OWNER="", CHILD_TABLE="Заказ"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Код_клиента" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_клиента)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Заказ
      WHERE
        /*  %JoinFKPK(Заказ,deleted," = "," AND") */
        Заказ.Код_клиента = deleted.Код_клиента
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Клиент because Заказ exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go




CREATE TRIGGER tD_Сотрудник ON Сотрудник FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Сотрудник */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Сотрудник  Заказ on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000407d4", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Заказ"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Табельный_номер_сотрудника" */
    IF EXISTS (
      SELECT * FROM deleted,Заказ
      WHERE
        /*  %JoinFKPK(Заказ,deleted," = "," AND") */
        Заказ.Табельный_номер_сотрудника = deleted.Табельный_номер_сотрудника
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Сотрудник because Заказ exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Сотрудник  Журнал on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Журнал"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Табельный_номер_сотрудника" */
    IF EXISTS (
      SELECT * FROM deleted,Журнал
      WHERE
        /*  %JoinFKPK(Журнал,deleted," = "," AND") */
        Журнал.Табельный_номер_сотрудника = deleted.Табельный_номер_сотрудника
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Сотрудник because Журнал exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Сотрудник  Договор on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Договор"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Табельный_номер_сотрудника" */
    IF EXISTS (
      SELECT * FROM deleted,Договор
      WHERE
        /*  %JoinFKPK(Договор,deleted," = "," AND") */
        Договор.Табельный_номер_сотрудника = deleted.Табельный_номер_сотрудника
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Сотрудник because Договор exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Сотрудник  Счет_на_оплату on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Счет_на_оплату"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="Табельный_номер_сотрудника" */
    IF EXISTS (
      SELECT * FROM deleted,Счет_на_оплату
      WHERE
        /*  %JoinFKPK(Счет_на_оплату,deleted," = "," AND") */
        Счет_на_оплату.Табельный_номер_сотрудника = deleted.Табельный_номер_сотрудника
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Сотрудник because Счет_на_оплату exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go


CREATE TRIGGER tU_Сотрудник ON Сотрудник FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Сотрудник */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insТабельный_номер_сотрудника integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Сотрудник  Заказ on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0004ac4b", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Заказ"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Табельный_номер_сотрудника" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Табельный_номер_сотрудника)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Заказ
      WHERE
        /*  %JoinFKPK(Заказ,deleted," = "," AND") */
        Заказ.Табельный_номер_сотрудника = deleted.Табельный_номер_сотрудника
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Сотрудник because Заказ exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Сотрудник  Журнал on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Журнал"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Табельный_номер_сотрудника" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Табельный_номер_сотрудника)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Журнал
      WHERE
        /*  %JoinFKPK(Журнал,deleted," = "," AND") */
        Журнал.Табельный_номер_сотрудника = deleted.Табельный_номер_сотрудника
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Сотрудник because Журнал exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Сотрудник  Договор on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Договор"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="Табельный_номер_сотрудника" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Табельный_номер_сотрудника)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Договор
      WHERE
        /*  %JoinFKPK(Договор,deleted," = "," AND") */
        Договор.Табельный_номер_сотрудника = deleted.Табельный_номер_сотрудника
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Сотрудник because Договор exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Сотрудник  Счет_на_оплату on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Счет_на_оплату"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="Табельный_номер_сотрудника" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Табельный_номер_сотрудника)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Счет_на_оплату
      WHERE
        /*  %JoinFKPK(Счет_на_оплату,deleted," = "," AND") */
        Счет_на_оплату.Табельный_номер_сотрудника = deleted.Табельный_номер_сотрудника
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Сотрудник because Счет_на_оплату exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go




CREATE TRIGGER tD_Счет_на_оплату ON Счет_на_оплату FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Счет_на_оплату */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Договор  Счет_на_оплату on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002a986", PARENT_OWNER="", PARENT_TABLE="Договор"
    CHILD_OWNER="", CHILD_TABLE="Счет_на_оплату"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="nom_договор" */
    IF EXISTS (SELECT * FROM deleted,Договор
      WHERE
        /* %JoinFKPK(deleted,Договор," = "," AND") */
        deleted.nom_договор = Договор.nom_договор AND
        NOT EXISTS (
          SELECT * FROM Счет_на_оплату
          WHERE
            /* %JoinFKPK(Счет_на_оплату,Договор," = "," AND") */
            Счет_на_оплату.nom_договор = Договор.nom_договор
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Счет_на_оплату because Договор exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Сотрудник  Счет_на_оплату on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Счет_на_оплату"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="Табельный_номер_сотрудника" */
    IF EXISTS (SELECT * FROM deleted,Сотрудник
      WHERE
        /* %JoinFKPK(deleted,Сотрудник," = "," AND") */
        deleted.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника AND
        NOT EXISTS (
          SELECT * FROM Счет_на_оплату
          WHERE
            /* %JoinFKPK(Счет_на_оплату,Сотрудник," = "," AND") */
            Счет_на_оплату.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Счет_на_оплату because Сотрудник exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go


CREATE TRIGGER tU_Счет_на_оплату ON Счет_на_оплату FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Счет_на_оплату */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insnom_счета_на_оплату integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Договор  Счет_на_оплату on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002ff52", PARENT_OWNER="", PARENT_TABLE="Договор"
    CHILD_OWNER="", CHILD_TABLE="Счет_на_оплату"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="nom_договор" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(nom_договор)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Договор
        WHERE
          /* %JoinFKPK(inserted,Договор) */
          inserted.nom_договор = Договор.nom_договор
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.nom_договор IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Счет_на_оплату because Договор does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Сотрудник  Счет_на_оплату on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Сотрудник"
    CHILD_OWNER="", CHILD_TABLE="Счет_на_оплату"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="Табельный_номер_сотрудника" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Табельный_номер_сотрудника)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Сотрудник
        WHERE
          /* %JoinFKPK(inserted,Сотрудник) */
          inserted.Табельный_номер_сотрудника = Сотрудник.Табельный_номер_сотрудника
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Табельный_номер_сотрудника IS NULL
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Счет_на_оплату because Сотрудник does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go




CREATE TRIGGER tD_Услуга ON Услуга FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Услуга */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Услуга  Услуга_в_заказе on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00020c42", PARENT_OWNER="", PARENT_TABLE="Услуга"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_заказе"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Код_услуга" */
    IF EXISTS (
      SELECT * FROM deleted,Услуга_в_заказе
      WHERE
        /*  %JoinFKPK(Услуга_в_заказе,deleted," = "," AND") */
        Услуга_в_заказе.Код_услуга = deleted.Код_услуга
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Услуга because Услуга_в_заказе exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Услуга  Услуга_в_договоре on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Услуга"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_договоре"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Код_услуга" */
    IF EXISTS (
      SELECT * FROM deleted,Услуга_в_договоре
      WHERE
        /*  %JoinFKPK(Услуга_в_договоре,deleted," = "," AND") */
        Услуга_в_договоре.Код_услуга = deleted.Код_услуга
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Услуга because Услуга_в_договоре exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go


CREATE TRIGGER tU_Услуга ON Услуга FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Услуга */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insКод_услуга integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Услуга  Услуга_в_заказе on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00023eb1", PARENT_OWNER="", PARENT_TABLE="Услуга"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_заказе"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Код_услуга" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_услуга)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Услуга_в_заказе
      WHERE
        /*  %JoinFKPK(Услуга_в_заказе,deleted," = "," AND") */
        Услуга_в_заказе.Код_услуга = deleted.Код_услуга
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Услуга because Услуга_в_заказе exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Услуга  Услуга_в_договоре on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Услуга"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_договоре"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Код_услуга" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Код_услуга)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Услуга_в_договоре
      WHERE
        /*  %JoinFKPK(Услуга_в_договоре,deleted," = "," AND") */
        Услуга_в_договоре.Код_услуга = deleted.Код_услуга
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Услуга because Услуга_в_договоре exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go




CREATE TRIGGER tD_Услуга_в_договоре ON Услуга_в_договоре FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Услуга_в_договоре */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Договор  Услуга_в_договоре on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002763b", PARENT_OWNER="", PARENT_TABLE="Договор"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_договоре"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="nom_договор" */
    IF EXISTS (SELECT * FROM deleted,Договор
      WHERE
        /* %JoinFKPK(deleted,Договор," = "," AND") */
        deleted.nom_договор = Договор.nom_договор AND
        NOT EXISTS (
          SELECT * FROM Услуга_в_договоре
          WHERE
            /* %JoinFKPK(Услуга_в_договоре,Договор," = "," AND") */
            Услуга_в_договоре.nom_договор = Договор.nom_договор
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Услуга_в_договоре because Договор exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Услуга  Услуга_в_договоре on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Услуга"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_договоре"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Код_услуга" */
    IF EXISTS (SELECT * FROM deleted,Услуга
      WHERE
        /* %JoinFKPK(deleted,Услуга," = "," AND") */
        deleted.Код_услуга = Услуга.Код_услуга AND
        NOT EXISTS (
          SELECT * FROM Услуга_в_договоре
          WHERE
            /* %JoinFKPK(Услуга_в_договоре,Услуга," = "," AND") */
            Услуга_в_договоре.Код_услуга = Услуга.Код_услуга
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Услуга_в_договоре because Услуга exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go


CREATE TRIGGER tU_Услуга_в_договоре ON Услуга_в_договоре FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Услуга_в_договоре */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insnom_договор integer, 
           @insКод_услуга integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Договор  Услуга_в_договоре on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00029a30", PARENT_OWNER="", PARENT_TABLE="Договор"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_договоре"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="nom_договор" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(nom_договор)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Договор
        WHERE
          /* %JoinFKPK(inserted,Договор) */
          inserted.nom_договор = Договор.nom_договор
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Услуга_в_договоре because Договор does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Услуга  Услуга_в_договоре on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Услуга"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_договоре"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Код_услуга" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Код_услуга)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Услуга
        WHERE
          /* %JoinFKPK(inserted,Услуга) */
          inserted.Код_услуга = Услуга.Код_услуга
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Услуга_в_договоре because Услуга does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go




CREATE TRIGGER tD_Услуга_в_заказе ON Услуга_в_заказе FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Услуга_в_заказе */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Заказ  Услуга_в_заказе on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00025718", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_заказе"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="nom_заказа" */
    IF EXISTS (SELECT * FROM deleted,Заказ
      WHERE
        /* %JoinFKPK(deleted,Заказ," = "," AND") */
        deleted.nom_заказа = Заказ.nom_заказа AND
        NOT EXISTS (
          SELECT * FROM Услуга_в_заказе
          WHERE
            /* %JoinFKPK(Услуга_в_заказе,Заказ," = "," AND") */
            Услуга_в_заказе.nom_заказа = Заказ.nom_заказа
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Услуга_в_заказе because Заказ exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Услуга  Услуга_в_заказе on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Услуга"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_заказе"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Код_услуга" */
    IF EXISTS (SELECT * FROM deleted,Услуга
      WHERE
        /* %JoinFKPK(deleted,Услуга," = "," AND") */
        deleted.Код_услуга = Услуга.Код_услуга AND
        NOT EXISTS (
          SELECT * FROM Услуга_в_заказе
          WHERE
            /* %JoinFKPK(Услуга_в_заказе,Услуга," = "," AND") */
            Услуга_в_заказе.Код_услуга = Услуга.Код_услуга
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Услуга_в_заказе because Услуга exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go


CREATE TRIGGER tU_Услуга_в_заказе ON Услуга_в_заказе FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Услуга_в_заказе */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insnom_заказа integer, 
           @insКод_услуга integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Заказ  Услуга_в_заказе on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002979b", PARENT_OWNER="", PARENT_TABLE="Заказ"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_заказе"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="nom_заказа" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(nom_заказа)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Заказ
        WHERE
          /* %JoinFKPK(inserted,Заказ) */
          inserted.nom_заказа = Заказ.nom_заказа
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Услуга_в_заказе because Заказ does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Услуга  Услуга_в_заказе on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Услуга"
    CHILD_OWNER="", CHILD_TABLE="Услуга_в_заказе"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Код_услуга" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Код_услуга)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Услуга
        WHERE
          /* %JoinFKPK(inserted,Услуга) */
          inserted.Код_услуга = Услуга.Код_услуга
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Услуга_в_заказе because Услуга does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror (@errmsg, @errno,1)
    rollback transaction
END

go